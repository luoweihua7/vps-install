#!/bin/sh

# get url_list
tracker_url='https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt'
ARIA2_TOKEN="__ARIA2_TOKEN__"

if [ $TRACKER_URL"x" != "x" ]
then
    tracker_url=$TRACKER_URL
fi

list=$(curl -s $tracker_url)
url_list=$(echo $list | sed 's/[ ][ ]*/,/g')

# pack json
#uuid=$(cat /proc/sys/kernel/random/uuid)
uuid=$(od -x /dev/urandom | head -1 | awk '{OFS="-"; print $2$3,$4,$5,$6,$7$8$9}')
json='{
    "jsonrpc": "2.0",
    "method": "aria2.changeGlobalOption",
    "id": "'$uuid'",
    "params": [
        "token:'$ARIA2_TOKEN'",
        {
            "bt-tracker": "'$url_list'"
        }
    ]
}'


# post json
curl -H "Accept: application/json" \
    -H "Content-type: application/json" \
    -X POST \
    -d "$json" \
    -s http://localhost:6800/jsonrpc

