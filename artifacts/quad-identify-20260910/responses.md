# QF060003 ATI and ATY command responses — 2026-09-10

Measured using the opt-in CPU byte-terminal adapter, with a fresh modem instance for each command and `ATQ0V1` first. All 43 commands consumed their input and returned to the idle dispatcher without an emulator error. Seven-bit terminal decoding is shown below; raw UART bytes are preserved in `results.json`.

These are emulator-state reports, not measurements of a physical Quad. DSP/link measurements, DIP switches, slot/channel identity and NVRAM values reflect the incomplete board model. The adapter boundary is documented in `docs/quad-at-terminal.md`.

Reproduce: `PYTHONPATH=. .venv/bin/python tools/probe_quad_identify.py`.

`ATI2` includes the non-text bytes `55 aa` in its reply (shown as `U*` by seven-bit decoding), followed by two `OK` lines. Its full raw output is `8d0a55aa0acf4b8d0a8d0acf4b8d0a`.

## ATI

```text
6406

OK
```

## ATI0

```text
6406

OK
```

## ATI1

```text
94E7

OK
```

## ATI2

```text
U*
OK

OK
```

## ATI3

```text
00:00:00

OK
```

## ATI4

```text
USRobotics Analog/Digital Quad  Settings...
Copyright, 1988-98, 3Com Corp. All rights reserved.

   B0  C1  E0  F1  Q0  V1  X1
   BAUD=9600   PARITY=E  WORDLEN=7  DTE=RS-232
   DIAL=TONE   ON HOOK   TIMER     LINE=STANDARD ANALOG

   &A1  &B0  &C0  &D0  &G0  &H0  &I0  &K1  &L0  &M4  &N0  &P0  &R1  &S0  &T4
   &U0  &X0  &Y1  %G15  %N6  *U1=3  *U2=0  *U3=1  *V2=0  *X0=2048  *X1=2  

   S00=000  S01=000  S02=043  S03=013  S04=010  S05=008  S06=002  S07=060  
   S08=002  S09=006  S10=007  S11=070  S12=050  S13=000  S14=000  S15=000  
   S16=000  S17=000  S18=000  S19=000  S20=000  S21=010  S22=017  S23=019  
   S24=150  S25=005  S26=001  S27=000  S28=008  S29=020  S30=000  S31=000  
   S32=009  S33=000  S34=000  S35=000  S36=000  S37=000  S38=000  S39=011  
   S40=000  S41=000  S42=126  S43=200  S44=015  S45=000  S46=255  S47=000  
   S48=000  S49=016  S50=100  S51=000  S52=005  S53=000  S54=064  S55=000  
   S56=000  S57=000  S58=000  S59=000  S60=000  S61=000  S62=000  S63=000  
   S64=000  S65=000  S66=000  S67=001  S68=000  S69=000  S70=000  S71=001  
   S72=000  S73=001  S74=000  S75=000  S76=000  S77=000  S78=000  S79=000  
   S80=000  S81=002  S82=012  

   LAST DIALED #:  5,                                    
   LAST DNIS:                           LAST ANI:                          

OK
```

## ATI5

```text
USRobotics Analog/Digital Quad  NVRAM Settings...
Copyright, 1988-98, 3Com Corp. All rights reserved.

   DIAL=TONE   B0  F0  X0
   BAUD=110    PARITY=N  WORDLEN=8

   &A0  &B0  &G0  &H0  &I0  &K0  &L0  &M0  &N0  &P0  &R0  &S0  &T5
   &U0  &X0  &Y0  %G0  %N0  *U1=0  *U2=0  *U3=0  *V2=0  *X0=0  *X1=0

   S00=000  S02=000  S03=000  S04=000  S05=000  S06=000  S07=000  S08=000
   S09=000  S10=000  S11=000  S12=000  S13=000  S15=000  S19=000  S21=000
   S22=000  S23=000  S24=000  S25=000  S26=000  S27=000  S28=000  S29=000
   S31=000  S32=000  S33=000  S34=000  S35=000  S36=000  S37=000  S38=000
   S39=000  S40=000  S41=000  S42=000  S43=000  S44=000  S46=000  S47=000
   S48=000  S49=000  S50=000  S51=000  S52=000  S53=000  S54=000  S55=000
   S56=000  S57=000  S58=000  S60=000  S61=000  S62=000  S63=000  S64=000
   S65=000  S66=000  S67=000  S68=000  S69=000  S70=000  S71=000  S72=000
   S73=000  S74=000  S75=000  S76=000  S77=000  S78=000  S79=000  S80=000
   S81=000  S82=000

   STORED PHONE #0:                                       
                #1:                                       
                #2:                                       
                #3:                                       

OK
```

## ATI6

```text
USRobotics Analog/Digital Quad  Link Diagnostics...
Copyright, 1988-98, 3Com Corp. All rights reserved.

Chars sent                    0      Chars Received                0
Chars lost                    0
Octets sent                   0      Octets Received               0
Blocks sent                   0      Blocks Received               0
Blocks resent                 0

Retrains Requested            0      Retrains Granted              0
Line Reversals                0      Blers                         0
Link Timeouts                 0      Link Naks                     0

Data Compression       NONE
Equalization           Long
Fallback               Disabled
Last Call              00:00:00

No Connection
OK
```

