# Decoding the server's stretch E with the payload mapper

`analysis.json` is `tools/decode_server_training_e.py` on the I-modem's octets
(`imodem-tx.g711`, bearer second 11.1639, 10002 symbols = 1667 frames) from the
53333/x2 analog Courier call. With six banks of nine entries, B = 19 amplitude bits and
MD = 5 independent signs, the frames reassemble into 24 bits each that descramble, with
1 + x^-18 + x^-23, to constant ones over all 1667 frames. Other MD values give 50 %.
Needs only the Python standard library. The capture command is in
`artifacts/x2-courier-phase3-20261004/README.md`.
