#!/usr/local/bin/perl -w
 
@months = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
@days = qw(Sun Mon Tue Wed Thu Fri Sat Sun);

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
my $curdate =  "$mday$months[$mon]$days[$wday]$hour$min";
my $secminydayisdstyear = "$year$sec$isdst$min$hour$yday"; 
use strict;
use warnings;
use Getopt::Long;
use LWP::Simple; 
use LWP::UserAgent;

my $webroot = 'http://proxydb.net/';
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
my $offset = '0';
my $pages = '9999';
my $delay = '12';
my $filenameleeched = join "", $curdate,$protocol,"leeched";
GetOptions ("protocol=s" => \$protocol,    
            "anonlvl=i"   => \$anonlvl,
            "availability=i" => \$availability,
            "connect_time=i" => \$connect_time,
            "response_time=i" => \$response_time,
            "offset=i" => \$offset,
            "pages=i" => \$pages,
            "delay=i" => \$delay
            )      
or die("Error in command line arguments\n");



for (my $i = $offset; $i < $pages; $i += 20) {
    my @tR = ('');
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
        $tR[14] = "&offset=$i";
    my $query = join('',@tR);
    print "$curdate";
    print "\n$query\n";
    
my $agent = LWP::UserAgent->new();

my $response = $agent->get($query);

die 'http status: ' . $response->code . ' ' . $response->message unless ($response->is_success);

my $filename = join "", $curdate, $offset, $protocol, $anonlvl, $availability, $connect_time, $response_time;
my $curfile = $filename;

open(FILE, ">$filename");

print FILE $response->content();

close(FILE);


my $errchk = `/usr/bin/cat $filename | grep "Try other filter settings."`;
if ($errchk ne "")
{
my $leechednumber = `/usr/bin/wc -l $filenameleeched | cut -d " " -f1`;
print "$leechednumber proxies leeched. No more proxies found. Try different filtering settings\n";
exit 0;
};

my $filenameX = join "", $filename, "X";
my $filenameY = join "", $filename, "Y";
my $filenameP = join "", $filename, "P";
my $filenameZ = join "", $filename, "Z";
my $filenameOP = join "", $curdate,"DONE";
my $xexes = `/usr/bin/cat $filename | grep "var x = " > $filenameX`;
my $yexes = `/usr/bin/cat $filename | grep "var y = " > $filenameY`;
my $pexes = `/usr/bin/cat $filename | grep "var p = " > $filenameP`;

system("/usr/bin/paste -d '' $filenameX $filenameY $filenameP > $filenameZ");
my $NF = "\$NF";
my $semi = "\\\":\\\"";
system(`/usr/bin/awk '{$NF=$NF"console.log(x + y + $semi + p);"; print}' $filenameZ > $filenameOP`);






if (-e $filenameleeched) 
{
system(`/usr/bin/node $filenameOP >> $filenameleeched`);
sleep ($delay);
} else 
{
system(`/usr/bin/node $filenameOP > $filenameleeched`);
sleep ($delay);
};

}
