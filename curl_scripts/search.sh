#!/bin/bash

source ./load_env.sh

query=$1
if [ -z "$query" ]
then
  echo "Missing search query"
  exit
fi

URL="search/series?name=$query"
VERB="GET"

./base_curl.sh "$URL" "$VERB"
