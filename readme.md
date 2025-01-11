Einfacher Nagios Check auf Perl-Basis zur Prüfung einer Datei auf dem FTP-Server, ob sie ein bestimmtes Alter unterschreitet.

## Parameter
   -H ftp-Server<br/>
   -u Username (default 'anonymous')<br/>
   -p Passwort (default 'Hostname')<br/>
   -d Directory (default '.')<br/>
   -f Dateiname<br/>
   -w Warning-Schwelle<br/>
   -c Critical-Schwelle<br/>

## Einbindung:
```
define command{
        command_name    check_ftp_fileage
        command_line    <PFAD>/check_ftp_fileage -H $HOSTNAME$ -u $ARG1$ -p $ARG2$ -d $ARG3$ -f $ARG4$ -w $ARG5$ -c $ARG6$
        }
```
