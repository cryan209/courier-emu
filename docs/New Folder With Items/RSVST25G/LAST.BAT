@ECHO OFF
rem
rem Предполагается что RSVStat находиться в том же каталоге, что и T-Mail
rsvstat.exe last
rem
rem А теперь эхопроцессор
rem
fastecho\feutil POST last.txt #24 -From RSV_Stat -Subj Last_Session -To SysOp