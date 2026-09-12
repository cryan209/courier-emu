# V.120 on the B channel, and how far it gets

[imodem-b-channel-silence.md](imodem-b-channel-silence.md) ends with a bearer
that works: the modem answers a call, synchronises its HDLC receiver, and idles
the B channel with flags of its own.  Then it clears the call, because flags
were all the far end had to say.  `courier_emu/v120.py` is the rest of the
sentence - and this page is as careful about where it stops as about what it
does.

## What the peer speaks

Three layers, on the same terms as the Q.921/Q.931 peer beside it: it reaches
the modem only as octets on the B channel, never writes the modem's memory, and
sends nothing the standards do not say to send.

* **HDLC** - flags, zero-bit insertion, and ISO 3309's 16-bit frame check
  sequence.  The transmitter is a continuous bit stream, flags when idle and
  stuffed frames when not, so the bearer is always carrying something.  The
  receiver destuffs, checks the FCS against the residue `F0B8`, and counts
  what it throws away: aborts, runts, and bad FCS separately.
* **The V.120 address** - a 13-bit logical link identifier across two octets
  with the command/response bit between them.  That is LAPD's address field
  with the SAPI and TEI read as one number, which is exactly how the firmware
  reads it: `Illegal TEI/SAPI received from V120 peer:` is one of its own log
  strings.  LLI 256 is the default link.
* **The data link** - Q.921's procedures at frame level: SABME and UA to
  establish, I frames numbered modulo 128, RR to acknowledge, DISC and DM to
  clear, T200 with N200 retransmissions counted in octets rather than
  instructions so a timer means one second of bearer whatever the harness is
  doing.

```sh
.venv/bin/python -m courier_emu isdn-run Ie030002.nac --with-dsp \
    --bri-network --bri-establish terminal --bri-call-at 20000000 \
    --bri-call-to 7349195 --bri-v120 --send ATA --send-after 30000000
```

`--bri-v120-lli` picks the link, `--bri-v120-establish terminal` waits for the
modem to establish instead of establishing, `--bri-v120-send` queues user data,
and the run reports everything under `bri.v120`.

`tests/test_bri.py` checks the encodings the way it already checks Q.921's:
the FCS against ISO 3309's residue, stuffing against a payload deliberately
full of flags and idle marks, the LLI across both address octets with the C/R
asymmetry, and a link answering a terminal that establishes first.

## How far it gets, exactly

The bearer carries it.  The modem synchronises, and the peer's frames go out
and come back framed correctly - no FCS errors, no runts, the flag count
climbing all through the call:

```
v120  state released  sent 4  flags_seen 8321  fcs_errors 0  runts 0
      SABME on LLI 256
      T200 expired, SABME again (1 of 3) ... (3 of 3)
      T200 expired 3 times: the modem never answered
```

**The modem does not answer SABME.**  It sends flags, it sends nothing else,
and after its own timeout it clears the call.  Both ends idle politely at each
other until one of them gives up.

Bit order is not the reason, or not obviously: the flag is a palindrome, so it
proves nothing, and the modem's own receive handler at `eb39` reverses each
octet's bits when a configuration word says to - which is why `--bri-v120-msb-first`
exists.  Both orders were run.  Neither is answered, and neither produces a
different count.

## The one thing that changes its mind

A V.120 call can say so in the SETUP, in the low layer compatibility element,
and the firmware's own strings say it reads it there - `V120 SET no negotiate
LLI`, `V120 SET Remote assignor and LLI present`, and the `WARNING` forms of
both, at `0x43fcc` onwards, working off a parsed parameter block.

Offering it changes the modem's behaviour completely, and not for the better:

| SETUP | what the modem does |
|---|---|
| bearer capability only | answers, `BCH_ENABLED`, idles flags, clears on timeout |
| plus low layer compatibility naming V.120 | `MISC_INFO Detected`, `l4_DISCONN`, no RING, no `BCH_ENABLED` |

So the element is parsed and the call is refused on what it contains.  That is
worth more than it looks: it is the first evidence that this modem's V.120
acceptance depends on something in those octets, and it narrows where to look
next.  `--bri-v120-llc 1080` offers the pair the standards suggest for a
synchronous 64 kbit/s call - octet 5a `10`, octet 5b `80` - and the modem
clears the call.  It is a probe, which is why it is off by default and why the
octets are not written into the peer as a setting.

**And the guess was wrong.**  The modem dials V.120 itself, and a live call
([imodem-live-sip-call.md](imodem-live-sip-call.md)) caught its own SETUP
saying what it thinks the element should contain:

```
low layer compatibility  88 90 28 48 76 3b c0 c2 e2
```

- the first three octets as above, then `48 76 3b c0` for the rate adaption
and `c2 e2` naming Q.921 and Q.931 as the layer 2 and 3 protocols, which the
guess left out entirely.  Offered back to the modem with
`--bri-v120-llc 48763bc0c2e2` the call is **accepted**: it rings, `BCH_ENABLED`,
and the bearer carries flags, where `1080` was cleared with `MISC_INFO`.  SABME
is still not answered, so the question this page ends on is unchanged - but it
is no longer standing behind a SETUP the modem refused.

## What is open

Three threads, in the order they are worth pulling:

* **Why the LLC is refused.**  The parser is at `0x43f60` onwards and works off
  a structure whose fields at `+4`, `+6`, `+8`, `+0a`, `+0b` and `+0c` are the
  rate adaption parameters; `+4` is the one the `no negotiate LLI` branch tests.
  Reading what it requires is the same kind of work that found the called-number
  comparison, and it has the same kind of answer waiting.
* **Whether the modem wants V.120 at all on this call.**  `*V2` selects the
  data bearer - Auto Detect, V.120, V.110, Modem/Fax, Clear Channel, PPP, X.75 -
  and [imodem-config-sector.md](imodem-config-sector.md) records that the two
  `*V` settings are not in the block ATI12 prints, so which one is in force in
  these runs is not established.  A modem set to X.75 or PPP would ignore a
  SABME on LLI 256 exactly like this.
* **Who establishes.**  The peer offers both and neither is answered, so this
  is the least likely of the three - but `--bri-v120-establish terminal` is
  there, and a modem that establishes first would be answered.

What is *not* open is whether the bearer works.  Frames go out, framed and
checked; flags come back, counted.  The link this page cannot finish is a
protocol question now, not a hardware one.
