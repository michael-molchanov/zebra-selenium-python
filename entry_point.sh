#!/bin/bash

source /opt/bin/functions.sh

EXIT_CODE=0
export GEOMETRY="$SCREEN_WIDTH""x""$SCREEN_HEIGHT""x""$SCREEN_DEPTH"

function shutdown {
  kill -s SIGTERM $NODE_PID
  sleep 10
}

if [ ! -z "$SE_OPTS" ]; then
  echo "appending selenium options: ${SE_OPTS}"
fi

SERVERNUM=$(get_server_num)

rm -f /tmp/.X*lock

xvfb-run -n $SERVERNUM --server-args="-screen 0 $GEOMETRY -ac +extension RANDR +extension DOUBLE-BUFFER +extension GLX +extension MIT-SHM" \
  java ${JAVA_OPTS} -jar /opt/selenium/selenium-server-standalone.jar \
  ${SE_OPTS} &
NODE_PID=$!

trap shutdown SIGTERM SIGINT

sleep 10

SCRIPT="$1"
echo "SCRIPT => $SCRIPT"
if [ -f "$SCRIPT" ]
then
  exec "$SCRIPT"
fi
EXIT_CODE=$?

shutdown

exit $EXIT_CODE
