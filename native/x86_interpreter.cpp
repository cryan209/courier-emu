// Non-JIT 16-bit interpreter. An instruction commits only after all data
// accesses pass the mapping/watchpoint guards. Otherwise Python executes it.
#include <cstdint>
#include <cstring>
#include <csetjmp>
namespace {
enum { AX,CX,DX,BX,SP,BP,SI,DI,ES,CS,SS,DS,IP,F };
constexpr uint32_t CF=1, PF=4, AF=16, ZF=64, SF=128, IF=512, DF=1024, OF=2048;
struct Core {
    uint32_t r[14], saved[14], done=0, reason=0;
    std::jmp_buf exit;
    [[noreturn]] void yield(uint32_t why=1) { reason=why; std::longjmp(exit, 1); }
    uint8_t *mem; const uint8_t *guard; uint32_t mask;
    bool is386=false; int width=2;
    int seg=-1; struct Write { uint32_t address,value; int size; };
    Write writes[8]; int nw=0;
    uint32_t phys(uint32_t s,uint32_t o) { return ((s&65535)*16+(o&65535))&mask; }
    uint32_t fetch(int n=1) { uint32_t v=0; for(int i=0;i<n;++i) {v|=uint32_t(mem[phys(r[CS],r[IP])])<<(i*8); r[IP]=(r[IP]+1)&65535;} return v; }
    void check(uint32_t a,int n,int p) {
        if(a+unsigned(n)>mask+1) yield(2);
        // Mapping regions are page-aligned. Watched bytes force a fallback,
        // including straddling accesses (conservative w.r.t. Python hooks).
        for(int i=0;i<n;++i) if(!(guard[a+i]&p) || (guard[a+i]&(p==1?16:32))) yield(p==1?3:4);
    }
    uint32_t load(uint32_t a,int n) {check(a,n,1); uint32_t v=mem[a]; if(n>=2)v|=uint32_t(mem[a+1])<<8; if(n==4)v|=uint32_t(mem[a+2])<<16|uint32_t(mem[a+3])<<24; return v;}
    void store(uint32_t a,int n,uint32_t v) {check(a,n,2); if(nw==8)yield(); writes[nw++]={a,v,n};}
    uint32_t get(int k,int n) {return n==1?(r[k&3]>>((k&4)?8:0))&255:r[k];}
    void put(int k,int n,uint32_t v) {if(n==1){int sh=(k&4)?8:0; r[k&3]=(r[k&3]&~(255u<<sh))|((v&255)<<sh);}else r[k]=n==4?v:v&65535;}
    uint32_t ea(int m) {
        int mod=m>>6,rm=m&7; uint32_t o; bool bp=false;
        if(mod==0&&rm==6)o=fetch(2);
        else {switch(rm){case 0:o=r[BX]+r[SI];break;case 1:o=r[BX]+r[DI];break;case 2:o=r[BP]+r[SI];bp=true;break;case 3:o=r[BP]+r[DI];bp=true;break;case 4:o=r[SI];break;case 5:o=r[DI];break;case 6:o=r[BP];bp=true;break;default:o=r[BX];}
            if(mod==1)o+=int8_t(fetch());else if(mod==2)o+=int16_t(fetch(2));}
        return phys(seg<0?r[bp?SS:DS]:uint32_t(seg),o);
    }
    uint32_t read(int m,int n,uint32_t a){return m>=192?get(m&7,n):load(a,n);}
    void write(int m,int n,uint32_t a,uint32_t v){if(m>=192)put(m&7,n,v);else store(a,n,v);}
    uint32_t alu(int op,uint32_t l,uint32_t q,int n) {
        uint32_t mask=n==1?255:65535, sign=(mask+1)>>1, flags=r[F]&~(CF|PF|AF|ZF|SF|OF), v;
        if(op==1)v=(l|q)&mask;else if(op==4)v=(l&q)&mask;else if(op==6)v=(l^q)&mask;
        else {uint32_t adj=q+((op==2||op==3)?(r[F]&CF):0); bool add=op==0||op==2; v=(add?l+adj:l-adj)&mask;
            if(add){if(l+adj>mask)flags|=CF;if((~(l^adj)&(l^v)&sign))flags|=OF;}
            else {if(l<adj)flags|=CF;if(((l^adj)&(l^v)&sign))flags|=OF;}
            if((l^adj^v)&16)flags|=AF;}
        if(!v)flags|=ZF;if(v&sign)flags|=SF;if(!__builtin_parity(v&255))flags|=PF;r[F]=flags|2;return v;
    }
    bool cond(int c){uint32_t f=r[F];switch(c){case 0:return f&OF;case 1:return !(f&OF);case 2:return f&CF;case 3:return !(f&CF);case 4:return f&ZF;case 5:return !(f&ZF);case 6:return f&(CF|ZF);case 7:return !(f&(CF|ZF));case 8:return f&SF;case 9:return !(f&SF);case 10:return f&PF;case 11:return !(f&PF);case 12:return bool(f&SF)!=bool(f&OF);case 13:return bool(f&SF)==bool(f&OF);case 14:return (f&ZF)||bool(f&SF)!=bool(f&OF);default:return !(f&ZF)&&bool(f&SF)==bool(f&OF);}}
    void push(uint32_t v){r[SP]=(r[SP]-2)&65535;store(phys(r[SS],r[SP]),2,v);}
    uint32_t pop(){uint32_t v=load(phys(r[SS],r[SP]),2);r[SP]=(r[SP]+2)&65535;return v;}
    void step(){
        uint32_t start=r[IP];int op=fetch(),rep=0;seg=-1;nw=0;width=2;
        for(int prefixes=0;;++prefixes){
            if(prefixes==15)yield();
            if(op==0x26)seg=r[ES];else if(op==0x2e)seg=r[CS];else if(op==0x36)seg=r[SS];else if(op==0x3e)seg=r[DS];else if(op==0x66&&is386)width=4;else if(op==0xf2||op==0xf3)rep=op;else if(op!=0xf0)break;op=fetch();
        }
        // The shared 16-bit core must not truncate live extended registers.
        // Wider moves and strings are supported explicitly; other mixed-width
        // operations stay in the reference engine until their semantics match.
        bool wide_move=(op>=0xb0&&op<=0xbf)||(op>=0x88&&op<=0x8b)||
            op==0xc6||op==0xc7||(op>=0xa4&&op<=0xa5)||(op>=0xaa&&op<=0xad);
        if(width==4&&!wide_move)yield();
        if(is386){
            uint32_t high=0;for(int k=0;k<8;++k)high|=r[k];
            if((high>>16)&&!wide_move)yield(5);
            if(wide_move&&(op==0xa4||op==0xa5||(op>=0xaa&&op<=0xad))&&
               ((r[SI]|r[DI]|r[CX])>>16))yield();
            if(op==0x98||op==0x99)yield();
        }
        if(op<0x40 && (op&7)<6){int operation=(op>>3)&7,n=(op&1)?2:1;uint32_t l,q,a=0;int m=0,k=0;
            if((op&7)<4){m=fetch();k=(m>>3)&7;if(m<192)a=ea(m);l=read(m,n,a);q=get(k,n);if(op&2){uint32_t t=l;l=q;q=t;}}
            else {l=get(0,n);q=fetch(n);}
            uint32_t v=alu(operation,l,q,n);if(operation!=7){if((op&7)>=4)put(0,n,v);else if(op&2)put(k,n,v);else write(m,n,a,v);}return;}
        if(op>=0x40&&op<=0x4f){int k=op&7;uint32_t cf=r[F]&CF;put(k,2,alu(op<0x48?0:5,r[k],1,2));r[F]=(r[F]&~CF)|cf;return;}
        if(op>=0x50&&op<=0x57){push(r[op&7]);return;}
        if(op>=0x58&&op<=0x5f){r[op&7]=pop();return;}
        if(op>=0x70&&op<=0x7f){int d=int8_t(fetch());if(cond(op&15))r[IP]=(r[IP]+d)&65535;return;}
        if(op>=0xb0&&op<=0xbf){int n=op<0xb8?1:width;put(op&7,n,fetch(n));return;}
        if(op>=0x90&&op<=0x97){uint32_t t=r[AX];r[AX]=r[op&7];r[op&7]=t;return;}
        switch(op){
        case 0x80:case 0x81:case 0x83:{int m=fetch(),n=op==0x80?1:2,k=(m>>3)&7;uint32_t a=m<192?ea(m):0,q=op==0x83?uint32_t(int8_t(fetch()))&65535:fetch(n);uint32_t v=alu(k,read(m,n,a),q,n);if(k!=7)write(m,n,a,v);break;}
        case 0x84:case 0x85:case 0x86:case 0x87:case 0x88:case 0x89:case 0x8a:case 0x8b:{int m=fetch(),n=(op&1)?width:1,k=(m>>3)&7;uint32_t a=m<192?ea(m):0;
            if(op<0x86)alu(4,read(m,n,a),get(k,n),n);
            else if(op<0x88){uint32_t v=read(m,n,a);write(m,n,a,get(k,n));put(k,n,v);}
            else if(is386&&n==2&&m>=192){if(op&2)r[k]=r[m&7];else r[m&7]=r[k];}
            else if(op&2)put(k,n,read(m,n,a));else write(m,n,a,get(k,n));break;}
        case 0x8c:case 0x8e:{int m=fetch(),k=ES+((m>>3)&3);uint32_t a=m<192?ea(m):0;if(op==0x8c)write(m,2,a,r[k]);else r[k]=read(m,2,a);break;}
        case 0x8d:{int m=fetch();if(m>=192)yield();int oldseg=seg;seg=0;uint32_t a=ea(m);seg=oldseg;r[(m>>3)&7]=a&65535;break;}
        case 0xa0:case 0xa1:case 0xa2:case 0xa3:{int n=(op&1)?2:1;uint32_t a=phys(seg<0?r[DS]:seg,fetch(2));if(op&2)store(a,n,get(0,n));else put(0,n,load(a,n));break;}
        case 0xa4:case 0xa5:case 0xaa:case 0xab:case 0xac:case 0xad:{if(rep&&!r[CX])break;int n=(op&1)?width:1,form=(op>>1)&7,delta=(r[F]&DF)?-n:n;uint32_t v;
            if(form!=5){v=load(phys(seg<0?r[DS]:seg,r[SI]),n);r[SI]=(r[SI]+delta)&65535;}else v=get(0,n);
            if(form!=6){store(phys(r[ES],r[DI]),n,v);r[DI]=(r[DI]+delta)&65535;}else put(0,n,v);
            if(rep){r[CX]=(r[CX]-1)&65535;r[IP]=start;}break;}
        case 0xa8:case 0xa9:{int n=(op&1)?2:1;alu(4,get(0,n),fetch(n),n);break;}
        case 0xf6:case 0xf7:{
            int m=fetch(),k=(m>>3)&7,n=(op&1)?2:1,bits=n*8;uint32_t mask=n==1?255:65535,a=m<192?ea(m):0,v=read(m,n,a);
            if(is386&&k>=4)yield();
            if(k==0)alu(4,v,fetch(n),n);
            else if(k==2)write(m,n,a,~v);
            else if(k==3)write(m,n,a,alu(5,0,v,n));
            else if(k==4||k==5){
                int64_t product;
                if(k==4)product=int64_t(get(0,n))*v;
                else product=int64_t(n==1?int8_t(get(0,n)):int16_t(get(0,n)))*(n==1?int8_t(v):int16_t(v));
                r[AX]=product&65535;if(n==2)r[DX]=(uint64_t(product)>>16)&65535;
                bool overflow=k==4?bool(uint64_t(product)>>bits):product!=(n==1?int8_t(product):int16_t(product));
                r[F]=(r[F]&~(CF|OF))|(overflow?(CF|OF):0);
            }else if(k==6){uint32_t dividend=n==1?r[AX]:(r[DX]<<16)|r[AX];if(!v||dividend/v>mask)yield();uint32_t q=dividend/v,rem=dividend%v;if(n==1)r[AX]=q|(rem<<8);else{r[AX]=q;r[DX]=rem;}}
            else if(k==7){int64_t dividend=n==1?int16_t(r[AX]):int32_t((r[DX]<<16)|r[AX]);int64_t divisor=n==1?int8_t(v):int16_t(v);if(!divisor)yield();int64_t q=dividend/divisor,rem=dividend%divisor;if(q<-(1LL<<(bits-1))||q>=(1LL<<(bits-1)))yield();if(n==1)r[AX]=(q&255)|((rem&255)<<8);else{r[AX]=q&65535;r[DX]=rem&65535;}}
            else yield();break;}
        case 0xa6:case 0xa7:case 0xae:case 0xaf:{
            if(rep&&!r[CX])break;int n=(op&1)?2:1,delta=(r[F]&DF)?-n:n;uint32_t left=get(0,n);
            if(op<0xae){left=load(phys(seg<0?r[DS]:seg,r[SI]),n);r[SI]=(r[SI]+delta)&65535;}
            alu(7,left,load(phys(r[ES],r[DI]),n),n);r[DI]=(r[DI]+delta)&65535;
            if(rep){r[CX]=(r[CX]-1)&65535;if(r[CX]&&(rep==0xf3?bool(r[F]&ZF):!(r[F]&ZF)))r[IP]=start;}break;}
        case 0x60:{uint32_t sp=r[SP];for(int k=AX;k<=BX;++k)push(r[k]);push(sp);for(int k=BP;k<=DI;++k)push(r[k]);break;}
        case 0x61:{for(int k=DI;k>=BP;--k)r[k]=pop();pop();for(int k=BX;k>=AX;--k)r[k]=pop();break;}
        case 0x9a:{uint32_t off=fetch(2),cs=fetch(2);push(r[CS]);push(r[IP]);r[CS]=cs;r[IP]=off;break;}
        case 0xc4:case 0xc5:{int m=fetch();if(m>=192)yield();uint32_t a=ea(m),v=load(a,2),s=load(a+2,2);r[(m>>3)&7]=v;r[op==0xc4?ES:DS]=s;break;}
        case 0xcf:r[IP]=pop();r[CS]=pop();r[F]=pop()|2;break;
        case 0xcb:r[IP]=pop();r[CS]=pop();break;
        case 0xc0:case 0xc1:case 0xd0:case 0xd1:case 0xd2:case 0xd3:{
            int m=fetch(),k=(m>>3)&7,n=(op&1)?2:1,bits=n*8;uint32_t a=m<192?ea(m):0,v=read(m,n,a);
            int count=((op==0xd0||op==0xd1)?1:(op==0xd2||op==0xd3)?r[CX]&255:fetch())&31;
            if(!count)break;
            uint32_t mask=n==1?255:65535,result=v,carry=r[F]&CF;
            if(k==0){int b=count%bits;result=((v<<b)|(v>>(bits-b)))&mask;carry=result&1;}
            else if(k==1){int b=count%bits;result=((v>>b)|(v<<(bits-b)))&mask;carry=(result>>(bits-1))&1;}
            else if(k==2){for(int i=0;i<count%(bits+1);++i){uint32_t next=(result>>(bits-1))&1;result=((result<<1)|carry)&mask;carry=next;}}
            else if(k==3){for(int i=0;i<count%(bits+1);++i){uint32_t next=result&1;result=(result>>1)|(carry<<(bits-1));carry=next;}}
            else if(k==4||k==6){carry=count<=bits?(v>>(bits-count))&1:0;result=v<<count;}
            else if(k==5){carry=count<=bits?(v>>(count-1))&1:0;result=v>>count;}
            else{carry=count<=bits?(v>>(count-1))&1:0;int32_t sv=n==1?int8_t(v):int16_t(v);result=uint32_t(sv>>count);}
            if(is386&&m>=192&&n==2)r[m&7]=result;else write(m,n,a,result);if(k>=4)alu(4,result,mask,n);r[F]=(r[F]&~CF)|carry;break;}
        case 0xc6:case 0xc7:{int m=fetch(),n=(op&1)?width:1;uint32_t a=m<192?ea(m):0,v=fetch(n);write(m,n,a,v);break;}
        case 0xc3:r[IP]=pop();break;
        case 0xc9:r[SP]=r[BP];r[BP]=pop();break;
        case 0xe8:{int d=int16_t(fetch(2));push(r[IP]);r[IP]=(r[IP]+d)&65535;break;}
        case 0xe9:case 0xeb:{int d=op==0xeb?int8_t(fetch()):int16_t(fetch(2));r[IP]=(r[IP]+d)&65535;break;}
        case 0xea:{uint32_t off=fetch(2);r[CS]=fetch(2);r[IP]=off;break;}
        case 0xe0:case 0xe1:case 0xe2:case 0xe3:{int d=int8_t(fetch());bool take;if(op==0xe3)take=!r[CX];else{r[CX]=(r[CX]-1)&65535;take=r[CX]&&(op==0xe2||(op==0xe0?!(r[F]&ZF):bool(r[F]&ZF)));}if(take)r[IP]=(r[IP]+d)&65535;break;}
        case 0xfe:case 0xff:{int m=fetch(),k=(m>>3)&7,n=op==0xfe?1:2;if(k>1&&(op==0xfe||k==7))yield();if((k==3||k==5)&&m>=192)yield();uint32_t a=m<192?ea(m):0,v=read(m,n,a);
            if(k<=1){uint32_t cf=r[F]&CF;v=alu(k?5:0,v,1,n);r[F]=(r[F]&~CF)|cf;write(m,n,a,v);}else if(k==2){push(r[IP]);r[IP]=v;}else if(k==3||k==5){uint32_t cs=load(a+2,2);if(k==3){push(r[CS]);push(r[IP]);}r[CS]=cs;r[IP]=v;}else if(k==4)r[IP]=v;else if(k==6)push(v);break;}
        case 0x06:case 0x0e:case 0x16:case 0x1e:push(r[ES+(op>>3)]);break;
        case 0x07:case 0x17:case 0x1f:r[ES+(op>>3)]=pop();break;
        case 0x68:push(fetch(2));break;case 0x6a:push(int8_t(fetch()));break;
        case 0x98:r[AX]=uint16_t(int16_t(int8_t(r[AX])));break;
        case 0x99:r[DX]=(r[AX]&0x8000)?65535:0;break;
        case 0x9b:break;case 0x9c:push(r[F]);break;case 0x9d:r[F]=pop()|2;break;
        case 0x9e:r[F]=(r[F]&~(CF|PF|AF|ZF|SF))|((r[AX]>>8)&(CF|PF|AF|ZF|SF))|2;break;
        case 0x9f:put(4,1,r[F]|2);break;
        case 0xf5:r[F]^=CF;break;case 0xf8:r[F]&=~CF;break;case 0xf9:r[F]|=CF;break;
        case 0xfa:r[F]&=~IF;break;case 0xfb:r[F]|=IF;break;case 0xfc:r[F]&=~DF;break;case 0xfd:r[F]|=DF;break;
        default:yield();
        }
    }
};
}
static uint32_t run_batch(Core &c, uint32_t count) {
    // One exit target per batch; guarded data accesses can abort without the
    // cost of exception unwinding at every memory-mapped device instruction.
    if (setjmp(c.exit)) {
        std::memcpy(c.r, c.saved, sizeof(c.r));
        return c.done;
    }
    for (c.done=0;c.done<count;++c.done) {
        uint32_t pc=c.phys(c.r[CS],c.r[IP]);
        if(c.guard[pc]&8){c.reason=6;break;}
        uint8_t opcode=c.mem[pc];
        if(opcode==0xec||opcode==0xed||opcode==0xee||opcode==0xef||
           opcode==0xe4||opcode==0xe5||opcode==0xe6||opcode==0xe7||
           opcode==0xcd||opcode==0x0f||opcode==0xf4)
            {c.reason=7;break;}
        std::memcpy(c.saved,c.r,sizeof(c.r));
        c.step();
        for(int j=0;j<c.nw;++j){const auto &w=c.writes[j];for(int i=0;i<w.size;++i)c.mem[w.address+i]=w.value>>(8*i);}
    }
    return c.done;
}
extern "C" uint32_t courier_x86_run(uint32_t *regs,uint8_t *mem,const uint8_t *guard,uint32_t mask,uint32_t count){
    Core c{};std::memcpy(c.r,regs,sizeof(c.r));c.mem=mem;c.guard=guard;c.mask=mask;c.is386=mask==0xffffff;
    uint32_t done=run_batch(c,count);
    std::memcpy(regs,c.r,sizeof(c.r));return done;
}

#include <Python.h>
static PyObject *run_python(PyObject *, PyObject *args) {
    PyObject *registers, *memory, *guard;
    unsigned int count;
    if (!PyArg_ParseTuple(args, "OOOI", &registers, &memory, &guard, &count)) return nullptr;
    if (!PyList_Check(registers) || PyList_GET_SIZE(registers)!=14 ||
        !PyByteArray_Check(memory) || !PyByteArray_Check(guard) ||
        PyByteArray_GET_SIZE(memory)!=PyByteArray_GET_SIZE(guard) ||
        (PyByteArray_GET_SIZE(memory)!=0x100000 && PyByteArray_GET_SIZE(memory)!=0x1000000)) {
        PyErr_SetString(PyExc_ValueError,"invalid native CPU buffers"); return nullptr;
    }
    Core c{};
    uint32_t original[14];
    for (int i=0;i<14;++i) {
        original[i]=c.r[i]=PyLong_AsUnsignedLong(PyList_GET_ITEM(registers,i));
        if(PyErr_Occurred())return nullptr;
    }
    c.mem=reinterpret_cast<uint8_t*>(PyByteArray_AS_STRING(memory));
    c.guard=reinterpret_cast<uint8_t*>(PyByteArray_AS_STRING(guard));
    c.mask=uint32_t(PyByteArray_GET_SIZE(memory)-1);
    c.is386=c.mask==0xffffff;
    uint32_t done=run_batch(c,count);
    // Convert each register once on entry; publish only changed registers.
    // Running directly on Core also avoids two redundant full-state copies.
    if(done)for(int i=0;i<14;++i){
        if(c.r[i]!=original[i]){
            PyObject *v=PyLong_FromUnsignedLong(c.r[i]);if(!v)return nullptr;
            PyList_SetItem(registers,i,v);
        }
    }
    return Py_BuildValue("II",done,c.reason);
}
static PyMethodDef methods[]={{"run",run_python,METH_VARARGS,"Execute guarded interpreter instructions."},{nullptr,nullptr,0,nullptr}};
static PyModuleDef module={PyModuleDef_HEAD_INIT,"_x86_native",nullptr,-1,methods,nullptr,nullptr,nullptr,nullptr};
PyMODINIT_FUNC PyInit__x86_native(){return PyModule_Create(&module);}
