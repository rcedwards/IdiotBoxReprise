#!/bin/bash

source ./load_env.sh

set -x

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

curl \
 --header 'Content-Type: application/json' \
 --header 'Accept: application/json' \
 -X POST \
 --data-binary "$DATA_FILE" \
 'https://api.thetvdb.com/login'
