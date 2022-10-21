#! /usr/bin/perl -w

# Nagios Check Plugin
# Title: Check FTP Fileage
#
# Description: Einfacher NAGIOS Check zum pruefen auf das alter einer Datei auf einem FTP-Server. 
#              Grenzwerte werden in Minuten übergeben
# Author:      Thomas schindzielorz | Bytes & More
# Version:     1.0
#

use Date::Parse;
use Net::FTP;
use Getopt::Std;

use vars qw($opt_H $opt_u $opt_p $opt_d $opt_f $opt_w $opt_c);
getopts("H:u:p:d:f:w:c:");

# Initialise Vars
my $host = $opt_H ||
	die "usage: check_ftp_fileage.pl -H host [<-u user> <-p pass> <-d dir> <-f file> <-w age in min -c age in min>]\n";

my $username = $opt_u || 'anonymous';
my $pass = $opt_p || "$ENV{'LOGNAME'}\@$ENV{'HOSTNAME'}" ;
my $dir = $opt_d || '.';
my $file = $opt_f || '';
my $status = 2;
my $problem;
my $output = "file '$file' not found - connected successfully as '$username'";
my $warning = $opt_w || "no";
my $critical = $opt_c || "no";
my @remote_files;

my $ftp = Net::FTP->new($host) or die "Error connecting to $host: $@";

$ftp->login($username,$pass) or die "Login failed: ", $ftp->message;

$ftp->cwd($dir) or die "Can't go to $dir: ", $ftp->message;

@remote_files = $ftp->ls($file);

if ($warning eq "-c")
   {
      $warning = "no";
   }

foreach my $file (@remote_files){
   $now=time();
   $time = $ftp->mdtm($file);
   $mins = ($now-$time)/60;
   # Round the Result
   $mins = sprintf ("%.0f", $mins);

   if ($warning eq "no" and $critical eq "no")
   {
      $status = 0;
      $output = "$file changed $mins minutes ago";
	  $warning = 0;
	  $critical = 0;
   }
   else
   {
      $warn = $now - 60*$warning;
      $crit = $now - 60*$critical;
   
      if ($time < $crit)
         {
            $status = 2;
            $output = "$file changed $mins minutes ago";
         }
   elsif ($time < $warn)
         {
            $status = 1;
            $output = "$file changed $mins minutes ago";
         }
   else
         {
            $status = 0;
            $output = "$file changed $mins minutes ago";
         }
   }
   }

# Close Connection
$ftp->quit;

if($status == 0 ) {
		$info="OK:";
	} elsif ($status == 1 ) {
			$info="WARNING:";
	} elsif ( $status == 2 ) {
		$info="CRITICAL:";
}

print "$info $output | age=$mins;$warning;$critical\n";
exit $status;