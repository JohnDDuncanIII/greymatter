/* Will change the size of the given element 
   ARG1: id of span to hide
   ARG2: id of span that is the controller, the hide/show link
*/
function hider( toFlip, toLink ){
    if( document.getElementById && document.getElementById(toFlip) != null ){
	var subject = document.getElementById( toFlip );
	var controller = document.getElementById( toLink ); 
	if( subject.className != "hidden" ){
	    _hideShow( "hidden", "Show", subject, controller );

	} else {
	    _hideShow( "", "Hide", subject, controller );
	}
    }
    
    function _hideShow( className, theText, sub, con ){
	sub.className=className;
	var link = document.createElement("a");
	link.href = 'javascript:hider(\''+ toFlip +'\', \''+ toLink +'\');';
	link.appendChild( document.createTextNode( theText ));
	
	while( con.hasChildNodes() ){
	    con.removeChild( con.firstChild );
	}
	con.appendChild( link );
    }
}
