gmsmartentrymoodtemplate=mood: {{entrymood}}<br />
gmentryseparatortemplate=<hr />
gmfootertemplate=</div>|*||*|	<br clear="all" />|*|<!-- http://greymatterforum.proboards.com/-->|*|</div>|*|</body>|*|</html>
gmpreviouslinktemplate=[<a href="{{previouspagelink}}" onmouseover="window.status='{{previousmonthmonth}}/{{previousdayday}}/{{previousyear}}: {{previousentrysubject}}';return true" onmouseout="window.status='';return true">Previous entry: "{{previousentrysubject}}"</a>]
gmarchiveentryseparatortemplate=<br />
gmentrypagelinktemplate=<a href="{{pagelink}}">{{monthmonth}}/{{dayday}}/{{yearyear}}: {{entrysubject}}</a>|*|<br />
gmcustomtwotemplate=
gmpreviousmorelinktemplate=[<a href="{{previouspagelink}}" onmouseover="window.status='{{previousmonthmonth}}/{{previousdayday}}/{{previousyear}}: {{previousentrysubject}}';return true" onmouseout="window.status='';return true">Previous entry: "{{previousentrysubject}}"</a>]
gmcalendartablebeginningtemplate=<!-- calendar code begin -->|*|<table border="1" cellpadding="2" cellspacing="0" class="calendar"><tr><td align="center" colspan="7"><span style="font-weight:bold;">{{monthword}} {{yearyear}}</span></td></tr><tr><td align="center"><span style="font-weight:bold;">S</span></td><td align="center"><span style="font-weight:bold;">M</span></td><td align="center"><span style="font-weight:bold;">T</span></td><td align="center"><span style="font-weight:bold;">W</span></td><td align="center"><span style="font-weight:bold;">T</span></td><td align="center"><span style="font-weight:bold;">F</span></td><td align="center"><span style="font-weight:bold;">S</span></td></tr>|*|<tr>
gmcommentlinktargettemplate=target="_new"
gmarchiveentrytemplate=<div class="content">|*|<h2>{{entrysubject}}</h2>|*|<p>{{smartentrymusic}}|*|{{smartentrymood}}|*|{{entrymainbody}}|*|<br />|*|{{authorsmartlink}} on {{monthmonth}}.{{dayday}}.{{year}} @ {{hourhour}}:{{minuteminute}} {{ampm}} {{timezone}} [<a href="{{pagelink}}" title="{{monthmonth}}/{{dayday}}/{{year}}: {{entrysubject}}">link</a>]{{commentslink}}|*|</p>|*|</div>
gmcalendarblankcelltemplate=<td align="center">&#160;</td>
gmdatetemplate=<div style="border: double black 3px;"><span class="raised">{{weekday}}, {{monthword}} {{dayappend}}</span><br />
gmnextlinktemplate=[<a href="{{nextpagelink}}" onmouseover="window.status='{{nextmonthmonth}}/{{nextdayday}}/{{nextyear}}: {{nextentrysubject}}';return true" onmouseout="window.status='';return true">Next entry: "{{nextentrysubject}}"</a>]
gmsmartentrymusictemplate=music: {{entrymusic}}<br />
gmcommentpreviewdividertemplate=<a name="comments"> </a>|*|<p align="center">|*|<strong>Previewing Your Comment</strong>|*|</p>
gmarchiveindextemplate={{header}}|*|{{logbody}}|*|{{footer}}
gmcalendarweekfulldaytemplate= [{{day}}]
gmmoreentrytemplate=<div class="content">|*|<h2>{{entrysubject}}</h2>|*|<p>{{smartentrymusic}}|*|{{smartentrymood}}|*|{{entrymainbody}}|*|<br />{{karmalink}}|*|{{authorsmartlink}} on {{monthmonth}}.{{dayday}}.{{year}} @ {{hourhour}}:{{minuteminute}} {{ampm}} {{timezone}} [<a href="{{pagelink}}" title="{{monthmonth}}/{{dayday}}/{{year}}: {{entrysubject}}">link</a>]{{commentslink}}|*|</p>|*|</div>
gmusererrorheadertemplate=<!DOCTYPE HTML>|*|<html><head><title>MY WEBLOG</title>|*|<meta charset="UTF-8">|*|<link rel="stylesheet" type="text/css" href="css/gm.css">|*|</head>|*|<body>|*|<div id="frame">|*||*|	<h1 class="header"> My Weblog </h1>|*|	<div id="contentcenter">|*|<div style="border: double black 3px;"><span class="raised"><b><font color="#FF0000">Error Notice</font></b></span><br /><p>
gmsidebartemplate=<p><a href="{{pageindexlink}}">Home</a><br />|*|<a href="{{pagearchiveindexlink}}">Archives</a><br />|*||*|<a href="#">Fake Link One</a><br />|*|<a href="#">Fake Link Two</a><br />|*|<a href="#">Fake Link Three</a><br /><br />|*||*|<a href="http://greymatterforum.proboards82.com/" target="_blank">Greymatter Forums</a></p>|*||*|{{calendar}}|*||*|{{searchform}}|*||*|<p align="center">|*|  <a href="http://validator.w3.org/check/referer"><img src="http://www.w3.org/Icons/valid-xhtml10"    alt="Valid XHTML 1.0!" height="31" width="88" border="0" /></a><br /><br />|*|{{gmicon}}|*|</p>
gmstayattoptemplate=<div class="content">|*|<h2>{{entrysubject}}</h2>|*|<p>{{smartentrymusic}}|*|{{smartentrymood}}|*|{{entrymainbody}}|*|<br />|*|{{authorsmartlink}} on {{monthmonth}}.{{dayday}}.{{year}} @ {{hourhour}}:{{minuteminute}} {{ampm}} {{timezone}} [<a href="{{pagelink}}" title="{{monthmonth}}/{{dayday}}/{{year}}: {{entrysubject}}">link</a>]{{commentslink}}|*|</p>|*|</div>
gmsearchformtemplate=<!-- searchform code begin -->|*|<br><div class="searchform">|*|<form action="{{cgiwebpath}}/gm-comments.cgi" method="post"><div style="text-align:right;"><input type="text" name="gmsearch" size="20" class="text" /></div>|*|<div style="text-align:right;"><input type="submit" value="Search" class="button" /></div></form></div>|*|<!-- searchform code end -->
gmcustomtentemplate=
gmsmartlinknocommentstemplate=No Comments
gmsmartlinkonecommenttemplate=1 Comment
gmsearchresultsentrytemplate=<a href="{{pagelink}}">{{monthmonth}}/{{dayday}}/{{yearyear}}: {{entrysubject}}</a>|*|<em>{{entrymainbodyfirstwords 20}}...</em>
gmentrypagelinkyearseparatortemplate=
gmarchiveentrypagetemplate={{header}}|*|{{cookiescode}}|*|<div class="content">|*|<div class="path"><a href="{{pageindexlink}}" title="back to frontpage">Home</a> &raquo; <a href="{{pagearchiveindexlink}}" title="weblog archives">Archives</a> &raquo; <a href="{{entrieswebpath}}/archive-{{monthmonth}}{{yearyear}}.{{archivesuffix}}" title="archive of {{monthword}} {{yearyear}}">{{monthword}} {{yearyear}}</a> &raquo; {{entrysubject}}</div><br />|*|<p>|*|{{previouslink}} {{nextlink}}|*|</p>|*||*|<h1>{{monthmonth}}/{{dayday}}/{{yearyear}}: "{{entrysubject}}"</h1>|*|{{smartentrymusic}}{{smartentrymood}}|*|<p>|*|{{entrymainbody}}|*|<br /><br />|*|{{entrymorebody}}|*|</p>|*|</div>|*||*|<div class="content">|*|{{commentdivider}}|*|{{entrycomments}}|*|{{entrycommentsform}}|*|</div> |*|{{footer}}
gmnextmorelinktemplate=[<a href="{{nextpagelink}}" onmouseover="window.status='{{nextmonthmonth}}/{{nextdayday}}/{{nextyear}}: {{nextentrysubject}}';return true" onmouseout="window.status='';return true">Next entry: "{{nextentrysubject}}"</a>]
gmparaseparationtemplate=<br /><br />
gmarchivemasterindextemplate={{header}}|*|<div class="content">|*|<div class="path"><a href="{{pageindexlink}}" title="back to frontpage">Home</a> &raquo; Archives</div><br />|*|<h1>Log Archives</h1>|*|<p>{{logarchivelist}}</p>|*|</div>|*||*|<div class="content">|*|<h1>Entries</h1>|*|<p>{{logentrylist}}</p>|*|</div>|*||*|{{footer}}
gmsmartlinkmanycommentstemplate={{commentsnumber}} Comments
gmcustomsixtemplate=                                                      
gmentrypagelinkseparatortemplate=
gmcommentsformtemplate=<!-- commentsform code begin -->|*||*|<div align="center">|*|<form action="{{cgiwebpath}}/gm-comments.cgi#comments" method="post" name="newcomment">|*|<table cellpadding="0" cellspacing="2">|*|<tr>|*|<td align="center" colspan="2">|*|<input name="newcommententrynumber" type="hidden" value="{{entrynumber}}" />|*|<span style="font-weight:bold;">New Comment</span>|*|</td>|*|</tr>|*|<tr>|*|<td align="right">Name: </td>|*|<td><input name="newcommentauthor" size="30" type="text" class="text" /></td>|*|</tr>|*|<tr>|*|<td align="right">E-Mail: </td>|*|<td><input name="newcommentemail" size="30" type="text" class="text" /></td>|*|</tr>|*|<tr>|*|<td align="right">Homepage: </td>|*|<td><input name="newcommenthomepage" size="30" type="text" class="text" /></td>|*|</tr>|*|<tr>|*|<td>|*|{{smartemoticonscode}}|*|</td>|*|<td>|*|<textarea cols="25" name="newcommentbody" rows="10" class="text"></textarea>|*|</td>|*|</tr>|*|<tr>|*|<td>&nbsp;</td>|*|<td align="center">|*|<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">|*|<!--//|*|document.newcomment.newcommentauthor.value = getCookie("gmcmtauth");|*|document.newcomment.newcommentemail.value = getCookie("gmcmtmail");|*|document.newcomment.newcommenthomepage.value = getCookie("gmcmthome");|*|document.newcomment.newcommentauthor.focus();|*|//-->|*|</SCRIPT>|*|<input name="bakecookie" type="checkbox" />Save Info?<br />|*|<input type="reset" value="Reset" class="button" />|*|<input name="gmpostpreview" type="submit" value="Preview" class="button" />|*|<input type="submit" value="Submit" class="button"  onClick="javascript:setGMcookies()" />|*|</td>|*|</tr>|*|</table>|*|</form>|*|</div>|*|<!-- commentsform code end -->
gmcustomseventemplate=
gmdatearchivetemplate=<div style="border: double black 3px;"><span class="raised">{{weekday}}, {{monthword}} {{dayappend}}</span><br />
gmentrytemplate=<div class="content">|*|<h2>{{entrysubject}}</h2>|*|<p>{{smartentrymusic}}|*|{{smartentrymood}}|*|{{entrymainbody}}|*|<br />{{karmalink}}|*|{{authorsmartlink}} on {{monthmonth}}.{{dayday}}.{{year}} @ {{hourhour}}:{{minuteminute}} {{ampm}} {{timezone}} [<a href="{{pagelink}}" title="{{monthmonth}}/{{dayday}}/{{year}}: {{entrysubject}}">link</a>]{{commentslink}}|*|</p>|*|</div>
gmcustomonetemplate=
gmsmartemoticonscodetemplate=<script type="text/javascript">|*|<!--// |*|function commentEmoticon(code)|*|{|*|	var cache = document.newcomment.newcommentbody.value;|*||*|	document.newcomment.newcommentbody.value = cache + " " + code;|*|	document.newcomment.newcommentbody.focus();|*|}|*|//-->|*|</script>|*|<table cellpadding="0" cellspacing="0">|*|<tr>|*|<td align="center" colspan="3">Smilies:</td>|*|</tr>|*|<tr>|*|<td><img onclick="commentEmoticon(':)')" src="{{emoticonspath}}/smile.gif" alt="smile" /></td>|*|<td><img onclick="commentEmoticon(':O')" src="{{emoticonspath}}/shocked.gif" alt="shocked" /></td>|*|<td><img onclick="commentEmoticon(':(')" src="{{emoticonspath}}/sad.gif" alt="sad" /></td>|*|</tr>|*|<tr>|*|<td><img onclick="commentEmoticon(':D')" src="{{emoticonspath}}/biggrin.gif" alt="big grin" /></td>|*|<td><img onclick="commentEmoticon(':P')" src="{{emoticonspath}}/tongue.gif" alt="razz" /></td>|*|<td><img onclick="commentEmoticon(';)')" src="{{emoticonspath}}/wink.gif" alt="*wink wink* hey baby" /></td>|*|</tr>|*|<tr>|*|<td><img onclick="commentEmoticon(':angry:')" src="{{emoticonspath}}/angry.gif" alt="angry, grr" /></td>|*|<td><img onclick="commentEmoticon(':blush:')" src="{{emoticonspath}}/blush.gif" alt="blush" /></td>|*|<td><img onclick="commentEmoticon(':confused:')" src="{{emoticonspath}}/confused.gif" alt="confused" /></td>|*|</tr>|*|<tr>|*|<td><img onclick="commentEmoticon(':cool:')" src="{{emoticonspath}}/cool.gif" alt="cool" /></td>|*|<td><img onclick="commentEmoticon(':crazy:')" src="{{emoticonspath}}/crazy.gif" alt="crazy" /></td>|*|<td><img onclick="commentEmoticon(':cry:')" src="{{emoticonspath}}/cry.gif" alt="cry" /></td>|*|</tr>|*|<tr>|*|<td><img onclick="commentEmoticon(':doze:')" src="{{emoticonspath}}/doze.gif" alt="sleepy" /></td>|*|<td><img onclick="commentEmoticon(':hehe:')" src="{{emoticonspath}}/hehe.gif" alt="hehe" /></td>|*|<td><img onclick="commentEmoticon(':laugh:')" src="{{emoticonspath}}/laugh.gif" alt="LOL" /></td>|*|</tr>|*|<tr>|*|<td><img onclick="commentEmoticon(':plain:')" src="{{emoticonspath}}/plain.gif" alt="plain jane" /></td>|*|<td><img onclick="commentEmoticon(':rolleyes:')" src="{{emoticonspath}}/rolleyes.gif" alt="rolls eyes" /></td>|*|<td><img onclick="commentEmoticon(':satisfied:')" src="{{emoticonspath}}/satisfied.gif" alt="satisfied" /></td>|*|</tr>|*|</table>
gmheadertemplate=<!DOCTYPE HTML>|*|<html><head><title>My Weblog: {{entrysubject}}</title>|*|<meta charset="UTF-8">|*|<link rel="stylesheet" type="text/css" href="css/gm.css">|*|</head>|*|<body>|*|<div id="frame">|*||*|	<h1 class="header"> My Weblog </h1>|*|	<div id="contentright">|*|{{sidebar}}|*|	</div>|*|	<div id="contentcenter">
gmdategroupingfootertemplate=</div><br />
gmmoreentrypagetemplate={{header}}|*|{{cookiescode}}|*|<div class="content">|*|<div class="path"><a href="{{pageindexlink}}" title="back to frontpage">Home</a> &raquo; <a href="{{pagearchiveindexlink}}" title="weblog archives">Archives</a> &raquo; <a href="{{entrieswebpath}}/archive-{{monthmonth}}{{yearyear}}.{{archivesuffix}}" title="archive of {{monthword}} {{yearyear}}">{{monthword}} {{yearyear}}</a> &raquo; {{entrysubject}}</div><br />|*|<p>|*|{{previouslink}} {{nextlink}}|*|</p>|*||*|<h1>{{monthmonth}}/{{dayday}}/{{yearyear}}: "{{entrysubject}}"</h1>|*|{{smartentrymusic}}{{smartentrymood}}|*|<p>|*|{{entrymainbody}}|*|<br /><br />|*|{{entrymorebody}}|*|</p>|*|</div>|*||*|<div class="content">|*|{{commentdivider}}|*|{{entrycomments}}|*|{{entrycommentsform}}|*|</div> |*|{{footer}}
gmusererrorfootertemplate=</p>|*|</div><br />|*|</div>|*||*|	<br clear="all" />|*|<!-- http://greymatterforum.proboards.com/-->|*|</div>|*|</body>|*|</html>
gmkarmaformtemplate=Vote on this entry's karma: <a href="{{positivekarmalink}}" onmouseover="window.status='Cast a positive vote on this entry';return true" onmouseout="window.status='';return true">+</a>/<a href="{{negativekarmalink}}"  onmouseover="window.status='Cast a negative vote on this entry';return true" onmouseout="window.status='';return true">-</a> (currently at {{totalkarma}} karma)
gmcommentauthorhomepagetemplate=[<a href="{{commentauthorhomepageabsolute}}" rel="nofollow">homepage</a>]
gmcommentslinktemplate= [<a href="{{commentspostlink}}" onmouseover="window.status='Add a comment to this entry';return true" onmouseout="window.status='';return true">{{commentstatussmart}}</a>]
gmpopupcodetemplate=<a href="#" onmouseover="window.status='{{monthmonth}}/{{dayday}}/{{year}}: {{popuptitle}} (opens popup window)';return true" onmouseout="window.status='';return true" onclick="window.open('{{entrieswebpath}}/{{popuphtmlfile}}','{{randomnumber 1111-9999}}','width={{popupwidth}},height={{popupheight}},directories=no,location=no,menubar=no,scrollbars=no,status=no,toolbar=no,resizable=no,screenx=50,screeny=50');return false">
gmcookiescodetemplate=<script type="text/javascript">|*|<!--//|*||*|// Copyright (c) 1996-1997 Athenia Associates.|*|// http://www.webreference.com/js/|*|// License is granted if and only if this entire|*|// copyright notice is included. By Tomer Shiran.|*||*|function setCookie(name, value, expires, path, domain, secure) {|*|  var curCookie = name + "=" + escape(value) + ((expires) ? "; expires=" |*|	+ expires.toGMTString() : "") + ((path) ? "; path=" + path : "") |*|	+ ((domain) ? "; domain=" + domain : "") + ((secure) ? "; secure" : "");|*|document.cookie = curCookie;|*|}|*||*|function getCookie(name) {|*|var prefix = name + "=";|*|var nullstring = "";|*|var cookieStartIndex = document.cookie.indexOf(prefix);|*|if (cookieStartIndex == -1)|*|return nullstring;|*|var cookieEndIndex = document.cookie.indexOf(";", cookieStartIndex |*|	+ prefix.length);|*|if (cookieEndIndex == -1)|*|cookieEndIndex = document.cookie.length;|*|return unescape(document.cookie.substring(cookieStartIndex |*|	+ prefix.length, cookieEndIndex));|*|}|*||*|function deleteCookie(name, path, domain) {|*|if (getCookie(name)) {|*|document.cookie = name + "=" + ((path) ? "; path=" + path : "") |*|	+ ((domain) ? "; domain=" + domain : "") |*|	+ "; expires=Thu, 01-Jan-70 00:00:01 GMT"|*|};|*|}|*||*|function fixDate(date) {|*|var base = new Date(0);|*|var skew = base.getTime();|*|if (skew > 0)|*|date.setTime(date.getTime() - skew);|*|}|*|function setGMcookies() {|*|if (document.newcomment.bakecookie.checked){|*|    var now = new Date();|*|    fixDate(now); |*|    now.setTime(now.getTime() + 365 * 24 * 60 * 60 * 1000); |*|    setCookie('gmcmtauth', document.newcomment.newcommentauthor.value,   now, '', '{{domain}}',''); |*|    setCookie('gmcmtmail', document.newcomment.newcommentemail.value ,   now, '', '{{domain}}',''); |*|	setCookie('gmcmthome', document.newcomment.newcommenthomepage.value, now, '', '{{domain}}',''); |*|	}|*|}	 |*|function deleteGMcookies() {|*|    deleteCookie('gmcmtmail','','{{domain}}');|*|    deleteCookie('gmcmthome','','{{domain}}');|*|    deleteCookie('gmcmtauth','','{{domain}}');|*|    document.newcomment.newcommentemail.value =    '';|*|	document.newcomment.newcommentauthor.value =   '';|*|	document.newcomment.newcommenthomepage.value = '';	|*|}	|*|//-->|*|</script>
gmentrypagetemplate={{header}}|*|{{cookiescode}}|*|<div class="content">|*|<div class="path"><a href="{{pageindexlink}}" title="back to frontpage">Home</a> &raquo; <a href="{{pagearchiveindexlink}}" title="weblog archives">Archives</a> &raquo; <a href="{{entrieswebpath}}/archive-{{monthmonth}}{{yearyear}}.{{archivesuffix}}" title="archive of {{monthword}} {{yearyear}}">{{monthword}} {{yearyear}}</a> &raquo; {{entrysubject}}</div><br />|*|<p>|*|{{previouslink}} {{nextlink}}|*|</p>|*||*|<h1>{{monthmonth}}/{{dayday}}/{{yearyear}}: "{{entrysubject}}"</h1>|*|{{smartentrymusic}}{{smartentrymood}}|*|<p>|*|{{entrymainbody}}|*|<br /><br />|*|{{entrymorebody}}|*|</p>|*|</div>|*||*|<div class="content">|*|{{commentdivider}}|*|{{entrycomments}}|*|{{entrycommentsform}}|*|</div> |*|{{footer}}
gmindextemplate={{header}}|*|{{logbody}}|*|{{footer}}
gmcustomthreetemplate=
gmcalendartableendingtemplate=</tr>|*|</table>|*|<!-- calendar code end -->
gmkarmalinktemplate= [Karma: {{totalkarma}} (<a href="{{positivekarmalink}}" onmouseover="window.status='Cast a positive vote on this entry';return true" onmouseout="window.status='';return true">+</a>/<a href="{{negativekarmalink}}"  onmouseover="window.status='Cast a negative vote on this entry';return true" onmouseout="window.status='';return true">-</a>)]
gmsearchresultspagetemplate={{header}}|*|<div class="path"><a href="{{pageindexlink}}" title="back to frontpage">Home</a> &raquo; search results</div><br />|*|<p>|*|<strong>Search results for "{{searchterm}}" ({{searchmatches}} matches)</strong>|*|{{searchresults}}|*|[<a href="{{pageindexlink}}">Return To Main Index</a>]|*|</p>|*|{{footer}}
gmcustomfourtemplate=
gmcalendarweekfulldaylinktemplate= [<a href="{{pagelink}}">{{day}}</a>]
gmcommentpreviewformtemplate=<p align="center">|*|A preview of your new comment is shown above as it will appear on this page.  Click "Post It" below to post it, or click the back button on your browser to re-edit it.|*|<br>|*|<form action="{{cgiwebpath}}/gm-comments.cgi" method="post">|*|<input type="hidden" name="newcommententrynumber" value="{{entrynumber}}" />|*|<input type="hidden" name="newcommentauthor" value="{{previewcommentauthor}}" />|*|<input type="hidden" name="newcommentemail" value="{{previewcommentemail}}" />|*|<input type="hidden" name="newcommenthomepage" value="{{previewcommenthomepage}}" />|*|<input type="hidden" name="newcommentbody" value="{{previewcommentbody}}" />|*|<input type="submit" name="postit" value="Post It" />|*|</form>|*|</p>
gmmorearchiveentrytemplate=<div class="content">|*|<h2>{{entrysubject}}</h2><br />|*|<p>{{smartentrymusic}}|*|{{smartentrymood}}<br />|*|{{entrymainbody}}|*|<br />|*|{{authorsmartlink}} on {{monthmonth}}.{{dayday}}.{{year}} @ {{hourhour}}:{{minuteminute}} {{ampm}} {{timezone}} [<a href="{{pagelink}}" title="{{monthmonth}}/{{dayday}}/{{year}}: {{entrysubject}}">more..</a>]{{commentslink}}|*|</p>|*|</div>
gmcommentauthoremailtemplate=[<a href="mailto:{{commentauthoremailabsolute}}" rel="nofollow">e-mail</a>]
gmlinktargettemplate=
gmlogarchiveslinktemplate=<a href="{{pagearchivelogindexlink}}">{{monthword}} {{yearyear}}</a>|*|<br />
gmentrypagelinkdayseparatortemplate=
gmcommentdividertemplate=<a name="comments"> </a>|*|<p align="center">|*|<strong>Replies: {{commentstatussmart}}</strong>|*|</p>
gmmorearchiveentrypagetemplate={{header}}|*|{{cookiescode}}|*|<div class="content">|*|<div class="path"><a href="{{pageindexlink}}" title="back to frontpage">Home</a> &raquo; <a href="{{pagearchiveindexlink}}" title="weblog archives">Archives</a> &raquo; <a href="{{entrieswebpath}}/archive-{{monthmonth}}{{yearyear}}.{{archivesuffix}}" title="archive of {{monthword}} {{yearyear}}">{{monthword}} {{yearyear}}</a> &raquo; {{entrysubject}}</div><br />|*|<p>|*|{{previouslink}} {{nextlink}}|*|</p>|*||*|<h1>{{monthmonth}}/{{dayday}}/{{yearyear}}: "{{entrysubject}}"</h1>|*|{{smartentrymusic}}{{smartentrymood}}|*|<p>|*|{{entrymainbody}}|*|<br /><br />|*|{{entrymorebody}}|*|</p>|*|</div>|*||*|<div class="content">|*|{{commentdivider}}|*|{{entrycomments}}|*|{{entrycommentsform}}|*|</div> |*|{{footer}}
gmentrypagelinkmonthseparatortemplate=
gmlogarchiveslinkweeklytemplate=<a href="{{pagearchivelogindexlink}}">{{weekbeginningmonthmonth}}/{{weekbeginningdayday}}/{{weekbeginningyearyear}} to {{weekendingmonthmonth}}/{{weekendingdayday}}/{{weekendingyearyear}}</a>|*|<br />
gmcustomeighttemplate=                                                      
gmcustomfivetemplate=
gmlinebreaktemplate=<br />
gmcommentstemplate=<p align="right"> on {{weekday}}, {{monthword}} {{dayappend}}, {{commentauthorsmartlink}} said |*|</p><p align="justify">|*|{{commentbody}}|*|</p>
gmcustomninetemplate=                                                      
gmcalendarfullcelllinktemplate=<td align="center"><a href="{{pagelink}}">{{day}}</a></td>
gmlogarchiveslinkseparatortemplate=
gmcalendarfullcelltemplate=<td align="center">{{day}}</td>
gmmoreentrypagelinktemplate=<a href="{{pagelink}}">{{monthmonth}}/{{dayday}}/{{yearyear}}: {{entrysubject}}</a>|*|<br />
gmpopuppagetemplate=<html>|*|<head>|*|<title>{{monthmonth}}/{{dayday}}/{{year}}: {{popuptitle}}</title>|*|</head>|*||*|<body bgcolor="#000000" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0" onblur="window.close()">|*||*|<img border="0" src="{{entrieswebpath}}/{{popupfile}}" alt="{{popuptitle}}" height={{popupheight}} width={{popupwidth}}>|*||*|</body>|*|</html>
gmdategroupingfooterarchivetemplate=</div><br />
