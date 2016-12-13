package Gm_Security;

###############################################################################
# Greymatter 1.8.2                             
# Copyright (c)2000-2008, The Greymatter team 
# http://greymatterforum.proboards82.com/     
# By possessing this software, you agree not to hold the author responsible for 
# any problems that may arise from your installation or usage of Greymatter 
# itself, or from any content generated by yourself or others through the use of 
# this program.  You <I>may</I> freely modify and redistribute this program, so 
# long as every copyright notice (including in this manual and in the Greymatter 
# code) remains fully intact.  Finally, you may <I>not</I> sell or in any way 
# make a financial profit from this program, either in original or modified form.
# Your possession of this software signifies that you agree to these terms; 
# please delete your copy of this software if you don't agree to these terms.
# Original Creators Noah Grey
###############################################################################


## Gm Security
# This package deals with security concerns of GreyMatter, primary being the 
# authentication of Authors.  
# 
# NOTE that this package is an attempt to abstract or rather to annonymize the way 
# that authors provide credentials and how they are verified.  Methods such as getUrlAuth
# allow the methods that use them to not care or know what fields are passed and how the data
# is encoded.  
#
# To correspond with this, the 'auth' method requires all the web request
# parameters, so as to not tie certain web parameters into validating the identity of the 
# author.  It is hoped that by providing these methods, GM can be more easily secured
# by ending the use of the author password in plaintext, or to even enable someone to
# write a Gm_Security module that uses PGP keys or even allow cookie based auth 
# (Gm_Web::printRequestHeader uses a Gm_Security function to alter the header).
#
# 
# CONVENTIONS
# 1. Return a string rather than printing, this is just more elegant.  Leave prints
#   to the calling subroutine
# 2. Private subroutines should start with the '_' character.  By private I mean
#   it will never be called outside of this package.
# 3. If you have more than 1 or 2 parameters, especially if they are not required,
#   use named parameters such as in createRadioButton.  By putting stuff in a 
#   hash we gain the flexibility to add more optional parameters without having
#   to pass in '' placeholders or modify existing code.
# 6. Use ' and " where appropriate.  If you don't have any variables or newlines
# then use ', its quicker and cleaner.  
# 7. Don't put all text on one huge long line.  It messes with some programs
# that don't do line wraps. 

use strict;
use warnings;

## why don't need to 'use' anything here?  wtf?? if you use Core or Storage, you get nasty error
## use Gm_Core;
## use Gm_Storage;

my $COOKIENAME = "gm_password";

