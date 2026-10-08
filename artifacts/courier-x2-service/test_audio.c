/* Offline V.22 answer waveform through G.711 and caller demodulator. */
#include <spandsp.h>
#include <stdio.h>
#include <stdlib.h>
static char bits[100000]; static int n,pos,received;
static unsigned shift; static int e,c,flags;
static int get_answer(void *p){return pos<n ? bits[pos++]-'0':1;}
static int get_caller(void *p){return 1;}
static void put_answer(void *p,int b){}
static void put_caller(void *p,int b){
 if(b<0)return;
 received++;shift=((shift<<1)|b)&1023;
 if(shift==0x145)e++; if(shift==0x185)c++;
 if((shift&255)==0x7e)flags++;
}
int main(int argc,char **argv){
 FILE *f=fopen(argv[1],"rb");if(!f)return 2;n=fread(bits,1,sizeof(bits),f);fclose(f);
 v22bis_state_t *a=v22bis_init(NULL,1200,0,0,get_answer,NULL,put_answer,NULL);
 v22bis_state_t *b=v22bis_init(NULL,1200,0,1,get_caller,NULL,put_caller,NULL);
 int16_t at[160],bt[160];
 for(int k=0;k<1500;k++){
  v22bis_tx(a,at,160);v22bis_tx(b,bt,160);
  for(int i=0;i<160;i++){at[i]=ulaw_to_linear(linear_to_ulaw(at[i]));bt[i]=ulaw_to_linear(linear_to_ulaw(bt[i]));}
  v22bis_rx(b,at,160);v22bis_rx(a,bt,160);
 }
 printf("bits consumed=%d received=%d E=%d C=%d flags=%d\n",pos,received,e,c,flags);
 return e==32&&c==32&&flags>0?0:1;
}
