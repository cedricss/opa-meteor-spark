import stdlib.themes.bootstrap
import stdlib.meteor.spark

server initialized = Mutable.make(false)
client module Test(temp) {

    private function item(pos) { { _id : "{pos}", value : "{pos} - {Random.base64(10)}" } }

    function init() {
        //if(initialized.get() == false) {
           for(0, { function(i)
            void my_list.add(item(i), i);
            i+1;  }, _ < 10) |> ignore
            initialized.set(true);
        //}
    }

    function start() {
        function test() {
            void temp.set(Random.int(30)+10)
            pos = Random.int(10)
            my_list.change(item(pos), pos)

        }
        init();
        test();
        Scheduler.timer(500, test)
    }
}

module Template {

    function empty_list() { <p>Empty</p> }
    function item(item) { <tr><td class="highlight">{item.value}</td></tr> }
}

// Forcing the client to have the type, to solve the inappropriate
// OpaTsc_server_get_stdlib.core.rpc.core",...[\"Reactive.value\"]]"}
client function cheat() {
    jlog("{@typeval(Reactive.value(temperature))}")
}
server joke = <div onready={ function(_) cheat() }/>

type temperature = int

// for the doc: case with alpha

@xmlizer(temperature) function my_int_to_xml(v) {
    // TODO: patch Opa to be able to write raw style="" (font tag not supported)
    //<font color="rgb({v*2},{v*3},{v*4});">{v} C</font>
    <span class="highlight"> {v} C</span>
}

temp = Reactive.make(temperature 0)
temp.set(1);

client my_list = Reactive.List.make(list({string _id, string value}) [], Template.item, Template.empty_list)

function page() {

    temp.set(2);

    html_temp = <>The current temperature is { temp }</>
    html_list = <></>;

    <div class="navbar navbar-fixed-top">
      <div class=navbar-inner>
        <div class=container>
          <a class=brand href="./index.html">Opa Meteor Spark</>
          <button class="btn" onclick={ function(_) Test(temp).start() }><i class="icon-play"></i></button>
        </div>
      </div>
    </div>
    <div class="container"><br/><br/>
        <div class="well"><h2>{html_temp}</h2><h3></h3></div>
        <div class="row">
            <div class="span4 offset2"><table class="table">{html_list}</table></div>
            <div class="span4"><table class="table">{html_list}</table></div>
        </div>
    </div>
}

Server.start(
    Server.http,
    [
        {register : { css : [ "/resources/css/style.css" ]} },
        {resources:@static_resource_directory("resources") },
        {title:"Spark", page:page}
    ]
)
