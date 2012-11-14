function init_client(_){

	temp = makeReactive(0)

	function item(pos) {
		{ _id : "{pos}", value : "{pos} - {Random.string(10)}" }
	}

	cursor = MakeCursor()

	reactive_list({string _id, string value}) my_list = {
		cursor: { observe : cursor.observe },
		htmlFunc : function(item) {	"<li>{item.value}</li>"	},
		emptyFunc : function() { "<p>Empty</p>" }
	}

	Scheduler.timer(100, { function()
		temp.set(Random.int(30)+10)

		pos = Random.int(8)
		void
		cursor.changed(item(pos), pos)
	})


	html_temp =	<>The current temperature is {temp} C</>
	html_list = <>{my_list}</>
	html = <ul>{html_list}</ul><ul>{html_list}</ul>
		   <h1>{html_temp}</h1><h2>{html_temp}</h2>

	#main = html

	for(0, { function(i)
		cursor.added(item(i), i);
		i+1;
	}, { function(i) i < 10 })
	|> ignore

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

