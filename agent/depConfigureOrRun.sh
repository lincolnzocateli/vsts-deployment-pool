#!/bin/bash

echo Starting $(pwd)/depConfigureOrRun.sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
work_dir="$DIR/_works/$(hostname)"

if ! [ -d $work_dir ]; then
  echo Executing agent config...
  . $DIR/depConfigureAndRun.sh
else
  echo Executando background agent...
  . $DIR/runAgent.sh
fi