OPA ?= opa --js-bypass-syntax jsdoc

all: plugins/spark.js resources/spark.js spark.opa
	$(OPA) plugins/spark.js spark.opa

meteor:
	 git clone https://github.com/meteor/meteor.git

resources/spark.js: meteor
	./make_spark.js


