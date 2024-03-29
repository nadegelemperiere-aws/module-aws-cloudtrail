#!/bin/bash
# -------------------------------------------------------
# Copyright (c) [2022] Nadege Lemperiere
# All rights reserved
# -------------------------------------------------------
# Module to deploy an aws permission set with all the secure
# components required
# Bash script to launch module linting
# -------------------------------------------------------
# Nadège LEMPERIERE, @13 january 2022
# Latest revision: 20 november 2023
# -------------------------------------------------------

# Retrieve absolute path to this script
script=$(readlink -f $0)
scriptpath=`dirname $script`

# Launching tflint
cd ${scriptpath}/../
tflint --init
tflint --format sarif
cd ${scriptpath}