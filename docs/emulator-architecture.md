# Emulator architecture

The normal emulator is a model of a Courier, not a firmware-discovery probe.
Recovered facts therefore belong in `courier_emu.machine_map`; instruction and
memory tracing remain optional tools used to establish those facts.

## Layers

1. The CPU executes ordinary 80186 instructions.
2. `CourierMachineMap` assigns address ranges and service vectors to devices.
3. Device models own UART, timers, ASIC, EEPROM, flash and DSP behavior.
4. An exact-digest `FirmwareProfile` supplies only facts that move between ROM
   releases.
5. The scheduler advances devices after bounded amounts of guest execution.

An optimization may skip or replace firmware code only when its profile is
selected by an exact digest and the relevant entry bytes have also been
validated. Unknown ROMs continue through the general interpreter.

## Migration rule

Newly recovered addresses must be named in the machine map or a firmware
profile before normal execution depends on them. Do not add another anonymous
literal to the CPU dispatch loop. Discovery scripts may use raw addresses, but
their promoted result must include its image identity and evidence.

The first mapped ranges are the 80186 peripheral block, DSP host queue and
serial callback cell. The two Australian flash captures are the first explicit
firmware profiles. Existing literals should move here incrementally, with a
behavioral regression test for each move.

## Performance direction

The Python interpreter keeps the next device-service deadline inside its
dispatch loop and calls the machine once per bounded interval, rather than
installing a Python code hook for every instruction. The next execution change
is a block API: execute until a mapped device deadline, mapped watchpoint,
interrupt boundary or block exit, then advance the scheduler once. Known idle
and polling loops can subsequently yield to the next device event through
profile rules guarded by code anchors.
