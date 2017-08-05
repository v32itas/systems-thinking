#! /usr/local/bin/perl -w
use strict;
use warnings;
use Getopt::Long;
use LWP::Simple; # for sending GET POST ....
use LWP::UserAgent; # for pretending that I'm using phone to get easier captchas on outlook.com (joke)
use Mojo::DOM;
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
print @raw;



my $html = do {local $/; $response->content()};

my $dom = Mojo::DOM->new($html);

for my $script($dom->find('script')->text->each) {
    print "$script\n";
}



