#define SPANDSP_EXPOSE_INTERNAL_STRUCTURES
#include <spandsp.h>
#include <stdio.h>
static int get(void *p,uint8_t *b,int n){return 0;}
static void put(void *p,const uint8_t *b,int n){}
int main(void){
 v42_state_t *s=v42_init(NULL,0,1,get,put,NULL);
 v42_restart(s); s->neg.odp_seen=1;
 unsigned window=0; int e=0,c=0;
 for(int i=0;i<1600;i++){
  window=((window<<1)|v42_tx_bit(s))&1023;
  if(window==0x145)e++; /* transmitted 0101000101 */
  if(window==0x185)c++; /* transmitted 0110000101 */
 }
 printf("ADP E=%d C=%d\n",e,c);
 v42_free(s);return e==32&&c==32?0:1;
}
