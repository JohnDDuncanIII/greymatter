function init(){
    var cookieStrings = ["pathConfigHidden|pathConfigHider", "indexArchiveHidden|indexArchiveHider",
			 "emailOptionHidden|emailOptionHider", "emoticonOptionHidden|emoticonOptionHider",
			 "karmaCommentHidden|karmaCommentHider","dateTimeHidden|dateTimeHider",
			 "fileUploadHidden|fileUploadHider","censorOptionHidden|censorOptionHider",
			 "connectFilesHidden|connectFilesHider", "miscOptionHidden|miscOptionHider"];
    for( var i=0;i< cookieStrings.length;i++ ){
	var cookieParts = cookieStrings[i].split("|");
	// should be calling a function to hide, not the toggle function
	hider( cookieParts[0], cookieParts[1] );
    }
}

window.onload = init;
