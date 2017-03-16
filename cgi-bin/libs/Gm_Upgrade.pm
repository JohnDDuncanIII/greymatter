package Gm_Upgrade;

###############################################################################
# Greymatter 1.8.2
# Copyright (c)2000-2017, The Greymatter team
# http://greymatterforum.proboards.com/
# By possessing this software, you agree not to hold the author responsible for
# any problems that may arise from your installation or usage of Greymatter
# itself, or from any content generated by yourself or others through the use of
# this program.  You <I>may</I> freely modify and redistribute this program, so
# long as every copyright notice (including in this manual and in the Greymatter
# code) remains fully intact.  Finally, you may <I>not</I> sell or in any way
# make a financial profit from this program, either in original or modified form.
# Your possession of this software signifies that you agree to these terms;
# please delete your copy of this software if you don't agree to these terms.
# Original Creator Noah Grey
###############################################################################

#==============================================================================
## Gm Upgrade
# This package groups functions that upgrade the files that contain the data
# for Grey Matter.  This should be apart of Gm_Storage since it is dependant on
# the storage system used (flat file, db, etc.).  However, it is not used
# regularly and in the interest of keeping the Storage library clean, it is
# presented here.
#
# Note no exporting because items from this package should be fully qualified
#
# CONVENTIONS
# 1. Return a string rather than printing, this is just more elegant.  Leave prints
#   to the calling subroutine if possible.
# 2. Private subroutines should start with the '_' character.  By private I mean
#   it will never be called outside of this package.
# 3. If you have more than 1 or 2 parameters, especially if they are not required,
#   use named parameters such as in createRadioButton.  By putting stuff in a
#   hash we gain the flexibility to add more optional parameters without having
#   to pass in '' placeholders or modify existing code.
# 4. Use ' and " where appropriate.  If you don't have any variables or newlines
# then use ', its quicker and cleaner.
# 5. Don't put all text on one huge long line.  It messes with some programs
# that don't do line wraps.

use strict;
use warnings;

use Gm_Utils;
use Gm_Constants;

## NOTE: THIS IS NOT GLOBAL AND SHOULD NOT BE USED OUTSIDE OF THIS PACKAGE
# this is becaue the delimeter is an artifact of the file based storage
# mechanism.  The code outside this package must act on any assumptions!
my $DATA_DELIM = '|'; ## Must escape bar character


