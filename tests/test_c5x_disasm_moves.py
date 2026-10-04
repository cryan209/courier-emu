"""Keep firmware block-move listings faithful to transfer direction."""
import pytest
import sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from tools.c5x_disasm import decode

@pytest.mark.parametrize('words,text',[
    ([0xa8a0,0x7cce],'bldd    #7cce, *+'),
    ([0xa9a0,0x7cce],'bldd    *+, #7cce'),
    ([0xa5a0,0x643e],'blpd    #643e, *+'),
    ([0xaca0],'bldd    bmar, *+'),
    ([0xada0],'bldd    *+, bmar'),
    ([0xa4a0],'blpd    bmar, *+'),
])
def test_block_moves_display_source_then_destination(words,text):
    assert decode(words,0).text==text
