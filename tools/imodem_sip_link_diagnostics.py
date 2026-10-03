"""CLI wrapper: escape locally after CONNECT and query the guest's ATI6."""
from courier_emu import cli
from courier_emu.isdn_console import _on_the_wire


original = cli.scripted_pump


def diagnostic_pump(lines, **kwargs):
    base = original(lines, **kwargs)
    transcript = kwargs['transcript']
    stage = 'connecting'
    connected_at = None
    reply = ''

    def send(machine, text):
        machine.send_serial(_on_the_wire(text, machine.dte_framing()))
        transcript.append((machine.instructions, 'sent', text))

    def pump(machine):
        nonlocal stage, connected_at, reply
        previous = len(transcript)
        base(machine)
        reply += ''.join(text for _, direction, text in transcript[previous:]
                         if direction == 'received')
        if stage == 'connecting' and 'CONNECT ' in reply and reply.endswith('\r\n'):
            connected_at = machine.instructions
            stage = 'guard'
            reply = ''
        if stage == 'guard' and machine.instructions >= connected_at + 20_000_000:
            send(machine, '+++')  # No CR, followed by silence until escape OK.
            stage = 'escaping'
            reply = ''
        elif stage == 'escaping' and '\r\nOK\r\n' in reply:
            send(machine, 'ATI6\r')
            stage = 'diagnostics'
            reply = ''
        elif stage == 'diagnostics' and '\r\nOK\r\n' in reply:
            send(machine, 'ATH\r')
            stage = 'done'
    return pump


cli.scripted_pump = diagnostic_pump

if __name__ == '__main__':
    raise SystemExit(cli.main())
