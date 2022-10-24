Einfacher Nagios Check auf Perl-Basis zur Prüfung einer Datei auf dem FTP-Server, ob sie ein bestimmtes Alter unterschreitet.

   -H ftp-Server
   -u Username
   -p Passwort
   -d Directory (default '.')
   -f Dateiname
   -w Warning-Schwelle
   -c Critical-Schwelle

Einbindung:
```
define command{
        command_name    check_ftp_fileage
        command_line    <PFAD>/check_ftp_fileage -H $HOSTNAME$ -u $ARG1$ -p $ARG2$ -f $ARG3$ -w $ARG4$ -c $ARG5$
        }
```