## Auth
#  Will verify the creditials supplied by the web request.  Note that this method
# works off the web request, rather than specific parameters so that it can leverage
# the methods that supply url string and form parameters.  By not explicitly saying we
# need field X to auth, we are free to add more requirements to those methods as needed
# without changing all calls to this method
# ARG webparams => the web parameters give by the request
# (opt) ARG reauth => a flag for whether the user should be forced to give credentials again
#
# (opt) ARG checkperm => the permission to verify, as defined by Gm_Storage::getAuthors, 
#  'postnew', etc.  NOT IMPLEMENTED YET
# (opt) ARG permHandler => a handler to process when a user does not have the given 'checkperm', the
#  default permHandler used will log the attempt (if logging on) and display the admin menu 
#  with a message   NOT IMPLEMENTED YET
#
# RETURNS: reference to Author hash, a child element of Gm_Storage::getAuthors, else empty hash
#  NOTE: that this method should set 'section=login' in the webparams, if the author just authed.  It currently
#  does this, but if its rewritten to work with different auth system, this var triggers rest of UI code
# (welcome message, cplog message about who logged in, etc.)
# DEPRECATES: gm_login
sub auth {
	my (%params) = @_;

	## TODO: THIS SHOULD VERIFY INPUTS FOR SECURITY, JUST IN CASE ...

	my $errHandler = $params{'errHandler'} || \&Gm_Utils::gmWarn;
	my $IN = $params{'webparams'} || {};
	my $relogin = $params{'reauth'} || Gm_Constants::FALSE;
	
	## TODO: CHECK FOR DEFINED AND GIVE DEFAULT VALUES FOR AUTHORNAME AND AUTHORPASSWORD
	# THEN WE CAN AVOID WHO IF( DEFINED... GAME

	## DO NOT CHECK GM BANLIST, THAT IS NOT IN THE SECURITY DOMAIN
	# the credentialling system could use a different banlist, but it should not
	# use Gm's banlist, that must be taken care of in the cgi script

	## 1. Check if relogging in
	if( $relogin ){
	## exiting to function to make relogin
		_login( '<span class="status_msg">'.Gm_Core::text( Gm_Constants::RELOGIN ).'</span>' );
	}

	## 2. Checking if rebuilding and if token (DEPRECATED)
	## this should work off of params passed or cookie
# 	if( $IN->{'gmtoken'} && $IN->{'rebuilding'} ){
# warn 'Validating via token!';
# 		# read the token from the file where we persisted it
# 		my $path = Gm_Core::config( 'gmentriespath' );  ### BADDD! get rid of to go directly to storage or fix CORE
# 		my @gmtoken = @{Gm_Storage::readFile( loc=>"$path/gm-token.cgi",
# 			errHandler=>\&Gm_Web::displayAdminErrorExit )};
# 		my $gmtoken = $gmtoken[0];
# 		my $gmtokenauthor = $gmtoken[1];
# 		my $gmtokenpass = $gmtoken[2];
# 		
# 		# examine the token for validity
# 		if ($IN->{'gmtoken'} eq $gmtoken) { 
# 			$IN->{'authorname'} = $gmtokenauthor;
# 			$IN->{'authorpassword'} = $gmtokenpass;  ## this should already be crypted
# 		} else {
# 			# Bad Token
# 			Gm_Web::displayAdminErrorExit('An error occured while trying to authenticate via gm-token.');
# 		}
# 	}                  

	## 3. Check if hit login
	if( !defined( $IN->{'authorname'} ) || 
		!defined( $IN->{'authorpassword'} ) ){	
		## TODO, WE SHOULD NOT ALLOW CRYPTED PW TO BE SUBMITTED THROUGH LOGIN FORM BY RENAMING LOGIN
		# SCREEN VARIABLES AND CRYPTING HERE!
		if( $IN->{'login'} && !defined( $IN->{'loginname'} ) && !defined( $IN->{'loginpw'} ) ){
			## Failed to provide all information
			my $cpMsg = '<span class="error_msg">'.Gm_Core::text( Gm_Constants::LOGIN_INVALID_LOG, 
				{ AUTHOR=>$IN->{'authorname'}, PASSWORD=>$IN->{'authorpassword'} } ).'</span>';
			Gm_Core::writeToCplog( $cpMsg );
			## exiting function ... to login
			_login( '<span class="error_msg">'.Gm_Core::text( Gm_Constants::LOGIN_INVALID ).'</span>' );
			
		} elsif( $IN->{'login'} ){
			$IN->{'section'}='login'; ## to signal to rest of program
			$IN->{'authorname'} = $IN->{'loginname'};	
		} else {
			## exiting function ... to login
			_login(); ## this is the default case when first hit page
		}
	}
	
	## SHould we be cleaning this up or looking for hack checks?  Is this an exposure?
	$IN->{'authorname'} =~ s/\|//g;
	$IN->{'authorname'} = Gm_Utils::trimFrontWs( $IN->{'authorname'} );
	$IN->{'authorname'} = Gm_Utils::trimBackWs( $IN->{'authorname'} );	
	
	## Before we can auth, we need 1, authorname, 2 password
	## 4. Validate web params for valid author match
	my $gmvalidated = Gm_Constants::NO;
	my $gmauthors = Gm_Storage::getAuthors( errHandler=>$errHandler );
	my $selectedauthor = $gmauthors->{$IN->{'authorname'}};
	
	if( defined( $IN->{'authorname'} ) && defined( $selectedauthor->{'author'} ) && 
		$selectedauthor->{'author'} eq $IN->{'authorname'} ){

		## Since we are logging in, we are now crypting password with login form information
		# and selected password.  Note that hte password's first two characters are the 'salt'
		# passed to crypt.  By doing the crypt with the stored password, we are free to alter
		# the salt when saving a new author
		if( $IN->{'login'} ){
			my $crypted = crypt($IN->{'loginpw'}, $selectedauthor->{'password'});
			$IN->{'authorpassword'} = $crypted;
		}
		
		## SHould we be cleaning this up or looking for hack checks?  Is this an exposure?
		$IN->{'authorpassword'} =~ s/\|//g;
		$IN->{'authorpassword'} = Gm_Utils::trimFrontWs( $IN->{'authorpassword'} );
		$IN->{'authorpassword'} = Gm_Utils::trimBackWs( $IN->{'authorpassword'} );
		

		## NOTE: the stored password is being passed as salt (second arg to crypt), 
		# incase salt was added by program, notice that we are not crypting it, 
		# since stored pw and passed MUST MATCH
 		if( $selectedauthor->{'password'} eq $IN->{'authorpassword'} ){ 
			$gmvalidated = Gm_Constants::YES;
			## these are out of scope, and we are moving toward using yes or no anyway
# 			if ($selectedauthor->{'postnew'} eq Gm_Constants::Y ) { $gmentryaccess = Gm_Constants::YES; }
# 			if ($selectedauthor->{'editentries'} eq Gm_Constants::Y ) { $gmentryeditaccess = Gm_Constants::YES; }
# 			if ($selectedauthor->{'editentries'} eq 'O') { $gmentryeditaccess = 'mineonly'; }
# 			if ($selectedauthor->{'editconfigs'} eq Gm_Constants::Y ) { $gmconfigurationaccess = Gm_Constants::YES; }
# 			if ($selectedauthor->{'edittemplates'} eq Gm_Constants::Y ) { $gmtemplateaccess = Gm_Constants::YES; }
# 			if ($selectedauthor->{'edittemplates'} eq 'O') { $gmtemplateaccess = 'hfsonly'; }
# 			if ($selectedauthor->{'editauthors'} eq Gm_Constants::Y ) { $gmauthoraccess = Gm_Constants::YES; }
# 			if ($selectedauthor->{'rebuild'} eq Gm_Constants::Y ) { $gmrebuildaccess = Gm_Constants::YES; }
# 			if ($selectedauthor->{'viewcplog'} eq Gm_Constants::Y ) { $gmcplogaccess = Gm_Constants::YES; }
# 			if ($selectedauthor->{'bookmarklets'} eq Gm_Constants::Y ) { $gmbookmarkletaccess = Gm_Constants::YES; }
# 			if ($selectedauthor->{'upload'} eq Gm_Constants::Y ) { $gmuploadaccess = Gm_Constants::YES; }
# 			if ($selectedauthor->{'viewadmin'} eq Gm_Constants::Y ) { $gmloginaccess = Gm_Constants::YES; }
		} else {
			## BAD PW
			my $cpMsg = '<span class="error_msg">'.Gm_Core::text( Gm_Constants::LOGIN_BAD_PW_LOG, 
				{ AUTHOR=>$IN->{'authorname'}, PASSWORD=>$IN->{'authorpassword'} } ).'</span>';
			Gm_Core::writeToCplog( $cpMsg );
			_login( '<span class="error_msg">'.Gm_Core::text( Gm_Constants::LOGIN_BAD_PW ).'</span>' );
		}
		
	} else {
		## BAD USERNAME
			my $cpMsg = '<span class="error_msg">'.Gm_Core::text( Gm_Constants::LOGIN_BAD_NAME_LOG, 
				{ AUTHOR=>$IN->{'authorname'}, PASSWORD=>$IN->{'authorpassword'} } ).'</span>';
			Gm_Core::writeToCplog( $cpMsg );
			_login( '<span class="error_msg">'.Gm_Core::text( Gm_Constants::LOGIN_BAD_NAME ).'</span>' );
	}

	return( $selectedauthor );
}


