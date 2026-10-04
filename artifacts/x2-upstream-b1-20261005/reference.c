#include <stdio.h>
#include <stdlib.h>
#include "spandsp.h"
#include "spandsp/private/bitstream.h"
#include "spandsp/private/power_meter.h"
#include "spandsp/private/logging.h"
#include "spandsp/private/v34.h"
static int ones(void *p){return 1;}
static void sink(void *p,int bit){}
int main(int argc,char **argv){
 int rate=argc>1?atoi(argv[1]):24000;
 v34_state_t *s=v34_init(NULL,3200,rate,true,true,ones,NULL,sink,NULL);
 if(!s || v34_seed_tx_data(s,rate/2400,argc>6?atoi(argv[6]):0,0,argc>5?atoi(argv[5]):0,NULL))return 1;
 s->tx.scrambler_tap=argc>2?atoi(argv[2]):4;
 if(argc>4)s->tx.state=atoi(argv[4]);
 if(argc>3){s->tx.super_frame=atoi(argv[3]);s->tx.v0_pattern=2*atoi(argv[3]);}
 fprintf(stderr,"b=%d p=%d j=%d q=%d m=%d super=%d v0=%d\n",s->tx.parms.b,s->tx.parms.p,s->tx.parms.j,s->tx.parms.q,s->tx.parms.m,s->tx.super_frame,s->tx.v0_pattern);
 printf("[");int16_t f[16];for(int k=0;k<60;++k){v34_get_mapping_frame_state(s,f);for(int n=0;n<8;++n)printf("%s[%d,%d]",k||n?",":"",f[n*2],f[n*2+1]);}puts("]");v34_free(s);
}
