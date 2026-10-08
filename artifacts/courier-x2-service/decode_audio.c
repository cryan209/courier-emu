#include <spandsp.h>
#include <stdio.h>
#include <stdlib.h>
static long sample; static int shown; static unsigned shift; static int e,c,flags,bits,odp;
static int get(void*p){return 1;}
static void put(void*p,int b){if(b<0){fprintf(stderr,"status %d\n",b);return;} bits++;shift=((shift<<1)|b)&1023;if(shift==0x111||shift==0x113){odp++;if(odp<=4)printf("ODP sample=%ld\n",sample);}if(shift==0x145){e++;if(e<=3)printf("E sample=%ld\n",sample);}if(shift==0x185){c++;if(c<=3)printf("C sample=%ld\n",sample);}if((shift&255)==0x7e)flags++;}
int main(int argc,char**argv){
 FILE*f=fopen(argv[1],"rb");if(!f)return 2; fseek(f,atoi(argv[2]),SEEK_SET);
 v22bis_state_t*s=v22bis_init(NULL,1200,0,argc>3?atoi(argv[3]):1,get,NULL,put,NULL);
 unsigned char u[160];int16_t a[160],discard[160];int n;
 while((n=fread(u,1,160,f))>0){for(int i=0;i<n;i++)a[i]=ulaw_to_linear(u[i]);v22bis_tx(s,discard,n);sample=ftell(f);v22bis_rx(s,a,n);}
 printf("offset=%s bits=%d E=%d C=%d flags=%d ODP=%d\n",argv[2],bits,e,c,flags,odp);return 0;
}
