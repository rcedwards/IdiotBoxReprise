#!/bin/bash

source ./load_env.sh

set -x

API_ROOT="https://api.thetvdb.com/"

if [ -z "$SESSION_TOKEN" ]
then
  echo "Missing SESSION_TOKEN"
  echo "Not needed for an authenticate call but all others will need one."
  echo "Set in .env"
fi

#Store the passed in arguments
URL="$API_ROOT$1"
VERB=$2
DATA_FILE=$3
CONTENT_TYPE=$4

if [ -z "$URL" ]
then
  echo "Missing URL."
  exit
fi
if [ -z "$VERB" ]
then
  echo "Missing Verb."
  exit
fi

# Set JSON content type as default
if [ -z "$CONTENT_TYPE" ]
then
  CONTENT_TYPE="application/json"
fi

# Add HTTP body
DATA_COMMAND=""
if [ "$DATA_FILE" ]
then
  if [[ "$CONTENT_TYPE" == "multipart/form-data" ]]
  then
    DATA_COMMAND="--form"
  elif [[ "$CONTENT_TYPE" == "application/x-www-form-urlencoded" ]]
  then
    DATA_COMMAND="--data"
  else
    DATA_COMMAND="--data-binary"
  fi
fi

echo "Calling $URL"
echo "$VERB: $DATA_COMMAND $DATA_FILE"

if [ -z "$DATA_COMMAND" ]
then
  curl -v \
  -H "Content-Type: $CONTENT_TYPE" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer $SESSION_TOKEN" \
  -X "$VERB" \
  "$URL" | python -m json.tool
else
  curl -v \
  -H "Content-Type: $CONTENT_TYPE" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer $SESSION_TOKEN" \
  -X "$VERB" "$DATA_COMMAND" "$DATA_FILE" \
  "$URL" | python -m json.tool
fi
