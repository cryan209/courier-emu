# The server's signal after E

`analysis.json` is `tools/decode_server_post_e.py` on `imodem-tx.g711` from the 53333/x2
analog Courier call (12.54 to 40.32 bearer seconds): the same six-position mapper as E, with
the nine-entry table `a5 a8 ab ae b3 b9 bf cb df`, five independent signs and 19 amplitude
bits, descrambled with 1 + x^-18 + x^-23.  Every HDLC frame listed has a valid CRC-16.
Needs only the Python standard library.  The capture command is in
`artifacts/x2-courier-phase3-20261004/README.md`.
