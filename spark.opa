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

type Context.t = external

module Spark {

	render 			= %% Spark.render %%
	function render_f(htmlFunc) {
		function f() { render(htmlFunc) }
		f
	}
	isolate 		= %% Spark.isolate %%
	labelBranch 	= %% Spark.labelBranch %%
	list 			= %% Spark.list %%
	function replace_f(position, item_f){
		Dom.to_selection(
			%% Spark.replace_f %%(Dom.of_selection(position), { function() item_f() } )
		)
	}
}

client module Context {

	getId 			= %% Context.getId %%
	get 			= %% Context.get %%
	onInvalidate 	= %% Context.onInvalidate %%
	invalidate 		= %% Context.invalidate %%
	empty 			= %% Context.empty %%
}

client module Reactive {

  	@both_implem unique_class = String.fresh(200)

	private function placeholder((->dom_element) frag) {
		class = unique_class()
		function replace(_) {
			ignore(Spark.replace_f(Dom.select_class(class), frag));
		}
		<div class={[class]} onready={replace}/>
	}

	function render(htmlFunc) {
		function f(){
			Xhtml.to_string(htmlFunc())
		}
		Spark.render_f({
			function() Spark.isolate(f)
		})
		|> placeholder
	}

	function renderList(cursor, itemFunc, elseFunc) {
  		Spark.render_f(function () {
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

client ctx_map = Mutable.make(intmap(Context.t) IntMap.empty)

('a->reactive('a)) module makeReactive(v) {

	private value = Mutable.make(v)

 	client function get() {
 		ctx = Context.get()
 	  	ctx_map.set(Map.add(Context.getId(ctx), ctx, ctx_map.get()))
 	  	// todo: context.onInvalidate()
 	  	value.get()
 	}

 	client function set(n) {
 	  	value.set(n)
 	  	Map.iter({ function(_, value) Context.invalidate(value)}, ctx_map.get())
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

