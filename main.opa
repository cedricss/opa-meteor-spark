function init_client(_){

	temp = makeReactive(0)

	Scheduler.timer(1000, { function()
		temp.set(Random.int(30)+10)
	})

	html =
		Reactive.render({ function()
		<h2>The current temperature is {temp.get()} C</h2>
		})

	#main = html
}

function page() {
		<div id=#main onready={init_client}>
		</div>
}

Server.start(
	Server.http,
	{title:"Spark", page:page}
)
