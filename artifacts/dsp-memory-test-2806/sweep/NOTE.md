# The sweep's first sample is clobbered

21 addresses, `--memory-test-addresses`. Sample 0 is "PMST as found" and reads
`5aa5` rather than `00b0`, because this sweep writes its test patterns to data
`0x1000` - which is `ROM_DUMP_BUFFER`, so the write lands on the already-stored
sample. Only that one word is affected; every address row is intact, and
`PMST` as found is in `run-a` and `run-b`, which do not touch `0x1000`.

Move the buffer, or leave `0x1000` out of the address list, before reading
anything into sample 0 again.
