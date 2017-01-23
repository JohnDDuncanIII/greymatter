//var sender = "duncanjdiii@gmail.com";
//var sender = "john@ll.mit.edu";
//var sender = "rob@research.att.com";
//var sender = "me@example.net";
//var sender = "prlw1@cam.ac.uk";

/*
var gCount = 0;
var fbox = [];
*/
//var sender = "tneller@gettysburg.edu";
var face = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAACZ0lEQVRo3u1aAW7EIAzr0+9p 97NuncrJ5zlO2gLdpIuE2DRobWIgSbcsH/sH9ng81q3dieH5fJ7DABPXu8Fvbfv58KQd/Jp5Cca5 dsr7O/AaCQU+ch+PwXncY8vksH4bPwtJlAlsrT2sAtw15REFpr1zs4Zl60tyxkH4ICSBf8eGL4t6 5REk0cYhAXyXlSIxfGOuXJqBxVXLSOD7EDxjsqsvNP8GhiXjQHPDcdHeUM+gscfOe15tBb6tFFr7 nXvlAUUCn18GX/XKWfBnSFwGrzzBclF2lURX8O1YVpp3lpFze6E3+EUdlRVzJDIZ9Q5HUu339sCQ aDTTftX+tAfcBsawZLoHOHRwXohIRGN7RK1lD1Tl48BngV735MlEhOEtWohnfoUQwwiIsPqnrdDw 5Q78GswjKfXPifH4ewFZ9ybAsFzeCIh51czvtISaZUD2ZOo1lnXO85YZBNADTj4ooSg44/lDgreI BHvBJSOKQJRaDt3AfJRWznkTnMlkiCQ01NJQ2XkoIjFcPupCc0GbqT68+iOlmyEkVNUiCg+Ksc+c yh/nq5W4n+USkJlb6G1SwV7lx5VqxEz5yFsZj0Lu1eZ1p9NUD7j6pSpgReCneYE1zZ6IsixTcZgn JVUp48srI1CpWg/LBxh8FPvz6RMlLwn4fiQi8Go/OBJm5WXhrBsJkU2Fp9LR6oOqw0ZVvEOkIm1X jlZ1D2Tg1eckZSkJ9S1AACkl/kfBOxJB5FqbzFKoll+u3LjuA0kadvAnTVyBmTGLUkB5DzCJoflq kgGePpWCitnUoJHvkqtfaO7614Jb/8XhY5l9AXpfNZbzvc2RAAAAAElFTkSuQmCC";
var xFace = "\"dS=exdec+W_UIU-3u;#}nMS}IF1SKB\";kNLiY(S}LxSXj5myL9ah32r\"z;kX6t$L-H%E|fN}p\"MDV6QL||@i`WRth?dQfm5(?Y^ABJz\\/UE|elUyeGz`C0dbwVNL=.9MJ9<3VZCnYU~QemCXs^/]{1Piu]oT^d=w$j4i-j(li3My^pt.wtRT@[eJYI(X3_1yn4L;C8m%DZsRzX'g_*CdxC1}:n2MRr),\"\"bfG}?rb{d9eoJ@W0gg?l)P_8q7l!(!\\5ixU%?H8U9el?Ov<X@D/:l!/bR_\"K-P";
/*
var faceBox = document.createElement("div");
faceBox.id = "facesBox"+gCount;
faceBox.className = "facesBox";
fbox.push(faceBox);

document.body.appendChild(fbox[gCount]);
doXFace(xFace);
doFace(face);
doPicon(sender);
doGravatar(sender);
*/

function doXFace(){
    var mfX_Cache = new Array();
    //var xFaceImg = document.getElementById("xface");
    var xFaceImg = document.createElement("img");
    xFaceImg.id="xface"+gCount;
    xFaceImg.setAttribute("class", "face xface");
    xFaceImg.title = "X-Face";

    xFace = xFace.replace(/ /g, "");
    var koComputedStyle = window.getComputedStyle(xFaceImg, null);
    if (mfX_Cache[xFace] == null) {
		// It'd be nice to do this asyncronously. Wonder how. Me no know.
		//mfX_Cache[xFace] = mfXFaceJSm.FaceURL(xFace);
		mfX_Cache[xFace] = FaceURL(xFace, koComputedStyle);
    }
    xFaceImg.setAttribute("src", mfX_Cache[xFace]);
    fbox[gCount-1].appendChild(xFaceImg);
    //return xFaceImg;
}

function doFace() {
    //var faceImage = document.getElementById("face");
    var faceImage = document.createElement("img");
    faceImage.setAttribute("class", "face");
    faceImage.id="face"+gCount;
    faceImage.title = "Face";

    face = face.replace(/(\s)+/g, "");
    faceImage.setAttribute("src", ("data:image/png;base64," + encodeURIComponent(face)));
    fbox[gCount-1].appendChild(faceImage);
    //return faceImage;
}

