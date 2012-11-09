function item(pos) {
	{ _id : "{pos}", value : "{pos} - {Random.string(10)}" }
}

reactive_list({string _id, string value}) my_list = {
	~cursor,
	htmlFunc : function(item) {	"<li>{item.value}</li>"	},
	emptyFunc : function() { "<p>Empty</p>" }
}

function init_client(_){

	temp = makeReactive(0)

	Scheduler.timer(1000, { function()
		temp.set(Random.int(30)+10)
		//pos = Random.int(8)
		//Cursor.getCallback().changed(item(pos), pos)
	})


	html =	<h2>The current temperature is {temp} C</h2>
	        //WIP: <ul>{my_list}</ul>

	#main = html
/**
	html =
		Reactive.renderList(cursor, { function(item)
			"<li>{item.value}</li>"
		}, { function() "<p>Empty</p>" })

	for(0, { function(i)
		Cursor.getCallback().added(item(i), i);
		i+1;
	}, { function(i) i < 10 });


	#main = html
*/
	void
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

for(0, { function(i)
	//Cursor.getCallback().added(item(i), i);
	i+1;
}, { function(i) i < 10 })
|> ignore