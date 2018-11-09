#!/bin/bash

source ./load_env.sh

show_id=$1
if [ -z "$show_id" ]
then
  echo "Missing search show id"
  exit
fi

page=$2
if [ "$page" ]
then
    URL="series/$show_id/episodes?page=$page"
else
    URL="series/$show_id/episodes"
fi

VERB="GET"

./base_curl.sh "$URL" "$VERB"