## Upgrade GM
#  Will Upgrade GreyMatter according to the version passed in and perform any
# modifications needed.
#  NOTE: if this was working off a database, this method would update tables, add
# columns, etc.
# ARG version => the current version of Grey Matter, not the version we are upgrading to.
# (opt) ARG errHandler => an error handler that should take an error message as an argument
# Return: 1 if worked, 0 if error
# USAGE: $worked = Gm_Upgrade::upgradeGm( '1.3.1' );
sub upgradeGm {
	my (%params) = @_;
	my $previous_version = $params{'version'};
	my $current_version = $previous_version;
	my $errorHandler = $params{'errHandler'} || \&Gm_Utils::gmWarn;
	my $worked = 1; ## assuming good because it may not need to do anything here

	## If the version ain't 1.6.1, we need to mess with the files.
	# so we see if version is less than 1.6.1, don't worry, we account for the old version formats
	if( _compareVersions( $current_version, '1.6.1' ) < 0 ){
		$worked = _upgradeToOneSixOne( %params );
		# Would use constant here, but it would have to change next upgrade
		if( $worked ){
			$current_version = '1.6.1';
			_saveVersion( version=>$current_version, errHandler=>$errorHandler );
		} else {
			&$errorHandler( 'Did not upgrade to GreyMatter 1.6.1, errors encountered.' );
		}
	}
	## 1.7.1 upgrade, should be simple, just some new configs
	if( $current_version eq '1.6.1' ){
		$worked = _upgradeToOneSevenOne( %params );
		# Would use constant here, but it would have to change next upgrade
		if( $worked ){
			$current_version = '1.7.1';
			_saveVersion( version=>$current_version, errHandler=>$errorHandler );
		} else {
			&$errorHandler( 'Did not upgrade to GreyMatter 1.7.1, errors encountered.' );
		}
	}
	## 1.7.2 upgrade, should be simple, just one config change
	if( $current_version eq '1.7.1' ){
		$worked = _upgradeToOneSevenTwo( %params );
		# Would use constant here, but it would have to change next upgrade
		if( $worked ){
			$current_version = '1.7.2';
			_saveVersion( version=>$current_version, errHandler=>$errorHandler );
		} else {
			&$errorHandler( 'Did not upgrade to GreyMatter 1.7.3, errors encountered.' );
		}
	}

	#  1.7.3 doesn't need anything
	if( $current_version eq '1.7.2' ){
		$current_version = '1.7.3';
		_saveVersion( version=>$current_version, errHandler=>$errorHandler );
	}
	## 1.7.4 is another simple upgrade
	if( $current_version eq '1.7.3' ){
		$worked = _upgradeToOneSevenFour( %params );
		# Would use constant here, but it would have to change next upgrade
		if( $worked ){
			$current_version = '1.7.4';
			_saveVersion( version=>$current_version, errHandler=>$errorHandler );
		} else {
			&$errorHandler( 'Did not upgrade to GreyMatter 1.7.4, errors encountered.' );
		}
	}
	#  1.8.1 doesn't need anything
	if( $current_version eq '1.7.4' ){
		$current_version = '1.8.1';
		_saveVersion( version=>$current_version, errHandler=>$errorHandler );
	}
	#  1.8.2 doesn't need anything, of course, it did deprecate gm-upload.cgi, should we delete it?
	if( $current_version eq '1.8.1' ){
		$current_version = '1.8.2';
		_saveVersion( version=>$current_version, errHandler=>$errorHandler );
	}

	# ------------------------------------------------------------------------
	# PF 1.8.3
	# Add an upgrade for 1.8.3 to rework the entries
	# ------------------------------------------------------------------------
#	if( $current_version eq '1.8.2' ){
#		$worked = _upgradeToOneEightThree( %params );
#
#		# Would use constant here, but it would have to change next upgrade
#		if( $worked ){
#			$current_version = '1.8.3';
#			_saveVersion( version=>$current_version, errHandler=>$errorHandler );
#		} else {
#			&$errorHandler( 'Did not upgrade to GreyMatter 1.8.3, errors encountered.' );
#		}
#	}
	## TACK ON MORE UPGRADES HERE
	#############################

	## TODO: WRITE CUSTOM ERROR HANDLER THAT SUGGESTS SINCE UPGRADNG TO FIX AND START
	## WITH FRESH INSTALL.  MULTIPLE ATTEMPTS AT UPGRADING KILLING FILES.  OTHERWISE
	## MAKE CONVERSION OF NAMED PAIR FILES DETECT AND NOT DUPED OTHERWISE GET
	## "KEY=KEY=VALUE"  OR WHEN SAVING CONFIGS OR OTHER FILES, SAVE NEW VERSION SO UPGRADE STARTS WHERE LEFT OFF


	return $worked;
}


## Save Version
# This subroutine save configs in the file-based format of 1.6.1 to ?.?.?
# ARG version => the version number to save to the file
# (opt) ARG errHandler => an error handler that should take an error message as an argument
sub _saveVersion {
	my (%params) = @_;
	my $errorHandler = $params{'errHandler'} || \&Gm_Utils::gmWarn;

	## If the getConfigs logic changes, then we need to internalize it and change this
	## really should have old updateConfigs here
	my $gmConfigs = Gm_Storage::getConfigs( errHandler=>$errorHandler );
	$gmConfigs->{'gmversionsetup'} = $params{'version'};
	Gm_Storage::setConfigs( configs=>$gmConfigs, errHandler=>$errorHandler );
}