## Verify Author
#  Will verify that the username and author provided is correct.
# NOTE that this is a psuedo private subroutine and should only be called by
# methods that really need to.  This subroutine works on the idea of username/password
# pairing and any changes to the auth scheme will require this be changed, as well
# as every place it is used.
# ARG authorname => the name of the author to verify
# ARG authorpw => the password supplied by the author, raw or encoded
# RETURNS: 1 for verified, 0 for failure to verify
sub verifyAuthor {
}

## Get Url Auth
#  Will return a string of creditials that can be validated when the request is returned.
# Note that this method
# works off the web request, rather than specific parameters so that it can leverage
# the methods that supply url string and form parameters.  By not explicitly saying we
# need field X to auth, we are free to add more requirements to those methods as needed
# without changing all calls to this method
# ARG author => the reference to a single Author to verify, as defined by Gm_Storage::getAuthors, 
#  and returned by Gm_Security::auth
# (opt) ARG errHandler => an error handler that should take an error message as an argument
# RETURNS: string to be inserted into a url, reserves param names 'authorname', 'authorpassword', 'gmk'
sub getUrlAuth {
	my (%params) = @_;

	my $errHandler = $params{'errHandler'} || \&Gm_Utils::gmWarn;

	my $author = $params{'author'} || 
		Gm_Utils::gmWarn('Invalid author passed into getFormAuth');

	my $authString = '';
	
	my $urlAuthor = $author->{'author'};
	my $urlPassword = $author->{'password'};
	
	## TODO: use url encode here, or whatever its called from CGI.pm
	$urlAuthor =~ s/ /\+/g;
	$urlPassword =~ s/ /\+/g;
	
	$authString .= 'authorname='.$urlAuthor.'&authorpassword='.$urlPassword;
	
	return( $authString );
}

