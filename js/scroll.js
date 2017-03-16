var img = document.createElement("img");
img.id = "settings";
img.className = "settings";
document.getElementById("frame").appendChild(img);
var overlay = document.createElement("div");
overlay.id = "overlay";

var popupBox = document.createElement("div");
popupBox.style = "border: 1px solid; padding: 1em; background-color: aliceblue; max-width: 24em; position: fixed; top: 50px; left: 50%; transform: translateX(-50%);";
var br = document.createElement('br');
var jsScroll = document.createElement('input');
jsScroll.type = "checkbox";
jsScroll.id = "jsScroll";
var label = document.createElement('label')
label.htmlFor = "jsScroll";
label.appendChild(document.createTextNode('Show javascript scrollbar'));
var span = document.createElement("span");
span.style = "float: left";
popupBox.appendChild(jsScroll);
popupBox.appendChild(label);
label.appendChild(span);
popupBox.appendChild(br);

var br = document.createElement('br');
var jsSidebar = document.createElement('input');
jsSidebar.type = "checkbox";
jsSidebar.id = "jsSidebar";
var label = document.createElement('label')
label.htmlFor = "jsSidebar";
label.appendChild(document.createTextNode('Show sidebar'));
var span = document.createElement("span");
span.style = "float: left";
popupBox.appendChild(jsSidebar);
popupBox.appendChild(label);
label.appendChild(span);
popupBox.appendChild(br);

var br = document.createElement('br');
var jsHeader = document.createElement('input');
jsHeader.type = "checkbox";
jsHeader.id = "jsHeader";
var label = document.createElement('label')
label.htmlFor = "jsHeader";
label.appendChild(document.createTextNode('Show header'));
var span = document.createElement("span");
span.style = "float: left";
popupBox.appendChild(jsHeader);
popupBox.appendChild(label);
label.appendChild(span);
popupBox.appendChild(br);
var comments = document.getElementById("comments");

if(comments){
    var jsComments = document.createElement('input');
    jsComments.type = "checkbox";
    jsComments.id = "jsComments";
    var label = document.createElement('label')
    label.htmlFor = "jsComments";
    label.appendChild(document.createTextNode('Show comments'));
    var span = document.createElement("span");
    span.style = "float: left";
    popupBox.appendChild(jsComments);
    popupBox.appendChild(label);
    label.appendChild(span);
    jsComments.checked = (localStorage.getItem('comments') == 'true');
    jsComments.onclick = function () {
	if(jsComments.checked) {
	    localStorage.setItem('comments', true);
	    comments.style.display = "block";
	}
	else {
	    localStorage.setItem('comments', false);
	    comments.style.display = "none";
	}
    }
    if(!jsComments.checked) {
	comments.style.display = "none";
    }
}

jsSidebar.checked = (localStorage.getItem('sidebar') == 'true');
jsScroll.checked = (localStorage.getItem('scrollbar') == 'true');
jsHeader.checked = (localStorage.getItem('header') == 'true');
var distToTop = 0;

var sidebar = document.getElementById("contentsidebar");
var sidebarDisplay = sidebar.style.display;
if(!jsSidebar.checked) {
    sidebar.style.display = "none";
}

var header = document.getElementById("header");
var headerDisplay = header.style.display;
if(!jsHeader.checked) {
    header.style.display = "none";
}

jsSidebar.onclick = function () {
    if(jsSidebar.checked) {
	localStorage.setItem('sidebar', true);
	sidebar.style.display = sidebarDisplay;
    }
    else {
	localStorage.setItem('sidebar', false);
	sidebar.style.display = "none";
    }
}


jsHeader.onclick = function () {
    if(jsHeader.checked) {
	localStorage.setItem('header', true);
	header.style.display = headerDisplay;
    }
    else {
	localStorage.setItem('header', false);
	header.style.display = "none";
    }
    calcDistToTop();
}

jsScroll.onclick = function () {
    if(jsScroll.checked) {
	var scrollEle = document.getElementById("scrollbar");
	if(scrollEle) { scrollEle.style.display = "block"; }
	else { createScrollbar(); }
	localStorage.setItem('scrollbar', true);
    }
    else {
	var scrollEle = document.getElementById("scrollbar");
	if(scrollEle) { scrollEle.style.display = "none"; }
	localStorage.setItem('scrollbar', false);
    }
}

var isDimmed = false;
img.onclick = function() {
    if(isDimmed) {
	document.documentElement.removeChild(overlay);
	document.documentElement.removeChild(popupBox);
    }
    else {
	document.documentElement.appendChild(overlay);
	document.documentElement.appendChild(popupBox);
    }
    isDimmed = !isDimmed;
}
overlay.onclick =  function() {
    if(isDimmed) {
	document.documentElement.removeChild(overlay);
	document.documentElement.removeChild(popupBox);
    }
    else {
	document.documentElement.appendChild(overlay);
	document.documentElement.appendChild(popupBox);
    }
    isDimmed = !isDimmed;
}

if(jsScroll.checked) {
    createScrollbar();
}


function createScrollbar () {
    var post = document.getElementsByClassName("post");
    var postHeight = 0;
    for (var i=0; i<post.length; i++) { postHeight += post[i].offsetHeight; }
    var scrollEle = document.createElement("div");
    scrollEle.style="height: 3px; background-color: blue; position: fixed; width: 0%; z-index: 1;";
    scrollEle.id="scrollbar";
    //div.style+="-webkit-transition: width .1s linear; -moz-transition: width .1s linear; -o-transition: width .1s linear; transition: width .1s linear;"
    document.documentElement.insertBefore(scrollEle, document.body);
    calcDistToTop();
    document.body.onscroll = function() {
	var startNum = document.documentElement.scrollTop - distToTop;
	var numbers = [startNum, postHeight], ratio = Math.max.apply(Math, numbers) / 100, l = numbers.length, i;
	for (i = 0; i < l; i++) { numbers[i] = Math.round(numbers[i] / ratio); }
	if ((window.innerHeight + window.scrollY) >= document.body.offsetHeight) { scrollEle.style.width="100%"; }
	else if(numbers[0] > 0) { scrollEle.style.width=numbers[0]+"%";}
	else { scrollEle.style.width="0%"; }
    }
}

function calcDistToTop() {
    distToTop = 0;
    var postBegin = document.getElementById("contentcenter");
    while (postBegin!=document.documentElement) {
    if(postBegin.style.display != "none") {
        distToTop += postBegin.offsetTop;
    }
    postBegin = postBegin.parentNode;
    }
}