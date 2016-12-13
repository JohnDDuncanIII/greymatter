#!/usr/bin/perl -w

##################################
# ALTER NOTHING BELOW THIS LINE. #
##################################

#################################################################################
# gm-rss.cgi - Creates an RDF feed of Greymatter entries complying to RSS 1.0.  #
# Copyright (C) James Eaton 2003						#
#										#
# This program is free software; you can redistribute it and/or modify it under #
# the terms of the GNU General Public License as published by the Free Software # 
# Foundation; either version 2 of the License, or (at your option) any later    # 
# version.									#
# This program is distributed in the hope that it will be useful, but WITHOUT   # 
# ANY WARRANTY;									#
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A		# 
# PARTICULAR PURPOSE. See the GNU General Public License for more details.	#
#										#
# You should have received a copy of the GNU General Public License along with  # 
# this program; if not, write to the Free Software Foundation, Inc., 59 Temple  # 
# Place, Suite 330, Boston, MA 02111-1307 USA					#
#										#
# Contact BananaBob - http://ebanana.orcon.net.nz/gm-rss.html			#
#										#
#################################################################################
# version 1.3 and above created by James Eaton.					#
#										#
# version 2.0 created from version 1.0.3a by Pete Finnigan 			#
#             http://web.petefinnigan.com					#
#             Sept 2006								#
#             Added the ability to also generate RSS2.0 feeds			#
#             fixed the W3CDTFT format for RDF (RSS1.0) feeds			#
#             Added the ability to create Atom feeds				#
# version 2.1 fixed the config file read to use name/value pairs instead of     #
#             ordinal values.                                                   #
#             altered the read of gm-entrylist as the file is no longer stored  #
#             in numerical order.                                               #
#################################################################################

use strict;
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);
use CGI qw(:standard);
use XML::RSS;
# If you do not have the packages installed by your ISP then comment out the
# use above and change the path below to point to your own local copy of
# rss.pm
#require '/home/htdocs/hosted/plsql/libs/RSS.pm';
use POSIX qw(strftime);

# set up Atom
use XML::Atom::SimpleFeed;
# If you do not have the packages installed by your ISP then comment out the
# use above and change the path below to point to your own local copy of
# xml_atom_simplefeed.pm
#require '/home/htdocs/hosted/plsql/libs/xml_atom_simplefeed.pm';


my $version = "2.1.0";	# Version number
my %prefs;							# User preferences 
my $i = 1;							# 
my $j = 1;							#
my $k;									#
my $eline = "";					# Storage for the raw input from the item file 
my @entry;							# The raw entry data from the entry file
my @poster;							# Array of the poster name from entry file
my @post_date;					# Array of the posted date from entry file
my @post_time;					# Array of the posted time from entry file
my @name;								# Array of the entry names from entry file
my @number;							# Array of entry numbers from entry file
my @itemline;						# Array of processed data from the item file
my $w3cdtf_date = strftime("%Y-%m-%dT%H:%M:%SZ", gmtime(time));
my $date_time = strftime("%a, %d %b %Y %H:%M:%S %z", gmtime(time));	# Time that the RSS feed was built in GMT
my $span_complete = -1;	# Used to indicate whole entry in item file found
my $false = 0;					#
my $true = 1;						#

my %config;
# Set up for producing output as HTML



# Find out if we are doing a dbug session
# Are we to debug?
# 0: run normal	
# 1: do the debug
my $debug = (@ARGV and $ARGV[0] eq "-d") and print "DEBUG - SET<br>\n";

# Find out if we are doing a verbose session
# Are we to be verbose?
# 0: run normal	
# 1: be verbose
my $verbose = (@ARGV and $ARGV[0] eq "-v") and print "Verbose mode on<br>\n";

#PF added explicit debug and verbose
#$debug = $true;
$verbose = $true if $debug;
	
