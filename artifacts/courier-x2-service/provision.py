from pathlib import Path
import secrets, subprocess
p=Path('/etc/asterisk/pjsip.conf')
s=p.read_text()
if '[6012]' in s: raise SystemExit('6012 already exists; abort')
password=secrets.token_hex(20)
s+='\n; Dedicated Courier x2 activation test\n[6012](endpoint-modem)\nauth=auth6012\naors=6012\ncallerid=Courier x2 activation <6012>\n[auth6012](auth-userpass)\nusername=6012\npassword='+password+'\n[6012](aor-single-reg)\n'
Path('/etc/asterisk/pjsip.conf.courier-x2-backup').write_text(p.read_text())
p.write_text(s)
Path('/tmp/courier-x2-password').write_text(password)
subprocess.run(['asterisk','-rx','pjsip reload'],check=True)
subprocess.run(['asterisk','-rx','database put MODEMEXT 6012 1'],check=True)
