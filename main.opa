import stdlib.themes.bootstrap

module Test(temp, my_list) {

    function start() {

        function item(pos) {
            { _id : "{pos}", value : "{pos} - {Random.string(10)}" }
        }

        for(0, { function(i)
            void my_list.add(item(i), i);
            i+1;
        }, _ < 10)
        |> ignore

        Scheduler.timer(100, { function()
            void temp.set(Random.int(30)+10)
            pos = Random.int(10)
            my_list.change(item(pos), pos)
        })
    }
}

module Template {
    function empty_list() { "<p>Empty</p>" }
    function item(item) { "<li>{item.value}</li>" }
}

function init_client(_){

    temp = Reactive.value(0)
    my_list = Reactive.list([], Template.item, Template.empty_list)

    html_temp = <>The current temperature is {temp} C</>
    html_list = <>{my_list}</>

    html =  <div class="container">
                <div class="well"><h2>{html_temp}</h2><h3>{html_temp}</h3></div>
                <div class="row"><ul class="span4 offset2">{html_list}</ul><ul class="span4">{html_list}</ul></div>
            </div>

    #main = html
    Test(temp, my_list).start();
}

function page() {
        <div id=#main2/>
        <div id=#main onready={init_client}>
        </div>
}

Server.start(
    Server.http,
    {title:"Spark", page:page}
)