print "Content-Type: text/html\n\n";
print "<HTML> \n<HEAD> \n<TITLE>Greymatter - RSS Generator ($version)</TITLE> \n</HEAD> \n<BODY> \n";
print "Greymatter - RSS Generator ($version)<br>\n ";
warningsToBrowser(1);
# Open the Greymatter configuration file and obtain the the required entries.

open (CONFIG, "< gm-config.cgi") || Error("Could not open gm-config.cgi"); 
while (<CONFIG>) {
    chomp;                  
    s/#.*//;                
    s/^\s+//;               
    s/\s+$//;               
    next unless length;     					# Have we deleted all the data on the line?
    my ($cfvar, $cfvalue) = split(/\s*=\s*/, $_, 2);
    $config{$cfvar} = $cfvalue;
    print "DEBUG - $cfvar = $prefs{$cfvar}<br>\n" if $debug;
}

close (CONFIG);

# The path of the destination/outputfile file
# From "Website CGI Path" in the Greymatter configuration
my $cgi_path 	= $config{'gmcgilocalpath'};
$cgi_path 	=~ s(/$)();
chomp $cgi_path;

# The path of the destination/outputfile file
# From "Local Log Path" in the Greymatter configuration
my $dest_path 	= $config{'gmlogpath'};
$dest_path 	=~ s(/$)();
chomp $dest_path;

# The path and to your folder containing the entry files
# From "Local Entries/Archives Path" in the Greymatter configuration
my $archives_dir 	= $config{'gmentriespath'};
$archives_dir		=~ s(/$)();
chomp $archives_dir; 

# URL of your blog
# From "Website Log Path" in the Greymatter configuration
my $link 	= $config{'gmlogwebpath'};
$link 		=~ s(/$)();
chomp $link;

# The URL for your entry files
# From "Website Entries Path" in the Greymatter configuration
my $archives_link 	= $config{'gmentrieswebpath'};
$archives_link 		=~ s(/$)();
chomp $archives_link;

# The suffix for your entry files
# From ".suffix to entry files" in the Greymatter configuration
my $entry_suffix 	= $config{'gmentrysuffix'};
$entry_suffix 		=~ s(/$)();
chomp $entry_suffix;

print "DEBUG - cgi_path = $cgi_path<br>\n" if $debug;
print "DEBUG - dest_path = $dest_path<br>\n" if $debug;
print "DEBUG - archives_dir = $archives_dir<br>\n" if $debug;
print "DEBUG - link = $link<br>\n" if $debug;
print "DEBUG - archives_link = $archives_link<br>\n" if $debug;


# Open the preference file for gm-rss and process the contents. 
# We exclude newlines, comments leading/trailing white space 

open (PREFS, "<".$dest_path."/gm-rssconfig.cfg")
		 || Error("Could not open gm-rssconfig.cfg");
while (<PREFS>) {
    chomp;                  
    s/#.*//;                
    s/^\s+//;               
    s/\s+$//;               
    next unless length;     					# Have we deleted all the data on the line?
    my ($var, $value) = split(/\s*=\s*/, $_, 2);
    $prefs{$var} = $value;
    print "DEBUG - $var = $prefs{$var}<br>\n" if $debug;
}
close (PREFS);

my $editor = $prefs{nameofeditor}." (mailto:".$prefs{emailofeditor}.")";
my $webmaster = $prefs{nameofwebmaster}." (mailto:".$prefs{emailofwebmaster}.")";
my $numberofitems = 15;	# Number of items to include in RSS feed (Max = 15??)

my $rss_file = $dest_path."/".$prefs{dest_name}.".rss";
my $rdf_file = $dest_path."/".$prefs{dest_name}.".rdf"; 
my $atom_file = $dest_path."/".$prefs{dest_name}.".xml";

print "DEBUG - rdf_file = $rdf_file<br>\n" if $debug;
print "DEBUG - rss_file = $rss_file<br>\n" if $debug;
print "DEBUG - atom_file = $atom_file<br>\n" if $debug;



