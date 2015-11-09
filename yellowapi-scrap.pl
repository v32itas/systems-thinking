
# v32itas/systems-thinking (dedicated amateur)
# yellowapi-scrap.pl
##########################################################################
# This is my first perl script, mess indeed, but oh well perl is awesome
# As well as this is the first time I'm using github and this script is
# for one of the first API's which I'm investigating.
#
# It just constructs URL for yellowapi search queries.
# More static parameters like apikey, uid.. saved inside script.
# More dynamic parameters like what, where.. goes as arguments.
#
# Well currently it does it's job for me. Haven't bothered yet
# to use pure perl for pretty printing JSON, for that I'm 
# currently using underscore and it works fine.
#
# This script is just data extractor, lame and incomplete
#
# And I got to say that I have copied few lines from online manuals
##########################################################################

#!/usr/bin/perl
use strict;
use warnings;
use autodie;
use JSON;
use Path::Class;
use LWP::Simple;
use LWP::UserAgent;

my $num_args = $#ARGV + 1;
if ($num_args != 4) {
    print "\nUsage: yellowAPI.pl [where] [what] [format] [page_length]\n";
    exit;
}

my $what=$ARGV[0];      # Search Object
my $where=$ARGV[1];     # Search Location
my $apikey='You need to register to get apikey'; # You need to register to get API Key
my $fmt=$ARGV[2];       # Output Format
my $pgLen=$ARGV[3];     # Output Length in results
my $uid='v32itas'; #$ARGV[5];   # User Identifier
my $rooturl = 'http://api.sandbox.yellowapi.com/FindBusiness/';

# Request parameters array
my @tR = ('http://api.sandbox.yellowapi.com/FindBusiness/');
$tR[0] = "$rooturl";
$tR[1] = "?what=$what";
$tR[2] = "&where=$where";
$tR[3] = "&fmt=$fmt";
$tR[4] = "&pgLen=$pgLen";
$tR[4] = "&apikey=$apikey";
$tR[5] = "&UID=$uid";

# Constructing query url out from parameters array
my $query = join('',@tR);

# Making filename based on query parameters
my $filename;
$filename = "$what$where$fmt$pgLen.json";
my $curfile = $filename;
my $ppfile = "pp$filename";
# Defining log file names
my $logname = 'yapi.log';
my $errlog = 'yapierr.log';

# Checking if query was already issued based on existing filenames
if (-e $curfile) 
{
        print "\n$curfile exists! Exiting script!!!\n\n";

       
        # Writing to errlog file before exiting
        open(FILE, ">>$errlog");
        print FILE "\n$query $filename Already done!!!\n";
        close(FILE);

        # Exiting script with error.
        exit 1;
} else 
{
        print "\nfile name for this query will be $curfile\n\n";
        open(FILE, ">>$logname");
        print FILE "\n$query $filename Submitting query.\n";
        close(FILE);
};



open(FILE, ">$filename");
# Creating an User Agent
my $agent = LWP::UserAgent->new();

# Sending GET request
my $response = $agent->get($query);

# Checking Response message
die 'http status: ' . $response->code . ' ' . $response->message unless ($response->is_success);

# Printing out raw Response message
my @raw = $response->content();
print FILE $response->content();

close(FILE);
