#!/usr/local/bin/perl -w
 
@months = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
@days = qw(Sun Mon Tue Wed Thu Fri Sat Sun);

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
my $curdate =  "$mday$months[$mon]$days[$wday]";
 
use strict;
use warnings;
use Getopt::Long;
use LWP::Simple; # for sending GET POST ....
use LWP::UserAgent; # for pretending that I'm using phone to get easier captchas on outlook.com (joke)
#use Mojo::DOM;
my $protocol = '';
my $anonlvl = '';
my $availability = '';
my $connect_time = '';
my $response_time = '';
my $ip_filter = '';
my $port_filter = '';
my $host_filter = '';
my $via_filter = '';
my $country_filter = '';
my $city_filter = '';
my $region_filter = '';
my $offset = '';
my $webroot = 'http://proxydb.net/';
my $logname = 'yapi.log';
my $errlog = 'yapierr.log';
#http://proxydb.net/?protocol=socks5&anonlvl=4&availability=90&connect_time=2&response_time=5&ip_filter=&port_filter=&host_filter=&via_filter=&country_filter=&city_filter=&region_filter=&isp_filter=
GetOptions ("protocol=s" => \$protocol,    # string
            "anonlvl=i"   => \$anonlvl,
            "availability=i" => \$availability,
            "connect_time=i" => \$connect_time,
            "response_time=i" => \$response_time,
            "offset=i" => \$offset
            )      # integer
            #"verbose"  => \$verbose)   # flag
or die("Error in command line arguments\n");

my @tR = ('http://proxydb.net/');
$tR[0]  = "$webroot";
$tR[1]  = "?protocol=$protocol";
$tR[2]  = "&anonlvl=$anonlvl";
$tR[3]  = "&availability=$availability";
$tR[4]  = "&connect_time=$connect_time";
$tR[5]  = "&response_time=$response_time";
$tR[6]  = "&ip_filter=$ip_filter";
$tR[7]  = "&port_filter=$port_filter";
$tR[8]  = "&host_filter=$host_filter";
$tR[9]  = "&via_filter=$via_filter";
$tR[10] = "&country_filter=$country_filter";
$tR[11] = "&city_filter=$city_filter";
$tR[12] = "&region_filter=$region_filter";
$tR[13] = "&isp_filter=$region_filter";
$tR[14] = "&offset=$offset";
my $query = join('',@tR);
#print "\n$query\n"; #for debugging

my $agent = LWP::UserAgent->new();
# Sending GET request
my $response = $agent->get($query);
# Checking Response message
die 'http status: ' . $response->code . ' ' . $response->message unless ($response->is_success);
# Printing out raw Response message
my @raw = $response->content();
#print @raw;



#my $html = do {local $/; $response->content()};

#my $dom = Mojo::DOM->new($html);

#for my $script($dom->find('script')->each) {
#    print "$script\n";
#}


my $filename = join "", $curdate, $offset, $protocol, $anonlvl, $availability, $connect_time, $response_time;
my $curfile = $filename;
# Checking if query was already issued based on existing filenames
if (-e $curfile) 
{
        print "\n$curfile exists! Exiting script!!!\n\n";
        # Writing to errlog file before exiting
        open(FILE, ">>$errlog");
        print FILE "\n$query $filename Already done!!!\n";
        close(FILE);
        # Exiting script with error.
        exit 1; # There are limitations for using API, so this is to prevent
                # pointless waste of tires. 
} else 
{
        print "\nfile name for this query will be $curfile\n\n";
        open(FILE, ">>$logname");
        print FILE "\n$query $filename Submitting query.\n";
        close(FILE);
};

# I often use wrong definitions for stuff that I'm not familiar with.
open(FILE, ">$filename");

print FILE $response->content();

close(FILE);

my $filenameX = join "", $filename, "X";
my $filenameY = join "", $filename, "Y";
my $filenameP = join "", $filename, "P";
my $filenameZ = join "", $filename, "Z";
my $filenameOP = join "", $curdate,"DONE";
my $xexes = `cat $filename | grep "var x = " > $filenameX`;
my $yexes = `cat $filename | grep "var y = " > $filenameY`;
my $pexes = `cat $filename | grep "var p = " > $filenameP`;

system("paste -d '' $filenameX $filenameY $filenameP > $filenameZ");
my $NF = "\$NF";
my $semi = "\\\":\\\"";
system(`awk '{$NF=$NF"console.log(x + y + $semi + p);"; print}' $filenameZ > $filenameOP`);

system(`node $filenameOP > "leeched"$filename`);

exit 0;
