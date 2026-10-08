/* Offline probe of v90modem's built SpanDSP V.42 control queue.
 * Vendor message comes from Courier ROM analysis, not ITU V.42.
 * No physical modem, SIP, RTP or serial interfaces are opened. */
#define SPANDSP_EXPOSE_INTERNAL_STRUCTURES
#include <spandsp.h>
#include <stdio.h>
#include <string.h>
static const uint8_t wanted[]={1,2,10,2,37};
static int found;
static int get(void *p,uint8_t *m,int n){return 0;}
static void put(void *p,const uint8_t *m,int n){}
static void rx(void *p,const uint8_t *m,int n,int ok){
 if(n<=0)return;

 if(ok && n==sizeof(wanted) && !memcmp(m,wanted,n)){
  found=1;for(int i=0;i<n;i++)printf("%02x",m[i]);puts("");
 }
}
int main(void){
 v42_state_t *s=v42_init(NULL,0,0,get,put,NULL);
 hdlc_rx_state_t *r=hdlc_rx_init(NULL,0,0,1,rx,NULL);
 if(!s||!r)return 2;
 v42_restart(s);
 /* Queue into the same control ring consumed by lapm_hdlc_underflow. */
 hdlc_tx_flags(&s->lapm.hdlc_tx,10);
 int slot=s->lapm.ctrl_put;
 memcpy(s->lapm.ctrl_buf[slot].buf,wanted,sizeof(wanted));
 s->lapm.ctrl_buf[slot].len=sizeof(wanted);
 s->lapm.ctrl_put=(slot+1)%V42_CTRL_FRAMES;
 for(int i=0;i<10000 && !found;i++)hdlc_rx_put_bit(r,v42_tx_bit(s));
 hdlc_rx_free(r);v42_free(s);
 return found?0:1;
}