$prefs{poster} = lc($prefs{poster});
$prefs{postdate} = lc($prefs{postdate});
$prefs{posttime} = lc($prefs{posttime});

# Set up the RDF feed

my $rss1 = new XML::RSS ( version => '1.0', encoding => 'ISO-8859-1');
$rss1->channel(
	title           => $prefs{title},
	link          	=> $link,
	description     => $prefs{description},
	image		=> $prefs{image},
	#pubDate         => $date_time,
	#lastBuildDate   => $date_time,
	dc => {
		title		=> $prefs{title},			
     		creator		=> $editor,
		description	=> $prefs{description},
     		publisher	=> $webmaster,
		date		=> $w3cdtf_date,	
     		rights		=> $prefs{copyright},
		language	=> $prefs{language},
   },
); 


$rss1->image(
	title   => $prefs{title},
	url     => $prefs{image},
	link  	=> $link,
	height  => $prefs{Imageheight},
	width   => $prefs{imagewidth},
);

# setup the RSS 2.0 file

my $rss2 = new XML::RSS (encoding => 'ISO-8859-1', version => '2.0');
$rss2->channel(
	title           => $prefs{title},
	link          	=> $link,
	description     => $prefs{description},
	copyright	=> $prefs{copyright},
	pubDate         => $date_time,
	lastBuildDate   => $date_time,
	managingeditor	=> $webmaster,
	webmaster	=> $webmaster);


$rss2->image(
	title   => $prefs{title},
	url     => $prefs{image},
	link  	=> $link,
	height  => $prefs{Imageheight},
	width   => $prefs{imagewidth},
);

# set up the atom feed

my $atom = XML::Atom::SimpleFeed->new(
        title    => $prefs{title},
        link     => $link,
        modified => $w3cdtf_date,
        tagline => $prefs{description},
   	author   => {name => $prefs{nameofwebmaster}, email => $prefs{emailofeditor} },
        copyright => $prefs{copyright}
);


# Open the Greymatter entries file and obtain the latest 15(actualy $numberofitems) open entries.
# codes must be used for & ' " < and >

#PF read the file in
open (ENTRYLIST, "< gm-entrylist.cgi") || Error("Could not open gm-entrylist.cgi");
my @templine = <ENTRYLIST>;
close ( ENTRYLIST );

foreach my $ln (@templine) {
	print "DEBUG - templine line = ($ln)<br>\n" if $debug;	
}


#PF sort on id
my @elinet = sort {(split '\|', $b, 2)[0] <=> (split '\|', $a, 2)[0] } @templine;

foreach my $ln2 (@elinet) {
	print "DEBUG - elinet line = ($ln2)<br>\n" if $debug;	
}

#PF chnage to a foreach
$i = 1;
foreach my $eline (@elinet) {
    last if($i >= $numberofitems);
    @entry = split(/\|/,$eline);
    if ($entry[5] eq "O") {
	$number[$i]=$entry[0];
	$poster[$i]=$entry[1]; 
	$name[$i]=$entry[2]; 
	$post_date[$i]=$entry[3];
	# Change the post_date to the format required by the config file
	if ($prefs{postdateformat} eq "eur") {
		$post_date[$i] =
	substr($post_date[$i],3,2)."/".substr($post_date[$i],0,2)."/".substr($post_date[$i],6,2);
	} 
	$post_time[$i]=$entry[4]; 
	print "DEBUG - Item $i - ($number[$i]) $name[$i]<br>\n" if $debug;
	$name[$i] =~ s/\&/&amp;/g; 
	$name[$i] =~ s/"/\&quot;/g;
	$name[$i] =~ s/'/\&apos;/g;
	$i++;
    }
}


	


# Set the number of items found in case it is less than 15 (actualy $numberofitems)
$numberofitems = $i;
print "DEBUG - Number Of Items = $numberofitems<br>\n" if $debug;

