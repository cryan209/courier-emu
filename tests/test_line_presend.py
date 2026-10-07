"""LineLink.exchange after the worker's native line service sent a frame and took it back."""
import errno
import os
import socket

from courier_emu.line import LineFrame, LineLink, _HEADER


def link_pair():
    near, far = socket.socketpair()
    line = LineLink(path="unused", digital=True)
    line._socket = near
    near.settimeout(5)
    return line, far


def frame():
    return LineFrame(instructions=0, off_hook=True, ringing=False, samples=[1, -2, 3], call_state=3)


def test_presend_skips_the_send_and_still_receives():
    line, far = link_pair()
    reply = LineFrame(instructions=7, off_hook=True, ringing=False, samples=[5, 6], call_state=3)
    far.sendall(reply.encode())
    line._presend = 1
    line.exchange(frame())
    far.setblocking(False)
    try:
        assert far.recv(64) == b""
    except BlockingIOError:
        pass   # nothing was sent: the native service already did
    assert line.frames == 1 and line.receive_audio() == [5, 6] and line._presend == 0


def test_presend_after_the_far_end_closed_reports_it_the_same_way():
    line, far = link_pair()
    far.close()
    line._presend = 1
    line.exchange(frame())
    assert line.error == "the far end closed the line" and line.closed


def test_presend_failures_raise_what_the_socket_call_raised():
    for code, expected in ((4000 + errno.EPIPE, str(OSError(errno.EPIPE, os.strerror(errno.EPIPE)))),
                           (5000, "timed out"), (3000, "timed out"),
                           (2000 + errno.ECONNRESET,
                            str(OSError(errno.ECONNRESET, os.strerror(errno.ECONNRESET))))):
        line, far = link_pair()
        line._presend = code
        line.exchange(frame())
        assert line.error == expected, code
        far.close()


def test_header_layout_matches_the_native_frame():
    # courier_worker_poll writes <IBBBH by hand.
    assert _HEADER.size == 9
