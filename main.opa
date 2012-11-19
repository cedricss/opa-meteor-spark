import stdlib.themes.bootstrap
//import stdlib.meteor.spark

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

client temp = Reactive.make(0)
client my_list = Reactive.List.make(list({string _id, string value}) [], Template.item, Template.empty_list)

function page() {

    html_temp = <>The current temperature is { render(temp) } C</>
    html_list = <>{ render_list(my_list) }</>;

    <div class="navbar navbar-fixed-top">
      <div class=navbar-inner>
        <div class=container>
          <a class=brand href="./index.html">Opa Meteor Spark</>
          <button class="btn" onclick={ function(_) Test(temp).start() }><i class="icon-play"></i></button>
        </div>
      </div>
    </div>
    <div class="container"><br/><br/>
        <div class="well"><h2>{html_temp}</h2><h3>{html_temp}</h3></div>
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
