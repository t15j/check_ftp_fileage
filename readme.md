Einfacher Nagios Check zur Prüfung einer Datei, ob sie ein bestimmtes Alter unterschreitet.

   -H ftp-Server
   -u User
   -p Passwort
   -f Dateiname
   


Einbindung:

define command{
        command_name    check_ftp_fileage
        command_line    <PFAD>/check_ftp_fileage -H $HOSTNAME$ -u $ARG1$ -p $ARG2$ -f $ARG3$ -w $ARG4$ -c $ARG5$
        }
