/* Manual semantic reconstruction, QF060003 larger C300 overlay.
 * Implements the bit-ring, mixed-radix payload decoder, differential signs
 * and minimum-disparity search for 039F bit 7 clear, MD=0..6.
 * Negotiated banks must be constructed before mapping. Not vendor source.
 */
#include <stdint.h>
#include <limits.h>
static int32_t signed16(uint16_t x) { return x<32768u?(int32_t)x:(int32_t)x-65536; }
static uint32_t mask32(unsigned n) { return n==32?UINT32_MAX:n?((1u<<n)-1u):0; }
static uint32_t take(uint16_t d[65536],unsigned n) {
 unsigned cursor=d[0x3af],i=(cursor>>4)&7;
 uint32_t value=((uint32_t)d[0x248+((i+1)&7)]<<16)|d[0x248+i];
 d[0x3af]=(uint16_t)((cursor+n)&127);
 return value>>(cursor&15);
}
static uint32_t take_long(uint16_t d[65536],unsigned n) {
 if(n<=16)return take(d,n);
 uint32_t lo=take(d,16)&65535u,hi=take(d,n-16)&65535u;
 return (hi<<16)|lo;
}
/* 921B..923A, then B2BA..B2D8: scramble and append a source word. */
void payload_append(uint16_t d[65536]) {
 uint32_t value;
 if(d[0x6f]&1u){
  value=(uint32_t)(signed16(d[0x3d8])>>2)^d[0x3d9]^d[0x3d0];
  value=(value<<5)^value;
 }else value=(uint32_t)(signed16(d[0x3d9])>>5)^d[0x3d9]^d[0x3d0];
 value&=d[0x3d1];d[0x3d0]=(uint16_t)value;
 uint16_t high=(uint16_t)(d[0x3d8]|(value<<7));
 uint32_t history=(((uint32_t)high<<16)|d[0x3d9])>>(d[0x3d2]&15);
 d[0x3d8]=(uint16_t)(history>>16);d[0x3d9]=(uint16_t)history;
 unsigned cursor=d[0x3ae],i=(cursor>>4)&7;
 uint32_t packed=(d[0x248+i]&mask32(cursor&15))+(value<<(cursor&15));
 d[0x248+i]=(uint16_t)packed;
 unsigned next=(cursor+d[0x3d2])&127;d[0x3ae]=(uint16_t)next;
 if((next>>4)!=i)d[0x248+(next>>4)]=(uint16_t)(packed>>16);
}
/* C5DF..C641, including original bit extraction callees. */
void payload_unpack(uint16_t d[65536]) {
 d[0x3e3]=(uint16_t)take(d,d[0x3ed]);
 unsigned bits=d[0x3c0],n=bits<32?bits:32;
 uint32_t low=take_long(d,n)&mask32(n);
 uint32_t high=take(d,bits-n)&mask32(bits-n);
 uint64_t value=((uint64_t)high<<32)|low;
 for(unsigned i=0;i<6;++i){
  unsigned divisor=d[0x4bb-i],digit=(unsigned)(value%divisor);value/=divisor;
  uint16_t entry=d[0xe8f4+128*i+digit];
  d[0x4c1-i]=entry&255u;d[0x4c7-i]=(entry&0x7f00u)>>8;
  d[0x4cd-i]=(uint16_t)(((d[0x39f]&128u)?digit<<8:entry&0x7f00u)|(5-i));
 }
 d[0x3e0]=(uint16_t)(value>>32);d[0x3e1]=(uint16_t)(value>>16);d[0x3e2]=(uint16_t)value;
 d[0x3c3]=d[0x3c2];
}
/* C64F..C6E4. Highest metadata key gets rank zero. Search ties retain
 * the first candidate, hence the largest free-sign mask. */
void payload_signs(uint16_t d[65536]) {
 unsigned md=d[0x3ed],raw=d[0x3e3],signs=0;
 for(unsigned i=0;i<md;++i){
  unsigned bit=raw&1u;raw=(raw>>1)|(bit<<15);
  d[0x3da]^=(uint16_t)(bit<<15);signs|=((d[0x3da]>>15)&1u)<<i;
 }
 if(md)d[0x3e3]=(uint16_t)signs;
 unsigned ranks[6],free_mask=0;
 if(md==6){for(unsigned i=0;i<6;++i)ranks[i]=i;}
 else {
  uint16_t keys[6];for(unsigned i=0;i<6;++i)keys[i]=d[0x4cd-i];
  for(unsigned i=0;i<6;++i){
   ranks[i]=0;for(unsigned j=0;j<6;++j)if(keys[j]>keys[i])++ranks[i];
   d[0x4c1-i]=(uint16_t)(d[0x4c1-i]+(ranks[i]<<8));
  }
  int32_t fixed=signed16(d[0x4d2])*8,levels[6];unsigned count=0,pending=signs;
  for(unsigned i=0;i<6;++i){
   int32_t level=signed16(d[0xed4f+d[0x4c7-i]]);
   if(ranks[i]<md){fixed+=(pending&1u)?-level:level;pending>>=1;}
   else {d[0x4cd-count]=(uint16_t)level;levels[count++]=level;}
  }
  int32_t best=0x3fff8000;
  for(unsigned candidate=1u<<count;candidate-- >0;){
   int32_t score=fixed;
   for(unsigned j=0;j<count;++j)score+=(candidate&(1u<<j))?-levels[j]:levels[j];
   if(score<0)score=-score;
   if(score<best){best=score;free_mask=candidate;}
  }
 }
 unsigned pending=d[0x3e3];
 for(unsigned i=0;i<6;++i){
  unsigned bit;
  if(ranks[i]<md){bit=pending&1u;pending>>=1;}
  else {bit=free_mask&1u;free_mask>>=1;}
  d[0x4c1-i]=(uint16_t)((d[0x4c1-i]^(bit<<7))&255u);
 }
 d[0x3e3]=(uint16_t)pending;
}
/* Ideal symbol-domain inverse. Observed octets here are before C5C4's law
 * XOR. Unique low-seven-bit entries and a valid negotiated B are required.
 * This is a mathematical inverse of the verified mapper, not a receiver DSP
 * decompilation or an analogue equalizer. Returns 0 for success. */
