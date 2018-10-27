#!/bin/bash

# Unload previous values
unset $(egrep '^[^# ]\S+=\S+' .env | sed -E 's/(.*)=.*/\1/' | xargs -0)

# Load your values
export $(egrep '^[^# ]\S+=\S+' .env | xargs -0)
