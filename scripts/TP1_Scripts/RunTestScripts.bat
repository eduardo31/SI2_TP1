echo off
echo Running sql test scripts from group 

sqlcmd -i %cd%\TP1_Scripts\CREATE.sql
sqlcmd -i %cd%\TP1_Scripts\C.sql
sqlcmd -i %cd%\TP1_Scripts\D.sql
sqlcmd -i %cd%\TP1_Scripts\E.sql
sqlcmd -i %cd%\TP1_Scripts\F.sql
sqlcmd -i %cd%\TP1_Scripts\G.sql
sqlcmd -i %cd%\TP1_Scripts\H.sql
sqlcmd -i %cd%\TP1_Scripts\I.sql
sqlcmd -i %cd%\TP1_Scripts\J.sql
sqlcmd -i %cd%\TP1_Scripts\K.sql
sqlcmd -i %cd%\TP1_Scripts\L_tests.sql
sqlcmd -i %cd%\TP1_Scripts\REMOVE.sql

set /p delExit=Press the ENTER key to exit...: