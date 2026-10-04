import sys,json
from pathlib import Path
sys.path.insert(0,'/Users/scottcryan/courier-emu')
from tools import probe_imodem_pair as pair
original=pair.IsdnMachine
trace={'addresses':['039f','ffd9','0322','03e3'],'captures':[],'amplitude_writes':[]}
seen=None;next_at=0
def machine(*a,**kw):
 prior=kw['serial_pump']
 def pump(current):
  global seen,next_at
  prior(current);core=current.mailbox.core
  if core is None:return
  if core is not seen:
   core.set_data_trace_filter(0x03e3);core.trace_data_writes(clear=True)
   core.set_pc_capture(0xde14,[int(a,16) for a in trace['addresses']]);seen=core
  if current.instructions<next_at:return
  next_at=current.instructions+250000
  trace['captures']+=core.pc_captures();core.clear_pc_captures()
  trace['amplitude_writes']+=core.data_events();core.trace_data_writes(clear=True)
 kw['serial_pump']=pump
 return original(*a,**kw)
pair.IsdnMachine=machine
pair.__file__=__file__
if '--worker' in sys.argv:
 args=pair.arguments()
 try:pair.run_side(args)
 finally:args.result.with_suffix('.classifier.json').write_text(json.dumps(trace,indent=2)+'\n')
else:pair.main()
