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
/**	function labelBranch(id, htmlFunc) {
		(%% Spark.labelBranch %%)(id, htmlFunc)
	}
	function list(cursor, itemFunc, elseFunc) {
		(%% Spark.list %%)(cursor, itemFunc, elseFunc)
	}
*/
	labelBranch = %% Spark.labelBranch %%
	list = %% Spark.list %%
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

	empty = %% Context.empty %%
}

client module Reactive {

	private function placeholder(frag) {
		id = Xhtml.new_id()
		function replace(_) {
			ignore(Dom.put_replace(#{id}, Dom.to_selection(frag)));
		}
		<div id=#{id} onready={replace}/>
	}

	function render(htmlFunc) {
		function f(){
			Xhtml.to_string(htmlFunc())
		}
		Spark.render({
			function() Spark.isolate(f)
		})
		|> placeholder
	}

	function renderList(cursor, itemFunc, elseFunc) {
  		Spark.render(function () {
    		Spark.list(cursor, function (item) {
      			Spark.labelBranch(item._id,
      				function () {
        				Spark.isolate({ function() jlog(item.value); itemFunc(item) });
	      			})
    			}, elseFunc
		    )
  		})
  		|> placeholder
	}

}

type reactive('a) = {
	(->'a) get,
	('a->{}) set
}

type reactive_list('a) = {
	Cursor.t('a) cursor,
	('a->string) htmlFunc,
	(->string) emptyFunc
}

client ctx = Mutable.make(Context.empty)

('a->reactive('a)) module makeReactive(v) {

	private value = Mutable.make(v)

 	client function get() {
 	  	ctx.set(Context.get())
 	  	// todo: context.onInvalidate()
 	  	value.get()
 	}

 	client function set(n) {
 	  	value.set(n)
 	  	Context.invalidate(ctx.get())
 	}

}

// TODO: xhtml instead of string
(Cursor.t('a), ('a->string), (->string) -> reactive_list('a)) module makeReactiveList(c, f, e) {
	cursor = c
	htmlFunc = f
	emptyFunc = e
}

@xmlizer(reactive('a)) function reactive_to_xml(alpha_to_xml, r) {
	Reactive.render({ function() alpha_to_xml(r.get()) })
}

@xmlizer(reactive_list('a)) function reactive_list_to_xml(_alpha_to_xml, r) {
	Reactive.renderList(r.cursor, r.htmlFunc, r.emptyFunc)
}