## ATI7

```text
USRobotics Analog/Digital Quad Configuration Profile...
Copyright, 1988-98, 3Com Corp. All rights reserved.

Product type           US/Canada Rackmount
Slot/Channel           16/4
Options                V32bis,Terbo,V.FC,V34+
ISDN Options           V.110, V.120, SYNC, PPP, & X.75
Clock Freq             20.16Mhz
Flash Rom              512K
Ram                    384K

Supervisor date        09/22/98
DSP date               09/22/98

Supervisor rev         6.0.3
DSP rev                6.0.3

OK
```

## ATI8

```text
ERROR
```

## ATI9

```text
ERROR
```

## ATI10

```text
USRobotics Analog/Digital Quad 
Copyright, 1988-98, 3Com Corp. All rights reserved.

                            DIAL SECURITY STATUS

    SECURITY/AUTOPASS ENABLED:[N]              LOCAL SECURITY ENABLED:[N]

    FALLBACK PROMPTING:[N]                     FORCED PROMPTING:[N]

    LOCAL ACCESS PASSWORD:[NO PSW]             AUTOPASS PASSWORD:[NO PSW]

    ACCOUNT PASSWORD                           SEND PROMPT FOR PHONE_#
        [NO PSW]                                         [N]

OK
```

## ATI11

```text
USRobotics Analog/Digital Quad  Link Diagnostics...
Copyright, 1988-98, 3Com Corp. All rights reserved.

Modulation (recv/xmit)   Unknown Speed
Carrier Freq    ( Hz )   0/0
Symbol Rate              0/0
Trellis Code             
Nonlinear Encoding       
Precoding                
Shaping                  
Preemphasis     (-dB )   
Recv/Xmit Level (-dBm)   0.0/0.0
SNR             ( dB )   
Near Echo       ( dB )   
Far Echo        ( dB )   
Roundtrip Delay (msec)   
Timing Offset   ( ppm)   
Carrier Offset  ( ppm)   
x2 Status                x2/V.90 not operational in local modem
x2 Signature             

OK
```

## ATI12

```text
ERROR
```

## ATI13

```text
USRobotics Analog/Digital Quad  MNP10 Diagnostics...
Copyright, 1988-98, 3Com Corp. All rights reserved.

APS Max Packets          32
APS Bler                 0
Local AGC10              25
Local EQM10              0
Remote AGC10             0
Remote EQM10             0
LM-I Recv Seq Nr         0
LM-I Send Seq Nr         0
LM-I Ackd Seq Nr         0
MNP10 Current Speed      None 
Unacked LMIs             0

OK
```

## ATI14

```text
USRobotics Analog/Digital Quad  ETC Diagnostics...
Copyright, 1988-98, 3Com Corp. All rights reserved.

CTetc detected?                No
Next ETC Tx Level              Not computed

OK
```

## ATI15

```text
USRobotics Analog/Digital Quad  Remote Modem Management Information
Copyright, 1988-98, 3Com Corp. All rights reserved.

Status                       Not present or enabled in remote modem
Number of updates            0
Time of last update          00:00:00
Update event                 
Manufacturer ID              
Product ID                   
Serial Number                
Version Number               
Version Date                 
Signal Levels:               
    Receive: Total           0.0 (-dBm)
             3300 HZ         0.0 (-dBm)
             3750 HZ         0.0 (-dBm)
             Near-end echo   0.0 (-dBm)
             Far-end echo    0.0 (-dBm)
             Noise           0.0 (-dBm)
    Transmit                 0.0 (-dBm)
x2 Status                    

OK
```

## ATI16

```text
ERROR
```

## ATI17

```text
ERROR
```

## ATI18

```text
ERROR
```

## ATI19

```text
ERROR
```

## ATI20

```text
ERROR
```

## ATI21

```text
ERROR
```

## ATI22

```text
ERROR
```

## ATI23

```text
ERROR
```

## ATI24

```text
ERROR
```

## ATI25

```text
ERROR
```

## ATI26

```text
ERROR
```

## ATI27

```text
ERROR
```

## ATI28

```text
ERROR
```

## ATI29

```text
ERROR
```

## ATI30

```text
ERROR
```

## ATY10

```text
OK
```

## ATY11

```text
Freq     Level

OK
```

## ATY12

```text
Recv     Xmit

OK
```

## ATY13

```text
ERROR
```

## ATY14

```text
,,,,,
OK
```

## ATY15

```text
CURRENT DIPSWITCH SETTINGS
DIPSWITCH #1   ON
DIPSWITCH #2   ON
DIPSWITCH #3   ON
DIPSWITCH #4   ON
DIPSWITCH #5   ON
DIPSWITCH #6   ON
DIPSWITCH #7   ON
DIPSWITCH #8   ON
DIPSWITCH #9   ON
DIPSWITCH #10  ON

OK
```

## ATY16

```text
# of NOVRAM writes = 0000

OK
```

## ATY17

```text
ERROR
```

## ATY18

```text
OK
```

## ATY19

```text
OK
```

## ATY20

```text
OK
```
