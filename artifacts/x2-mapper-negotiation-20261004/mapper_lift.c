/* QF060003 component semantics at stock-controller-verified overlay source offsets.
 * See placement-verification.json for the independent byte-copy check.
 */
#include <stdint.h>
unsigned mapper_active_positions(uint16_t fields);
/* ab06..ab2e with entry TC=1: receive-buffer words into negotiated state.
 * The branch samples TC before its BIT delay slot changes it. */
void mapper_receive_parameters(uint16_t d[65536])
{
 d[0x340]=d[0xff48];d[0x341]=d[0xff49];
 d[0xe8f1]=d[0xff4a];d[0xe8f2]=d[0xff4b];
}
/* c870..c8ab: unpack the negotiated working record, ending before parameter
 * setup. The scale-table index retains the unforced mode in ACC, even when
 * flag bit 12 forces the stored mode to zero. */
void mapper_unpack_parameters(const uint16_t p[65536], uint16_t d[65536])
{
 unsigned original_mode=(d[0x340]>>11)&15u;
 unsigned mode=(d[0xffd9]&0x1000u)?0:original_mode;
 d[0x3ed]=(d[0xe8f2]>>8)&7u;
 d[0x3e4]=(uint16_t)mode;
 d[0x3ee]=p[0xc966+original_mode];
 d[0x3ef]=p[0xc963+mode];
 uint32_t source=(((uint32_t)d[0xe8f2]<<16)|d[0xe8f1])<<8;
 uint16_t packed=0;
 for(unsigned i=0;i<6;++i){
  unsigned field=(source>>28)&7u;source<<=4;
  packed=(uint16_t)((packed<<2)|p[0xc9ef+field]);
 }
 d[0x3c2]=d[0x3c3]=packed;
 d[0x3c4]=(uint16_t)mapper_active_positions(packed);
 if(d[0x3c4]==0)d[0x3c2]=d[0x3c3]=2;
}
unsigned mapper_active_positions(uint16_t fields)
{
 unsigned count=0;
 for(unsigned i=0;i<6;++i){if(fields&3u)++count;fields>>=2;}
 return count;
}
void mapper_distribute_sizes(uint16_t d[65536],uint16_t end)
{
 uint16_t packed=d[0x3fc],fields=d[0x3ff];
 d[0x3fe]=packed&255u;d[0x3fd]=packed>>8;
 for(unsigned i=0;i<6;++i){
  d[(uint16_t)(end-i)]=(fields&3u)?d[0x3fe]:d[0x3fd];fields>>=2;
 }
 d[0x3ff]=fields;
}
void mapper_expand_descriptors(uint16_t d[65536])
{
 d[0xebed]=0xe8f4;d[0xebee]=d[0x3c2];
 d[0xebef]=0xa60;d[0xebf0]=d[0x3dc];
 d[0xebf1]=0x880;d[0xebf2]=d[0x3dd];
 for(unsigned i=0;i<6;++i){
  uint16_t dest=d[0xebed],fields=d[0xebee];
  d[0xebed]=(uint16_t)(dest+0x80u);d[0xebee]=fields>>2;
  uint16_t pair=(fields&3u)?0xebf1:0xebef;
  uint16_t src=d[pair],count=d[pair+1];
  for(unsigned j=0;j<=(unsigned)count;++j)d[(uint16_t)(dest+j)]=d[(uint16_t)(src+j)];
  if(fields&1u)for(unsigned j=0;j<=(unsigned)count;++j)d[(uint16_t)(dest+j)]|=0x100u;
 }
}