## Upgrade to One Six One
# This subroutine upgrades to GM 1.6.1
# Changes:
# 1. Changed Config format (key+value pairs)
#  a. added new config for Protecting author name
# 2. Changed template format (key+value pairs)
#  a. added new template for header and footer of error page
# 3. Changed counter format (key+value pairs)
# Return: 1 if worked, 0 if error
sub _upgradeToOneSixOne {
	my (%params) = @_;
	my $errorHandler = $params{'errHandler'} || \&Gm_Utils::gmWarn;
	my $worked = 0;

	# Changing format of config file and then adding new one
	# Note that I am using a private sub of Gm_Storage, since Upgrade is the 'sister package'
	# it is ok.  Otherwise Gm_Storage would bloat up with Upgrade code, which is not cool
	my $lines = Gm_Storage::_loadFileArray( fn=>"gm-config.cgi", errHandler=>$errorHandler );
	my %newConfigs = ();
	$newConfigs{'gmlogpath'} = $lines->[0];
	$newConfigs{'gmentriespath'} = $lines->[1];
	$newConfigs{'gmlogwebpath'} = $lines->[2];
	$newConfigs{'gmentrieswebpath'} = $lines->[3];
	$newConfigs{'gmnotifyemail'} = $lines->[4];
	$newConfigs{'gmindexfilename'} = $lines->[5];
	$newConfigs{'gmentrysuffix'} = $lines->[6];
	$newConfigs{'gmindexdays'} = $lines->[7];
	$newConfigs{'gmserveroffset'} = $lines->[8];
	$newConfigs{'gmtimezone'} = $lines->[9];
	$newConfigs{'gmkeeplog'} = $lines->[10];
	$newConfigs{'gmposttoarchives'} = $lines->[11];
	$newConfigs{'gmallowkarmadefault'} = $lines->[12];
	$newConfigs{'gmallowcommentsdefault'} = $lines->[13];
	$newConfigs{'gmcommentsorder'} = $lines->[14];
	$newConfigs{'gmgenerateentrypages'} = $lines->[15];
	$newConfigs{'gmallowhtmlincomments'} = $lines->[16];
	$newConfigs{'gmlogkarmaandcomments'} = $lines->[17];
	$newConfigs{'gmmailprog'} = $lines->[18];
	$newConfigs{'gmnotifyforstatus'} = $lines->[19];
	$newConfigs{'gmautolinkurls'} = $lines->[20];
	$newConfigs{'gmstriplinesfromcomments'} = $lines->[21];
	$newConfigs{'gmallowmultiplekarmavotes'} = $lines->[22];
	$newConfigs{'gmversionsetup'} = $lines->[23];
	$newConfigs{'gmcgilocalpath'} = $lines->[24];
	$newConfigs{'gmcgiwebpath'} = $lines->[25];
	$newConfigs{'gmconcurrentmainandarchives'} = $lines->[26];
	$newConfigs{'gmkeeparchivemasterindex'} = $lines->[27];
	$newConfigs{'gmentrylistsortorder'} = $lines->[28];
	$newConfigs{'gmallowkarmaorcomments'} = $lines->[29];
	$newConfigs{'gmentrylistcountnumber'} = $lines->[30];
	$newConfigs{'gmcookiesallowed'} = $lines->[31];
	$newConfigs{'gmlogarchivesuffix'} = $lines->[32];
	$newConfigs{'gmcensorlist'} = $lines->[33];
	$newConfigs{'gmcensorenabled'} = $lines->[34];
	$newConfigs{'gmkeepmonthlyarchives'} = $lines->[35];
	$newConfigs{'gmdefaultentrylistview'} = $lines->[36];
	$newConfigs{'gmlinktocalendarentries'} = $lines->[37];
	$newConfigs{'gmautomaticrebuilddefault'} = $lines->[38];
	$newConfigs{'gmcommententrylistonlyifokay'} = $lines->[39];
	$newConfigs{'gmotherfilelist'} = $lines->[40];
	$newConfigs{'gmotherfilelistentryrebuild'} = $lines->[41];
	$newConfigs{'gmarchiveformat'} = $lines->[42];
	$newConfigs{'gminlineformatting'} = $lines->[43];
	$newConfigs{'gmuploadfilesallowed'} = $lines->[44];
	$newConfigs{'gmuploadfilesizelimit'} = $lines->[45];
	$newConfigs{'gmemoticonspath'} = $lines->[46];
	$newConfigs{'gmkeepphphacklog'} = $lines->[47];
	$newConfigs{'gmmailhacknotice'} = $lines->[48];
	$newConfigs{'gmemoticonsallowed'} = $lines->[49];
	$newConfigs{'gmprotectauthorname'} = Gm_Constants::NO; # setting default for new config 1.6.1

	$worked = Gm_Storage::setConfigs( configs=>\%newConfigs, errHandler=>$errorHandler  );


	# Changing format of template file and adding two new templates
	# Note that I am using a private sub of Gm_Storage, since Upgrade is the 'sister package'
	# it is ok.  Otherwise Gm_Storage would bloat up with Upgrade code, which is not cool
	$lines = Gm_Storage::_loadFileArray( fn=>"gm-templates.cgi", errHandler=>$errorHandler );
	my %newTempls = ();

	$newTempls{'gmindextemplate'} = $lines->[0] || '';
	$newTempls{'gmentrypagetemplate'} = $lines->[1] || '';
	$newTempls{'gmarchiveindextemplate'} = $lines->[2] || '';
	$newTempls{'gmarchiveentrypagetemplate'} = $lines->[3] || '';
	$newTempls{'gmentrytemplate'} = $lines->[4] || '';
	$newTempls{'gmarchiveentrytemplate'} = $lines->[5] || '';
	$newTempls{'gmstayattoptemplate'} = $lines->[6] || '';
	$newTempls{'gmdatetemplate'} = $lines->[7] || '';
	$newTempls{'gmcommentstemplate'} = $lines->[8] || '';
	$newTempls{'gmcommentsformtemplate'} = $lines->[9] || '';
	$newTempls{'gmparaseparationtemplate'} = $lines->[10] || '';
	$newTempls{'gmkarmaformtemplate'} = $lines->[11] || '';
	$newTempls{'gmlinktargettemplate'} = $lines->[12] || '';
	$newTempls{'gmdategroupingfootertemplate'} = $lines->[13] || '';
	$newTempls{'gmkarmalinktemplate'} = $lines->[14] || '';
	$newTempls{'gmcommentslinktemplate'} = $lines->[15] || '';
	$newTempls{'gmcommentauthoremailtemplate'} = $lines->[16] || '';
	$newTempls{'gmcommentauthorhomepagetemplate'} = $lines->[17] || '';
	$newTempls{'gmcommentdividertemplate'} = $lines->[18] || '';
	$newTempls{'gmmoreentrytemplate'} = $lines->[19] || '';
	$newTempls{'gmmoreentrypagetemplate'} = $lines->[20] || '';
	$newTempls{'gmmorearchiveentrypagetemplate'} = $lines->[21] || '';
	$newTempls{'gmpreviouslinktemplate'} = $lines->[22] || '';
	$newTempls{'gmnextlinktemplate'} = $lines->[23] || '';
	$newTempls{'gmpreviousmorelinktemplate'} = $lines->[24] || '';
	$newTempls{'gmnextmorelinktemplate'} = $lines->[25] || '';
	$newTempls{'gmarchivemasterindextemplate'} = $lines->[26] || '';
	$newTempls{'gmlogarchiveslinktemplate'} = $lines->[27] || '';
	$newTempls{'gmentrypagelinktemplate'} = $lines->[28] || '';
	$newTempls{'gmmoreentrypagelinktemplate'} = $lines->[29] || '';
	$newTempls{'gmlogarchiveslinkseparatortemplate'} = $lines->[30] || '';
	$newTempls{'gmentrypagelinkseparatortemplate'} = $lines->[31] || '';
	$newTempls{'gmentrypagelinkmonthseparatortemplate'} = $lines->[32] || '';
	$newTempls{'gmentrypagelinkdayseparatortemplate'} = $lines->[33] || '';
	$newTempls{'gmentrypagelinkyearseparatortemplate'} = $lines->[34] || '';
	$newTempls{'gmheadertemplate'} = $lines->[35] || '';
	$newTempls{'gmfootertemplate'} = $lines->[36] || '';
	$newTempls{'gmsidebartemplate'} = $lines->[37] || '';
	$newTempls{'gmcustomlinktemplate'} = $lines->[38] || '';   ## TO BE REMOVED FROM FILE
	$newTempls{'gmentryseparatortemplate'} = $lines->[39] || '';
	$newTempls{'gmarchiveentryseparatortemplate'} = $lines->[40] || '';
	$newTempls{'gmmorearchiveentrytemplate'} = $lines->[41] || '';
	$newTempls{'gmdatearchivetemplate'} = $lines->[42] || '';
	$newTempls{'gmlogarchiveslinkweeklytemplate'} = $lines->[43] || '';
	$newTempls{'gmcustomonetemplate'} = $lines->[44] || '';
	$newTempls{'gmcustomtwotemplate'} = $lines->[45] || '';
	$newTempls{'gmcustomthreetemplate'} = $lines->[46] || '';
	$newTempls{'gmcustomfourtemplate'} = $lines->[47] || '';
	$newTempls{'gmcustomfivetemplate'} = $lines->[48] || '';
	$newTempls{'gmcustomsixtemplate'} = $lines->[49] || '';
	$newTempls{'gmcustomseventemplate'} = $lines->[50] || '';
	$newTempls{'gmcustomeighttemplate'} = $lines->[51] || '';
	$newTempls{'gmcustomninetemplate'} = $lines->[52] || '';
	$newTempls{'gmcustomtentemplate'} = $lines->[53] || '';
	$newTempls{'gmpopuppagetemplate'} = $lines->[54] || '';
	$newTempls{'gmpopupcodetemplate'} = $lines->[55] || '';
	$newTempls{'gmsearchformtemplate'} = $lines->[56] || '';
	$newTempls{'gmsearchresultspagetemplate'} = $lines->[57] || '';
	$newTempls{'gmsearchresultsentrytemplate'} = $lines->[58] || '';
	$newTempls{'gmcalendartablebeginningtemplate'} = $lines->[59] || '';
	$newTempls{'gmcalendartableendingtemplate'} = $lines->[60] || '';
	$newTempls{'gmcalendarblankcelltemplate'} = $lines->[61] || '';
	$newTempls{'gmcalendarfullcelltemplate'} = $lines->[62] || '';
	$newTempls{'gmcalendarfullcelllinktemplate'} = $lines->[63] || '';
	$newTempls{'gmcalendarweekblankdaytemplate'} = $lines->[64] || ''; ## TO BE REMOVED FROM FILE
	$newTempls{'gmcalendarweekfulldaytemplate'} = $lines->[65] || '';
	$newTempls{'gmcalendarweekfulldaylinktemplate'} = $lines->[66] || '';
	$newTempls{'gmcommentpreviewdividertemplate'} = $lines->[67] || '';
	$newTempls{'gmcommentpreviewformtemplate'} = $lines->[68] || '';
	$newTempls{'gmsmartlinknocommentstemplate'} = $lines->[69] || '';
	$newTempls{'gmsmartlinkonecommenttemplate'} = $lines->[70] || '';
	$newTempls{'gmsmartlinkmanycommentstemplate'} = $lines->[71] || '';
	$newTempls{'gmlinebreaktemplate'} = $lines->[72] || '';
	$newTempls{'gmcommentlinktargettemplate'} = $lines->[73] || '';
	$newTempls{'gmsmartentrymoodtemplate'} = $lines->[74] || '';
	$newTempls{'gmsmartentrymusictemplate'} = $lines->[75] || '';
	$newTempls{'gmdategroupingfooterarchivetemplate'} = $lines->[76] || '';
	$newTempls{'gmsmartemoticonscodetemplate'} = $lines->[77] || '';
	$newTempls{'gmcookiescodetemplate'} = $lines->[78] || '';
	$newTempls{'gmusererrorheadertemplate'} = $lines->[79] || '';
	$newTempls{'gmusererrorfootertemplate'} =  $lines->[80] || '';
	## Two new templates in 1.6.1
	$newTempls{'gmusererrorheadertemplate'} = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" '.
		'"DTD/xhtml1-transitional.dtd">|*|<html><head><title>MY WEBLOG</title>|*|<meta http-equiv="expires" '.
		'content="31 Dec 2000">|*|<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"'.
		'/>|*|<style type="text/css">|*|body {|*|  text-align:center;|*|  font-family: verdana, arial, '.
		'helvetica, sans-serif;|*|  font-size: 11px;|*|  line-height: 18px;|*|  color: #000;|*|  '.
		'background-color: #fff|*|}|*|	|*|#frame {|*|  width:720px;|*|  margin-right:auto;|*|  '.
		'margin-left:auto;|*|  margin-top:40px;|*|  padding:0px;|*|  text-align:left;|*|}|*|	'.
		'|*|#contentcenter {|*|  width:550px;|*|  margin-top:3px;|*|  float:left;|*|  '.
		'background:#fff;|*|}|*|	|*|#contentright {|*|  width:160px;|*|  padding:0px;|*|  '.
		'margin-top:3px;|*|  float:right;|*|  background:#fff;|*|}|*|	|*|#contentheader {|*|  '.
		'background:#fff|*|}|*|		|*|p,h1,h2,h3,pre {|*|  margin:0px 10px 10px 10px;|*|  '.
		'padding-top: 0px;|*|}|*|		|*|h1 {|*|  font-size:14px;|*|}|*|h2 {|*|  font-size:13px;|*|}|*|h3 {|*|  '.
		'font-size:12px;|*|}|*|		|*|#contentheader h1 {|*|  font-size:14px;|*|  padding:10px;|*|  '.
		'margin:0px;|*|}|*|	|*|#contentright p { |*|  font-size:10px;|*|}|*||*|a {  |*|  color: #e56701; |*|  '.
		'text-decoration: none;|*|  font-weight:bold;|*|}|*||*|a:hover {|*|  '.
		'text-decoration: underline;|*|}|*||*|.button {|*|  border: 1px solid #000;|*|}|*||*|.text {|*|  '.
		'border: 1px solid #000;|*|  color: #000;|*|}|*||*|.raised {|*|  position: relative;|*|  top: -12px;|*|  '.
		'left: 12px;|*|  padding: 4px;|*|  background:#fff;|*|}|*||*|table.calendar {|*|  '.
		'margin-left: 10px;|*|}|*||*|</style>|*|</head>|*|<body>|*|<div id="frame">|*||*|	<h1> '.
		'My Weblog </h1>|*|	<div id="contentcenter">|*|<div style="border: double black 3px;"><span '.
		'class="raised"><b><font color="#FF0000">Error Notice</font></b></span><br /><p>|*|';
	$newTempls{'gmusererrorfootertemplate'} = '</p>|*|</div><br />|*|</div>|*||*|	<br clear="all" />|*|<!-- '.
		'http://greymatterforum.proboards.com/-->|*|</div>|*|</body>|*|</html>';
	$worked = Gm_Storage::setTemplates( templates=>\%newTempls, errHandler=>$errorHandler );


	# Changing format of counter file and adding key=value format
	# Note that I am using a private sub of Gm_Storage, since Upgrade is the 'sister package'
	# it is ok.  Otherwise Gm_Storage would bloat up with Upgrade code, which is not cool
	$lines = Gm_Storage::_loadFileArray( fn=>"gm-counter.cgi", errHandler=>$errorHandler );
	my %newCounter = ();
	$newCounter{'entrytotal'} = $lines->[0];
	$newCounter{'archivetotal'} = $lines->[1];
	$newCounter{'stayattopentry'} = $lines->[2];
	$newCounter{'karmapos'} = $lines->[3];
	$newCounter{'karmaneg'} = $lines->[4];
	$newCounter{'commenttotal'} = $lines->[5];
	$newCounter{'opentotal'} = $lines->[6];
	$newCounter{'closedtotal'} = $lines->[7];
	Gm_Storage::setCounters( list=>\%newCounter, errHandler=>$errorHandler );
	return $worked;
}

