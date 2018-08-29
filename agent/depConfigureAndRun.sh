#!/bin/bash

echo Starting $(pwd)/depConfigureAndRun.sh

trap '{ pid=$(pgrep Agent.Listener); kill -2 $pid; while kill -0 $pid 2> /dev/null; do sleep 1; done; echo "Agent stopped."; exit 0; }' SIGTERM
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


echo Starting configuration for $(hostname) ...  in dir $DIR
. $DIR/depConfigureAgent.sh
echo Configuration done. Starting run for $(hostname) ...  in dir $DIR
. $DIR/depRunAgent.sh

