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


module Spark {

	function render(htmlFunc) {
		(%% Spark.render %%)(htmlFunc)
	}

	function isolate(htmlFunc) {
		(%% Spark.isolate %%)(htmlFunc)
	}

}

module Reactive {

	module Var {

		function render(htmlFunc) {
			Spark.render({
				function() Spark.isolate(htmlFunc)
			})
		}
	}
}

getTemp = %% Spark.getTemp %%
setTemp = %% Spark.setTemp %%

client function init_client(_){
	Scheduler.timer(100, { function()
		setTemp("{Random.int(30)+10}")
	})
	frag = Reactive.Var.render({ function()
		"<h2>The current temperature is {getTemp()} C</h2>"
	})
	_ = Dom.put_inside(#main, Dom.to_selection(frag));
	void
}

function page() {
	<div id=#main onready={init_client}/>
}

Server.start(
	Server.http,
	{title:"Spark", page:page}
)