## Upgrade to One Seven One
# This subroutine upgrades to GM 1.7.1
# Changes:
# 1. Configs
#  a. Added new option to limit links and the number of links allowed
#  b. Added new option to force previewing on submitting comment\
#  c. Added new option to have commenter verify a pass-phrase
# Return: 1 if worked, 0 if error
sub _upgradeToOneSevenOne {
	my (%params) = @_;
	my $errorHandler = $params{'errHandler'} || \&Gm_Utils::gmWarn;
	my $worked = 0;
	my $newConfigs = Gm_Storage::getConfigs( errHandler=>$errorHandler );
	$newConfigs->{'gmcommentlinklimit'} = Gm_Constants::NO;
	$newConfigs->{'gmcommentlinklimitnum'} = '5';
	$newConfigs->{'gmcommentforcepreview'} = Gm_Constants::NO;
	$newConfigs->{'gmcommentverify'} = Gm_Constants::NO;
	$newConfigs->{'gmcommentverifyphrase'} = '';
	$worked = Gm_Storage::setConfigs( configs=>$newConfigs, errHandler=>$errorHandler );

	return $worked;
}

## Upgrade to One Seven Two
# This subroutine upgrades to GM 1.7.2
# Changes:
# 1. Configs
#  a. Changed protect author from yes/no to loose/strict/no, old yes == current loose
# Return: 1 if worked, 0 if error
sub _upgradeToOneSevenTwo {
	my (%params) = @_;
	my $errorHandler = $params{'errHandler'} || \&Gm_Utils::gmWarn;
	my $worked = 0;
	my $newConfigs = Gm_Storage::getConfigs( errHandler=>$errorHandler );
	if( $newConfigs->{'gmprotectauthorname'} eq Gm_Constants::YES){
		$newConfigs->{'gmprotectauthorname'} = 'LOOSE';
	}
	$worked = Gm_Storage::setConfigs( configs=>$newConfigs, errHandler=>$errorHandler );

	return $worked;
}

