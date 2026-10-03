from types import SimpleNamespace

import pytest

from courier_emu.sip import SipSession


class Socket:
    def __init__(self):
        self.sent = []

    def send(self, packet):
        self.sent.append(packet)

    def recvfrom(self, size):
        raise BlockingIOError


def session():
    value = object.__new__(SipSession)
    value.closed = False
    value.state = 'idle'
    value.config = SimpleNamespace(username='2904')
    value.server_host = 'pbx.test'
    value.local_ip = '127.0.0.1'
    value.local_port = 5062
    value.from_tag = 'tag'
    value._register_call_id = 'registration'
    value._register_cseq = 0
    value._register_auth_attempted = False
    value._register_refresh_at = None
    value.registered = False
    value.events = []
    value.socket = Socket()
    value.rtp_socket = Socket()
    value._flush_rtp = lambda now: None
    value._authorization = lambda *args, **kwargs: 'Digest test'
    return value


def test_registration_refreshes_repeatedly_and_reauthenticates(monkeypatch):
    now = [0.0]
    monkeypatch.setattr('courier_emu.sip.time.monotonic', lambda: now[0])
    value = session()
    value.register()
    for cycle in range(3):
        value._handle_register_response(401, {'www-authenticate': 'test'})
        assert b'Authorization: Digest test' in value.socket.sent[-1]
        value._handle_register_response(200, {'contact': '<sip:2904@host>;expires=300'})
        assert value.registered
        deadline = value._register_refresh_at
        count = len(value.socket.sent)
        now[0] = deadline - 1
        value.poll()
        assert len(value.socket.sent) == count
        now[0] = deadline
        value.poll()
        assert len(value.socket.sent) == count + 1
        assert not value._register_auth_attempted
        assert b'REGISTER sip:pbx.test' in value.socket.sent[-1]


@pytest.mark.parametrize('headers,expected', [
    ({'expires': '60'}, 48),
    ({'expires': '300', 'contact': '<sip:host>;expires=60'}, 48),
    ({}, 240),
])
def test_refresh_obeys_registrar_expiry(monkeypatch, headers, expected):
    monkeypatch.setattr('courier_emu.sip.time.monotonic', lambda: 10)
    value = session()
    value._handle_register_response(200, headers)
    assert value._register_refresh_at == 10 + expected
