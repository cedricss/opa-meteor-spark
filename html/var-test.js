Meteor.render = function (htmlFunc) {
  return Spark.render(function () {
    return Spark.isolate(
      typeof htmlFunc === 'function' ? htmlFunc : function() {
        // non-function argument becomes a constant (non-reactive) string
        return String(htmlFunc);
      });
  });
};

Meteor.renderList = function (cursor, itemFunc, elseFunc) {
  return Spark.render(function () {
    return Spark.list(cursor, function (item) {
      return Spark.labelBranch(item._id || null, function () {
        return Spark.isolate(_.bind(itemFunc, null, item));
      });
    }, function () {
      return elseFunc ? Spark.isolate(elseFunc) : '';
    });
  });
};



var Weather = function () {
  this.temperature = "Loading...";
  this.listeners = {};
};

Weather.prototype.getTemp = function () {

  var context = Meteor.deps.Context.current;


  if (context && !this.listeners[context.id]) {
    this.listeners[context.id] = context;

    var self = this;
    context.onInvalidate(function () {
      delete self.listeners[context.id];
    });
  }

  return this.temperature;
};


Weather.prototype.setTemp = function (newTemp) {
  if (this.temperature === newTemp)
    return;

  this.temperature = newTemp;

  for (var contextId in this.listeners)
    this.listeners[contextId].invalidate();
};

var W1 = new Weather()
var W2 = new Weather()

var make_frag = function (W) {
  return function() {
    return "<h2>The current temperature is " + W.getTemp() + " C</h2>";
  }
}

/**

Opa:
- fined grain reactive refresh (magic insert)
- precompute non-reactive part (=>CPS)
- client/server
- asynch

*/

var frag1 = Meteor.render(make_frag(W1))
var frag2 = Meteor.render(make_frag(W2))

document.body.appendChild(frag1);
document.body.appendChild(frag2);

function WRandom(W){
  W.setTemp(Math.floor(Math.random()*20)+10);
}

setInterval(function(){ WRandom(W1); WRandom(W2); }, 100)