int payload_inverse(const uint16_t d[65536],const uint8_t octets[6],
                    uint16_t *parity,uint64_t *payload) {
 unsigned digits[6],signs[6],ranks[6];uint16_t keys[6];
 for(unsigned i=0;i<6;++i){
  unsigned found=0;
  for(unsigned j=0;j<d[0x4bb-i];++j){
   uint16_t entry=d[0xe8f4+128*i+j];
   if(((entry^octets[i])&127u)==0){digits[i]=j;signs[i]=((entry^octets[i])>>7)&1u;keys[i]=(entry&0x7f00u)|(5-i);++found;}
  }
  if(found!=1)return 1;
 }
 unsigned md=d[0x3ed],count=0,raw=0,previous=(*parity>>15)&1u;
 for(unsigned i=0;i<6;++i){
  ranks[i]=0;for(unsigned j=0;j<6;++j)if(keys[j]>keys[i])++ranks[i];
  if(md==6 || ranks[i]<md){raw|=(signs[i]^previous)<<count++;previous=signs[i];}
 }
 uint64_t value=0;
 for(unsigned i=6;i-- >0;)value=value*d[0x4bb-i]+digits[i];
 if(value>=((uint64_t)1<<d[0x3c0]))return 2;
 *parity=(uint16_t)((*parity&32767u)|(previous<<15));
 *payload=(value<<md)|raw;return 0;
}
/* C558..C5CF sample step for bit-12 override disabled, PM=1, with the
 * negotiated builder's coefficients [0,1000,0,0]. Includes the disparity
 * history, level-delay ring and final law-format XOR. */
uint8_t payload_sample(uint16_t d[65536]) {
 unsigned phase=d[0x3cc];uint16_t word=d[0x4bc+phase],index=d[0x4c2+phase];
 int32_t level=signed16(d[0xed4f+(index&127u)]);
 if(!(word&128u))level=-level;
 d[0x3fd]=(uint16_t)level;
 unsigned cursor=(d[0x3de]-1)&65535u;if(cursor&32768u)cursor=0x10cf;
 d[0x3de]=(uint16_t)cursor;
 if(d[0xe8e4]==0){
  d[0x4ce]=(uint16_t)(level>>3);
  int32_t previous=signed16(d[0x4d1]);
  d[0x4d3]=d[0x4d2];d[0x4d2]=d[0x4d1];d[0x4d1]=d[0x4d0];d[0x4d0]=d[0x4cf];d[0x4cf]=d[0x4ce];
  d[0x4d1]=(uint16_t)(previous+(level>>3));
  int32_t filtered=signed16(d[0x4d1]);
  int32_t square=(int32_t)((uint32_t)(filtered*filtered)<<1);
  uint32_t energy=(((uint32_t)d[0x3c5]<<16)|d[0x3c6])+(uint32_t)(square>>5);
  d[0x3c5]=(uint16_t)(energy>>16);d[0x3c6]=(uint16_t)energy;
 }
 int32_t product=(int32_t)(int16_t)(2*level)*signed16(d[0x3ef]);
 uint32_t acc=((uint32_t)signed16(d[0x3fb])<<13)+((uint32_t)product<<1);
 d[0xedd0+cursor]=(uint16_t)(acc>>14);
 int32_t delayed=(int32_t)cursor+signed16(d[0x3df])-0x10d0;
 if(delayed<0)delayed+=0x10d0;
 d[0x273]=d[0xedd0+(unsigned)delayed];
 d[0x3a7]=(uint16_t)(word^d[0x3a3]);
 d[0x3cc]=(uint16_t)(phase?phase-1:5);--d[0x3ca];
 /* Tested steady-data descriptor points at a zero next-phase word. */
 if(d[0x3ca]==0)d[0x3fd]=0;
 return (uint8_t)d[0x3a7];
}