function doGravatar(sender) {
    //alert(sender);
    var gravURL = null;
    //var gravFace = document.getElementById("gravatar");
    var gravFace = document.createElement("img");
    gravFace.id="gravatar"+gCount;
    gravFace.setAttribute("class", "face");
    gravFace.setAttribute("style", "display:none");
    gravFace.title = "Gravatar";
    sender = sender.replace(/^.*\</, "");
    sender = sender.replace(/\>.*$/, "");
    sender = sender.toLowerCase();
    var mfCalcMD5 = calcMD5(sender);
    gravURL = "http://www.gravatar.com/avatar.php?gravatar_id=%ID%&size=%SIZE%&d=404";
    gravURL = gravURL.replace("%ID%", mfCalcMD5);
    gravURL = gravURL.replace("%SIZE%", 48);
    //alert(gravURL);
    setGravFace(gravURL, mfCalcMD5);

    function setGravFace(url, mfCalcMD5) {
	getMeta(url, function(width, height) {
	    gravFace.src = url;
	    gravFace.setAttribute("style", "display:inline");
	    //fbox[gCount-1].appendChild(gravFace);
	});
    }

    function getMeta(url, callback) {
	var img = new Image();
	img.src = url;
	img.onload = function() { callback(this.width, this.height, this.src); }
    }
    fbox[gCount-1].appendChild(gravFace);
}

function doPicon(sender) {
    //alert(sender);
    var pBox = document.createElement("div");
    pBox.id="picons"+gCount;
    pBox.className = "picons";
    if(sender=="") {
	var pImg = document.createElement("img");
	pImg.setAttribute("class", "face");
	pImg.src = "../face/picons/misc/MISC/noface/face.gif";
	pImg.title = "picon";
	count++;
	pBox.appendChild(pImg);
    } else {
	var atSign = sender.indexOf('@');
	var mfPiconDatabases = new Array("domains/", "users/", "misc/", "usenix/", "unknown/");
	var count = 0;
	// if we have a valid e-mail address..
	if (atSign != -1) {
	    var host = sender.substring(atSign + 1)
	    var user = sender.substring(0, atSign);
	    var host_pieces = host.split('.');

	    for (var i in mfPiconDatabases) {
		// clone the current URL, as we will need to use it for the next val in the array
		var path = '';
		path += "../face/picons/"; // they are stored in $PROFILEPATH$/messagefaces/picons/ by default
		path += mfPiconDatabases[i]; // append one of the six database folders
		//alert(path);
		if(mfPiconDatabases[i] == "misc/") { path += "MISC/"; } // special case MISC

		var l = host_pieces.length-1; // get number of database folders (probably six, but could theoretically change)
		var clonedLocal; // we will check to see if we have a match at EACH depth, so keep a cloned version w/o the 'unknown/face.gif' portion
		while (l >= 0) { // loop through however many pieces we have of the host
		    path += host_pieces[l]+"/"; // add that portion of the host (ex: 'edu' or 'gettysburg' or 'cs')
		    clonedLocal = path;
		    if(mfPiconDatabases[i] == "users/") { path += user+"/"; } // username for 'users' db folder (non-standard)
		    else { path += "unknown/"; }
		    path += "face.gif";
		    getMetaPicon(path, i, function(width, height, src) {
			//var pBox = document.getElementById("picons");
			var pImg = document.createElement("img");
			pImg.setAttribute("class", "face");
			pImg.src = src;
			pImg.title = "picon";
			count++;
			pBox.appendChild(pImg);
		    });
		    path = clonedLocal;
		    l--;
		}
	    }
	}
    }

    async function getMetaPicon(url, i, callback) {
	var img = new Image();
	await sleep(10); // this ensures that the async callback will return the picons in proper oreder ... bad hack
	/*if(i==mfPiconDatabases.length-1 && count==0) {
	    var path = '';
	    path+="picons/misc/MISC/noface/face.gif";
	    var pBox = document.getElementById("picons");
	    var pImg = document.createElement("img");
	    pImg.setAttribute("class", "face");
	    pImg.src = path;
	    pBox.appendChild(pImg);
	}*/
	img.onload = async function() {
	    if(url.includes("picons/unknown") && count >0) {
		return;
	    }
	    callback(this.width, this.height, this.src);
	}
	img.src = url;
    }
    function sleep(ms) { return new Promise(resolve => setTimeout(resolve, ms)); }
    fbox[gCount-1].appendChild(pBox);
}
