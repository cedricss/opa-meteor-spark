// ------ Minimal Cursor --------

Cursor = function(){

}

Cursor.prototype.observe = function (callbacks) {

  this.callbacks = callbacks

  var initialContent = new Array("A", "B", "C");

  for (var i = 0; i < initialContent.length; i++){
    callbacks.added(initialContent[i], i);
  }

};

// ------ Test utilities --------

function addFrag(cursor) {
  frag = Meteor.renderList(cursor,
    function(item) {
      return "<li>"+item+"</li>"
    }
  );
  document.body.appendChild(frag);
}

function test(cursor, delta) {

  setTimeout(
    function() { cursor.callbacks.added("D", 3) },
    delta
  )

  setTimeout(
    function() { cursor.callbacks.moved("", 0, 3) },
    delta+500
  )

  setTimeout(
    function() { cursor.callbacks.changed("new C", 1) },
    delta+1000
  )

}

//function bind(f) { Meteor.bindEnvironment(f, function(e) { console.log(e.stack); } ) }

// ------ Test --------

cursor1 = new Cursor();
cursor2 = new Cursor();

addFrag(cursor1);
document.body.appendChild(document.createElement("hr"))
addFrag(cursor2);

test(cursor1, 500);
test(cursor2, 1500);
