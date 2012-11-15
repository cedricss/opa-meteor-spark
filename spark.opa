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

    render          = %% Spark.render %%
    function render_f(htmlFunc) {
        function f() { render(htmlFunc) }
        f
    }
    isolate         = %% Spark.isolate %%
    labelBranch     = %% Spark.labelBranch %%
    list            = %% Spark.list %%
    // todo: move to stdlib
    function replace_f(position, item_f){
        Dom.to_selection(
            %% Spark.replace_f %%(Dom.of_selection(position), { function() item_f() } )
        )
    }
}

client module Context {

    getId           = %% Context.getId %%
    get             = %% Context.get %%
    onInvalidate    = %% Context.onInvalidate %%
    invalidate      = %% Context.invalidate %%
    empty           = %% Context.empty %%
}




