OPA ?= opa --js-bypass-syntax jsdoc 
DEMO_PATH=../opa-reactive-demos

demo.js: $(DEMO_PATH) plugins/spark.js plugins/context.js resources/spark.js $(DEMO_PATH)/resources/css/style.css spark.opa reactive.opa $(DEMO_PATH)/demo.opa $(DEMO_PATH)/demos/*.opa
	$(OPA) plugins/spark.js plugins/context.js spark.opa reactive.opa $(DEMO_PATH)/demos/*.opa $(DEMO_PATH)/demo.opa -o demo.js

$(DEMO_PATH):
	(cd .. && git clone https://github.com/cedricss/opa-reactive-demos && cd opa-reactive-demos && git checkout origin/wip && echo "\nPlease type make run again")

meteor:
	 git clone https://github.com/meteor/meteor.git

#resources/spark.js: meteor make_spark.js spark_dependencies
#	./make_spark.js

run: demo.js
	./demo.js --js-renaming no --js-cleaning no