## Upgrade to One Seven Four
# This subroutine upgrades to GM 1.7.4
# Changes:
# 1. Configs
#  a. Added new option to verify HTTP_REFERER
#  b. Added new option to throttle comments
# Return: 1 if worked, 0 if error
sub _upgradeToOneSevenFour {
	my (%params) = @_;
	my $errorHandler = $params{'errHandler'} || \&Gm_Utils::gmWarn;
	my $worked = 0;
	my $newConfigs = Gm_Storage::getConfigs( errHandler=>$errorHandler );
	$newConfigs->{'gmcommentverifyreferer'} = Gm_Constants::NO;
	$newConfigs->{'gmcommentthrottle'} = Gm_Constants::NO;
	$newConfigs->{'gmcommentthrottlemin'} = Gm_Constants::EMPTY;
	$worked = Gm_Storage::setConfigs( configs=>$newConfigs, errHandler=>$errorHandler );

	return $worked;
}

# ---------------------------------------------------------------------
# PF 1.8.3
# Upgrade to 1.8.3.
#
#
# ---------------------------------------------------------------------


## Compare Versions
#  Will compare versions of greymatter and return a val to indicate whether the
# first argument comes before, after or is equal to the second argument
# TODO: SHOULD THIS BE UTILS?
# ARG1: The version of GreyMatter to compare
# ARG2: The other version to compare
# RETURNS: -1 if ARG1 is less than ARG2, 0 if equal, and 1 if ARG1 is greater than ARG2
sub _compareVersions {
	my ($t1, $t2) = @_;

	## we don't know what they are, assume equality
	my $ret_val = 0;

	## We could assume that this will be 1.3.1, but if we ever move the other logic
	# to upgrade here, this would have to change anyway
	$t1 = _convertOldVersion( $t1 );
	$t2 = _convertOldVersion( $t2 );

	if( _validVersion( $t1 ) && _validVersion( $t2 ) ){
		my @times1 = split( '\.', $t1 );
		my @times2 = split( '\.', $t2 );

		if( $times1[0] < $times2[0] ){
			$ret_val = -1;
		} elsif( $times1[0] > $times2[0] ){
			$ret_val = 1;
		} else {
			if( $times1[1] < $times2[1] ){
				$ret_val = -1;
			} elsif( $times1[1] > $times2[1] ){
				$ret_val = 1;
			} else {
				if( $times1[2] < $times2[2] ){
					$ret_val = -1;
				} elsif( $times1[2] > $times2[2] ){
					$ret_val = 1;
				} else {
					$ret_val = 0;
				}
			}
		}
	}

	return( $ret_val );
}