# Now open the entries themselves and get the data for each item in the feed.
# the data starts at <span class="rss:item"> and finishes at </span>
# codes must be used for & ' " < and >
$i = 1;
until ($i >= $numberofitems) {
	$k = sprintf ("%8d", $number[$i]);
	$k =~ tr/ /0/;
	open (ITEMFILE,"<".$archives_dir."/".$k.".".$entry_suffix) || Error ('Could not open '.$archives_dir."/".$k.".".$entry_suffix);
	my $eline;
	my $span_not_seen = -1;
	my $in_span = 0;
	my $span_complete = 1;
	my $span_count = 0;	
	my $div_count = 0;	
	my $span_state = $span_not_seen;
READ1:	while ($eline = <ITEMFILE>) {
	    chomp $eline;
	    if ($eline eq q(<span class="rss:item">)) {
 	          print "DEBUG - rss:item found on its own line<br>\n" if $debug;			
		  $span_state = $in_span;
		  $span_count++;
		  next READ1;
  	    } elsif ($eline =~ /span class="rss:item"/) {
 	          	print "DEBUG - rss:item found in a combined line<br>\n" if $debug;			
	    		$span_state = $in_span;
 	    }
# Once we have the rss:item found we need to count the number of <span ...>s included in the 
# the rss:item span. Then we null them out so they do not interfer with the rss feed 	 
  	    if ($span_state == $in_span) {
		while ($eline =~ /<span/g) { $span_count++; }
	       	print "DEBUG - There are $span_count &lt;span&gt;s in the item<br>\n" if $debug;
	       	my $w = 0;
	       	until ($w > $span_count) {
	       		my $x = index($eline,"<span");
	       		if ($x >= 0) {
	       			print "DEBUG - Start index = $x<br>\n" if $debug;
	       			my $z = index($eline,">",$x);
	       			print "DEBUG - End index = $z<br>\n" if $debug;
	       			my $y = $z - ($x - 1);
	       			$y = $y-5;
	       			print "DEBUG - length = $y<br>\n" if $debug;
	       			$eline =~ s/<span.{$y}//;
	       			
	       		}
	       		$w++;
     		}
# We now repeat the procedure with any <div...>s	
	       	while ($eline =~ /<div /g) { $div_count++; }
		print "DEBUG - There are $div_count &lt;div&gt;s in the item<br>\n" if $debug;
	 	$w =0;
	       	until ($w > $div_count) {
	       		my $x = index($eline,"<div");
	       		if ($x >= 0) {
	       			print "DEBUG - Div Start index = $x<br>\n" if $debug;
	       			my $z = index($eline,">",$x);
	       			print "DEBUG - Div End index = $z<br>\n" if $debug;
	       			my $y = $z - ($x - 1);
	       			$y = $y-5;
	       			print "DEBUG - Div length = $y<br>\n" if $debug;
	       			$eline =~ s/<div .{$y}//;
	       		}	
	       		$w++;
    		}
# Now we check that we have a matching set of <span...> </span> tags
# If we don't we know that we need to read more of the item file.	
		while ($eline =~ /<\/span>/g) { $span_count--; }
		print "DEBUG - Spans match<br>\n" if ($debug and ($span_count == 0));
	       	print "DEBUG - Spans do not match<br>\n" if ($debug and ($span_count != 0));
# Here we escape all the remaing HTML that would muck up the rss feed	       	
	       	$eline =~ s/<\/span>//g;
	 	$eline =~ s/<\/div>//g;
       	 	$eline =~ s/\&/\&amp;/g;
		$eline =~ s/</\&lt;/g;
		$eline =~ s/>/\&gt;/g;
		$eline =~ s/"/\&quot;/g;
		$eline =~ s/'/\&apos;/g;
# Add the input line to the item rss feed		
		$itemline[$j] = $eline;
		$j++;
# Now check that we have completed the rss feed. If we have then quit reading this item
# If not go back to the top off READ1 and get the next item 		
		if ($span_count == 0) {
			print "DEBUG - SPAN is complete<br>\n" if $debug;
			$span_state = $span_complete;
			last READ1;
		}
	   }		
       }
	close (ITEMFILE);
	print "<p></p>\n" if $verbose;
	if ($span_state == $span_not_seen) {
		print '<p>No &lt;span class="rss:item"&gt; Found In '.$archives_dir."/".$k.".".$entry_suffix."<br>" if $verbose;
		print "Omitted item number $number[$i] - $name[$i]</p>" if $verbose;
	} # The item was not a complete item - the end span class=rss:item was missing.	
	elsif ($span_state == $span_complete) {
		print "<p>Span Complete For ".$archives_dir."/".$k.".".$entry_suffix."<br>" if $verbose;
		print "Added item number $number[$i] - $name[$i]</p>" if $verbose;
		if ($prefs{poster} eq "yes") {
			if ($prefs{postdate} eq "yes") {
				$itemline[$j] =
	"&lt;p&gt;".$prefs{postheader}." ".$poster[$i]." ".$prefs{postdateheader}." ".$post_date[$i];
				if ($prefs{posttime} eq "yes") {
					$itemline[$j] = $itemline[$j]." ".$prefs{posttimeheader}." ".$post_time[$i]."&lt;/p&gt;";
				} else { 
					$itemline[$j] = $itemline[$j]."&lt;/p&gt;";
				}
			} else {
				$itemline[$j] = "&lt;p&gt;".$prefs{postheader}." ".$poster[$i]."&lt;/p&gt;";
			}	
		} elsif ($prefs{postdate} eq "yes") {
			$itemline[$j] = "&lt;p&gt;".$prefs{postdateheader}." ".$post_date[$i];
				if ($prefs{posttime} eq "yes") {
					$itemline[$j] = $itemline[$j]." ".$prefs{posttimeheader}." ".$post_time[$i]."&lt;/p&gt;";
				} else {
					$itemline[$j] = $itemline[$j]."&lt;/p&gt;";
				}
		}
		# add the entry to the RDF file
		$rss1->add_item(
 				title       => "$name[$i]",  
 				link        => "$archives_link"."/"."$k.$entry_suffix",
 				description => "@itemline",
 		); # Item complete and added to the rss feed
 		
 		# add RSS entries
 		$rss2->add_item(
 				title 		=> "$name[$i]",
 				link        	=> "$archives_link"."/"."$k.$entry_suffix",
 				description 	=> "@itemline",
 				permaLink	=> "$archives_link"."/"."$k.$entry_suffix",
 				pubDate         => $date_time
 		);
 		
 		# add atom entries
 		$atom->add_entry(
		        title    => "$name[$i]",
		        link     => "$archives_link"."/"."$k.$entry_suffix",
		        author   => {name => $prefs{nameofwebmaster}, email => $prefs{emailofeditor} },
		        modified => $w3cdtf_date,
		        issued   => $w3cdtf_date,
		        content  => "@itemline"
		    );

 		
	} else {
		print "<p>No &lt;/span&gt; Found For ".$archives_dir."/".$k.".".$entry_suffix."<br>" if $verbose;
		print "Omitted item number $number[$i] - $name[$i]</p>" if $verbose;	
	} # The item was incomplete the </span> was missing.
	$i++;
	$j = 1; 
	@itemline = "";
}	

	
# Safe the RDF feed 

$rss1->save($rdf_file);	

# save the RSS2 feed

$rss2->save($rss_file);

# save the atom feed

$atom->save_file($atom_file); 

# Inform the user the file has been created

print "\n\nThe RDF file $rdf_file has been created.\n<br><br>";
print "\n\nThe RSS file $rss_file has been created.\n<br><br>";
print "\n\nThe Atom file $atom_file has been created.\n";
print "</BODY>\n</HTML>\n" if $verbose;
exit;

# Sub procedure to print Error
sub Error {
	my ($message) = @_;
	print "<H2>Status: 500 CGI Error</H2>", "\n";
	print "<HR>", $message, "<HR>", "\n";
	exit 500;
}				