## Get Form Auth
#  Will return a string of creditials that can be validated when the request is returned.
# Note that this method
# works off the web request, rather than specific parameters so that it can leverage
# the methods that supply url string and form parameters.  By not explicitly saying we
# need field X to auth, we are free to add more requirements to those methods as needed
# without changing all calls to this method
# ARG author => the reference to a single Author to verify, as defined by Gm_Storage::getAuthors, 
#  and returned by Gm_Security::auth
# (opt) ARG errHandler => an error handler that should take an error message as an argument
# RETURNS: string to be inserted into a form, reserves param names 'authorname', 'authorpassword', 'gmk'
sub getFormAuth {
	my (%params) = @_;

	my $errHandler = $params{'errHandler'} || \&Gm_Utils::gmWarn;

	my $author = $params{'author'} || 
		Gm_Utils::gmWarn('Invalid author passed into getFormAuth');

	my $authString = '';
	
	$authString .= '<input type=hidden name="authorname" value="'.$author->{'author'}.'" />';
	$authString .= '<input type=hidden name="authorpassword" value="'.$author->{'password'}.'" />';
	
	return( $authString );
}

## Get Header Auth
#  Will return a string of creditials that can be validated when the request is returned.
# Note that this method
# works off the web request, rather than specific parameters so that it can leverage
# the methods that supply url string and form parameters.  By not explicitly saying we
# need field X to auth, we are free to add more requirements to those methods as needed
# without changing all calls to this method
# ARG author => the reference to a single Author to verify, as defined by Gm_Storage::getAuthors, 
#  and returned by Gm_Security::auth
# (opt) ARG errHandler => an error handler that should take an error message as an argument
# RETURNS: string to be inserted into a form, reserves param names 'authorname', 'authorpassword', 'gmk'
sub getHeaderAuth {
	my (%params) = @_;
	
	my %headers = ();

	## todo set a cookie or some such thing, we will need the author information
	# for cookies will only  need to set once

	return( %headers );
}



## hack Web Test
#  Will test for a hack attempts against web data,
# these are hack attempts against the user
# ARG1: The text to test for iframes and other hackish stuff
# RETURNS: 1 if a hack is detected, 0 otherwise
sub hackWebTest {
	my $text = shift(@_) || '';
	my $ret_val = 0;
	
	# Testing for someone trying to insert <? ...
	if( $text =~ m/<\s*?\?/gi ){
		$ret_val = 1;
	}

	# Testing for someone trying to insert <script
	if( $text =~ m/<\s*?script/gi ){
		$ret_val = 1;
	}

	# Testing for someone trying to insert <%
	if( $text =~ m/<\s*?%/gi ){
		$ret_val = 1;
	}
	
	# Testing for someone trying to insert <iframe
	if( $text =~ m/<\s*?iframe/gi ){
		$ret_val = 1;
	}
	
	## TODO: ADD ASP AND SERVER SIDE INLINE HACK ATTEMPS AND PHP
	
	return( $ret_val );
}


