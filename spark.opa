private spark_resources = @static_include_directory("resources")

private config = { DynamicResource.default_config with randomize : false }

private params = {
  	expiration  : {none},
  	consumption : {unlimited},
  	visibility  : {shared}
}

private function publish(name, resource) {
  	DynamicResource.publish_extend(name, resource, params, config)
}

private uri_spark = Map.mapi(publish, spark_resources)

private function import_spark(string name) {
  	match (Map.get(name, uri_spark)){
  	case {some:url} : Resource.register_external_js(url)
  	case {none}     : void
	}
}

import_spark("resources/spark.js");

type Context.context = external

module Spark {

	function render(htmlFunc) {
		(%% Spark.render %%)(htmlFunc)
	}
	function isolate(htmlFunc) {
		(%% Spark.isolate %%)(htmlFunc)
	}
}

client module Context {

	function get() {
		(%% Context.get %%)()
	}
	function getId(context) {
		(%% Context.getId %%)(context)
	}
	function onInvalidate(context, callback) {
		(%% Context.onInvalidate %%)(context, callback)
	}
	function invalidate(context) {
		(%% Context.invalidate %%)(context)
	}
}

client module Reactive {

	function render(htmlFunc) {
		function f(){
			Xhtml.to_string(htmlFunc())
		}
		frag = Spark.render({
			function() Spark.isolate(f)
		})
		id = Xhtml.new_id()
		function replace(_) {
			ignore(Dom.put_replace(#{id}, Dom.to_selection(frag)));
		}
		<div id=#{id} onready={replace}/>
	}
}

module makeReactive(v) {

 	value = Mutable.make(v)
	ctx = Mutable.make(@unsafe_cast(void))
	is_active_ctx = Mutable.make(false)

 	client function get() {
 	  	ctx.set(Context.get())
 	  	is_active_ctx.set(true)
 	  	// todo: context.onInvalidate()
 	  	value.get()
 	}

 	client function set(n) {
 	  	value.set(n)
 	  	if(is_active_ctx.get() == true) {
 	  		Context.invalidate(ctx.get())
 	  	}
 	}

}








