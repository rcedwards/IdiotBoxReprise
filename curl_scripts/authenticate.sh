#!/bin/bash

source ./load_env.sh

URL="login"
VERB="POST"

if [ -z "$API_KEY" ]
then
  echo "Missing API KEY"
  exit
fi
if [ -z "$USER_NAME" ]
then
  echo "Missing User Name KEY"
fi
if [ -z "$USER_KEY" ]
then
  echo "Missing User key"
fi

# Data to get a Token for non-user routes
# DATA_FILE=$(sed "-e s/API_KEY/$API_KEY/g" << END
# {
#   "apikey": API_KEY
# }
# END
# )

# Data to get a Token for User Routes
DATA_FILE=$(sed "-e s/API_KEY/$API_KEY/g" "-e s/USER_KEY/$USER_KEY/g" "-e s/USER_NAME/$USER_NAME/g" << END
{
  "apikey": API_KEY,
  "userkey": USER_KEY,
  "username": USER_NAME
}
END
)

./base_curl.sh "$URL" "$VERB" "$DATA_FILE"
