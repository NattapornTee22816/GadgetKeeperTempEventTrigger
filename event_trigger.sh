#Update following fields as required  
API_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
THING_ID="xxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
EVENT_ID="xxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
 
URL="http://api.gadgetkeeper.com"
#DATE=`/bin/date +"%Y-%m-%dT%H:%M:%S"`
DATE=`/bin/date -u +"%Y-%m-%dT%H:%M:%S"`
#DATE="2013-06-02T21:05:04.150Z"
#echo $DATE

while true;do

	VALUE=`/home/pi/gadgetkeeper/read_temperature.sh`
    	echo "Temperature value: $VALUE"
	TMP_FILE="/tmp/tmp.txt"
	/usr/bin/curl -i -X POST -H "X-ApiKey: $API_KEY" -H "Content-Type: text/json; charset=UTF-8" -d '[{"value":'$VALUE',"at":"'$DATE'"}]' "$URL/v1/things/$THING_ID/events/$EVENT_ID/datapoints.json"  > "$TMP_FILE" 2> /dev/null
	if [ -f "$TMP_FILE" ]; then
    		RESPONSE=`cat "$TMP_FILE" | head -1`
    		IS_OK=`/bin/echo "$RESPONSE" | /bin/grep "HTTP/1.1 204"`
    	if [ "$IS_OK" != "" ]; then
       		 /bin/echo "Event update: OK"
    	else
        	/bin/echo "Event update: FAIL"
        	/bin/echo "$RESPONSE"
    	fi
	else
    	/bin/echo "Error.please try again!"
	fi
	sleep 5
done