## Valid Version
#  Will determine if a given string is in the 'number.number.number' format of
# current GreyMatter versions.
# ARG1: The string to check
# RETURNS: 1 (true) or 0 (false)
sub _validVersion {
	my ($time) = @_;
	if ($time =~ /^(\d+\.\d+\.\d+)$/ ) {
		return Gm_Constants::TRUE;
	} else {
		return Gm_Constants::FALSE;
	}
}

## Convert Old Version
#  Will convert an old version number to the new format of
# current GreyMatter versions.
# ARG1: The string to check
# RETURNS: the string unchanged if it doesn't match a former Gm version, however
#  'one point zero' will be changed to '1.0.0'
sub _convertOldVersion {
	my $version = shift(@_);
	if( $version eq 'one point zero' ){
		$version = '1.0.0';
	} elsif( $version eq '1.1' ){
		$version = '1.1.0';
	} elsif( $version eq '1.2' ){
		$version = '1.2.0';
	} elsif( $version eq '1.21' ){
		$version = '1.2.1';
	} elsif( $version eq '1.21a' ){
		$version = '1.2.2';
	} elsif( $version eq '1.21b' ){
		$version = '1.2.3';
	} elsif( $version eq '1.21c' ){
		$version = '1.2.4';
	} elsif( $version eq '1.21d' ){
		$version = '1.2.5';
	} elsif( $version eq '1.21e' ){
		$version = '1.2.6';
	} elsif( $version eq '1.3' ){
		$version = '1.3.0';
	} elsif( $version eq '1.3a' ){
		$version = '1.3.1';
	}

	return( $version );
}

1;
