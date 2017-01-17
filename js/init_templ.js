function init(){
	var cookieStrings = ["mainIndexTempHidden|mainIndexTempHider", "archiveTempHidden|archiveTempHider",
		"entryTempHidden|entryTempHider", "karmaCommentTempHidden|karmaCommentTempHider",
		"headerFooterTempHidden|headerFooterTempHider","miscTempHidden|miscTempHider"];
	for( var i=0;i< cookieStrings.length;i++ ){
		var cookieParts = cookieStrings[i].split("|");
		// should be calling a function to hide, not the toggle function
		hider( cookieParts[0], cookieParts[1] );
	}
}

window.onload = init;
