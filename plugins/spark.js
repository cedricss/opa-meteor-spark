/** @externType dom_element */
/** @externType xhtml */
/** @externType Context.context */
/** @opaType Cursor.t('a) */


/**
 *  @register { ( -> string ) -> dom_element }
 */
function render(htmlFunc) {
	return Spark.render(htmlFunc);
}

/**
 * @register { ( -> string ) -> string }
 */
function isolate(htmlFunc) {
	return Spark.isolate(htmlFunc);
}

/**
 * @register { string, ( -> string) -> string }
 */
function labelBranch(id, htmlFunc) {
  return Spark.labelBranch(id, htmlFunc);
}

/**
 * @register { Cursor.t('a), ('a -> string), ( -> string) -> string }
 */
function list(cursor, itemFunc, elseFunc) {
  return Spark.list(cursor, itemFunc, elseFunc); 
}

/* 
  Just some tests:
*/


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

W = new Weather()

/**
 * @register { (->string) }
 */
function getTemp() {
	return W.getTemp();
}

/**
 * @register { (string->void) }
 */
function setTemp(v) {
	W.setTemp(v);
}