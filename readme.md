# check_ftp_fileage

`check_ftp_fileage.pl` ist ein einfaches Nagios/Icinga-Plugin in Perl, das das Alter einer Datei auf einem FTP-Server prüft und je nach Schwellwerten `OK`, `WARNING` oder `CRITICAL` zurückliefert.

## Funktionsweise

Das Skript verbindet sich via FTP mit dem Zielsystem, wechselt in ein Verzeichnis, sucht die angegebene Datei und ermittelt den letzten Änderungszeitpunkt über `MDTM`.
Aus der Differenz zur aktuellen Zeit wird das Alter in Minuten berechnet.

Rückgabewerte:

- `0` = OK
- `1` = WARNING
- `2` = CRITICAL (auch wenn Datei nicht gefunden wurde)

## Voraussetzungen

- Perl
- Perl-Module:
  - `Net::FTP`
  - `Date::Parse`
  - `Getopt::Std`

## Aufruf

```bash
./check_ftp_fileage.pl -H <host> [-u <user>] [-p <pass>] [-d <dir>] -f <datei> [-w <min>] [-c <min>]
```

### Parameter

- `-H` FTP-Server (Pflicht)
- `-u` Benutzername (optional, Standard: `anonymous`)
- `-p` Passwort (optional, Standard: `<LOGNAME>@<HOSTNAME>`)
- `-d` Verzeichnis auf dem FTP-Server (optional, Standard: `.`)
- `-f` Dateiname bzw. Suchmuster
- `-w` Warning-Schwelle in Minuten
- `-c` Critical-Schwelle in Minuten

## Beispiele

Nur Existenz/Alter ausgeben (ohne Schwellenwerte):

```bash
./check_ftp_fileage.pl -H ftp.example.org -u monitor -p geheim -d /export -f daten.csv
```

Mit Schwellwerten (Datei älter als 30 Minuten = WARNING, älter als 60 Minuten = CRITICAL):

```bash
./check_ftp_fileage.pl -H ftp.example.org -u monitor -p geheim -d /export -f daten.csv -w 30 -c 60
```

## Nagios/Icinga-Integration

```nagios
define command {
    command_name    check_ftp_fileage
    command_line    <PFAD>/check_ftp_fileage.pl -H $HOSTADDRESS$ -u $ARG1$ -p $ARG2$ -d $ARG3$ -f $ARG4$ -w $ARG5$ -c $ARG6$
}
```

## Plugin-Ausgabe

Beispielausgabe:

```text
OK: daten.csv changed 7 minutes ago | age=7;30;60
```

Die Performance-Data sind im Format `age=<minuten>;<warning>;<critical>` enthalten.

## Hinweise / bekannte Besonderheiten

- Wird keine passende Datei gefunden, endet der Check mit `CRITICAL` und der Meldung, dass die Datei nicht gefunden wurde.
- Werden keine Schwellwerte (`-w`, `-c`) angegeben, liefert das Plugin bei gefundener Datei immer `OK`.
- Das Skript bewertet nur die zuletzt im Loop gesetzte Datei, falls ein Muster mehrere Dateien liefert.

