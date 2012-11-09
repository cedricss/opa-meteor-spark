OPA ?= opa --js-bypass-syntax jsdoc 

main.js: plugins/spark.js plugins/context.js resources/spark.js spark.opa cursor.opa main.opa
	$(OPA) plugins/spark.js plugins/context.js spark.opa cursor.opa main.opa

meteor:
	 git clone https://github.com/meteor/meteor.git

resources/spark.js: meteor make_spark.js spark_dependencies
	./make_spark.js

run: main.js
	./main.js --js-renaming no