## hack Command Line test Test
#  Will test for a hack attempts against processes that interact with host machine,
# this are hack attempts to compromise the host box
# ARG1: The text to test for iframes and other hackish stuff
# (opt) ARG2: flag if its ok to have a relative path, skips tree traversal test
# RETURNS: 1 if a hack is detected, 0 otherwise
sub hackClTest {
	my $text = shift(@_) || '';
	my $skiptree = shift(@_) || '0';	
	my $ret_val = 0;
	
  ## Null bit test
	if( $text =~ m/\0/gi ){
		$ret_val = 1;
	}
	
  ## tree traversal test
	if( $text =~ m/\.\.\//gi && !$skiptree){
		$ret_val = 1;
	}
	
  ## pipe test
	if( $text =~ m/\|/gi ){
		$ret_val = 1;
	}
	
	return( $ret_val );
}


## Login (private)
#  Will present the user a form for credentialling themselves.
# NOTE:  Why is this here?  Isn't this the wrong place?  Since how the user
# provides credentials is essential to verifying those credentials, it makes sense
# that login (although a more generic name might be wanted) is the domain
# of the Security module.  In fact, this method should be considered private
# to this Module, as no one, but Gm_Security::auth should call it, or even be aware
# of _how_ a user authenticates.  The auth subroutine should handle getting a user's
# credentials, verifying them, and sending them back to where they came from if needed.
# In fact, login could even redirect to an external verification system (like a 
# Central Auth Agency that would return them back here).
# (opt) ARG1: Message to display to user, could be error or confirmation of action
 sub _login {
	my $message = shift( @_ ) || Gm_Constants::EMPTY;

	## TODO PERHAPS THIS SHOULD USE CUSTOM ERRORHANDLER TO GIVE USER OPTION TO FIX FILES?
	## DIAGNOSITICS CHMODS, BUT COULD GET TO IT IF IT DIDN'T ALREADY WORK, REALLY NEED
	## TO RESTRICT DIAGNOSITIC ACCESS?
	Gm_Storage::validateResources( errHandler=>\&Gm_Web::displayAdminErrorExit );

	if ($message eq Gm_Constants::EMPTY) { 
		$message = '<span class="section_title">'.Gm_Core::text( Gm_Constants::LOGIN_TITLE ).
		"</span><br />\n";
	}

	my $configs = Gm_Storage::getConfigs( errHandler=>\&Gm_Web::displayAdminErrorExit );
	my $getnameandpwcookie = '';
	if( $configs->{'gmcookiesallowed'} eq Gm_Constants::NO ){
		$getnameandpwcookie = Gm_Constants::EMPTY;
	} else {
		## Ironically, we aren't setting the cookies in this module, BAD, see note in gm.cgi::frontPage
		$getnameandpwcookie = "<SCRIPT TYPE=\"text/javascript\" LANGUAGE=\"JavaScript\">\n<!--//\n".
			"document.gmloginform.loginname.value = getCookie(\"gmcookiename\");\n".
			"document.gmloginform.loginpw.value = getCookie(\"$COOKIENAME\");\n".
			"document.gmloginform.loginname.focus();\n//-->\n</SCRIPT>";
	}

	## TODO: THESE ELEMENTS SHOULD BE REVALIDATED BEFORE DOING ANYTHING WITH, LIKE IN AUTH
	my $page = "$message";
	
	## NOTE: Why aren't we using web params to keep username and password in the fields?
	# They would only repopulate if they were wrong, so by forcing user to retype, hopefully will 
	# correct any mistake
	$page .= '<p><form action="gm.cgi" method="post" name="gmloginform">'.
		'<table width="80%" class="form_table"><tr><th width="40%"><label for="loginname">'.
		Gm_Core::text( Gm_Constants::LOGIN_AUTHOR ).':</label></th><td>'.
  	'<input type="text" class="textinput" size=20 name="loginname" class="inputfield"></td></tr>'.
		'<tr><th><label for="loginpw">'. Gm_Core::text( Gm_Constants::PW ).
		':</label></th><td><input type="password" class="textinput" size=20 name="loginpw" '.
		'class="inputfield"></td></td></table></p>';
	$page .= '<p><INPUT TYPE=SUBMIT CLASS="button" name="login" VALUE="'.
		Gm_Core::text( Gm_Constants::LOGIN_ENTER ).'" STYLE="background: #D0FFD0; width: 75"></form></p>';

	$page .= "$getnameandpwcookie\n";

	Gm_Web::displayAdminPageExit( $page );
	exit(0); ## should never actually get here...
}


1;
