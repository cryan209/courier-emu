# x2 7-bit marker receiver (QF060003)

`tools/verify_x2_marker_receiver.py` executes the original Quad parse at
`97b5`-`97dd`/`9800` for all 128 body values and both `[006f]` bit 1 values and
checks the result against the Courier transmitter's field layout (carrier bit,
then two 3-bit indices, first-sent bit first). 32 of 256 cases are accepted:
those whose own index is 6. The arming site is `9791` (`lacl #07`); IM020104
has the same site at `948a`. See the last section of
`docs/x2-v90-protocol-selection.md`. CRC and sync were read, not run on a
transmitted frame.
