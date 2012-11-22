set -e
# git clone https://github.com/meteor/meteor.git
PCK_DIR="meteor/packages"
COMPILER=/usr/local/bin/compiler.jar
DEST="resources/spark.js"

rm $DEST || true
cat spark_header > $DEST
echo "var Meteor = {};" >> $DEST
cat spark_dependencies | while read LINE
do
       echo $LINE
       cat "$PCK_DIR/$LINE" >> $DEST
done
#echo "Compiling..."
#java -jar $COMPILER --js $DEST --js_output_file $DEST_MINI
