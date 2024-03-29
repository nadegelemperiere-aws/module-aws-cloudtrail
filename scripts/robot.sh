#!/bin/bash
# -------------------------------------------------------
# Copyright (c) [2022] Nadege Lemperiere
# All rights reserved
# -------------------------------------------------------
# Module to deploy an aws bucket with all the secure
# components required
# Bash script to launch robotframework tests
# -------------------------------------------------------
# Nadège LEMPERIERE, @13 january 2022
# Latest revision: 20 november 2023
# -------------------------------------------------------

# Retrieve absolute path to this script
script=$(readlink -f $0)
scriptpath=`dirname $script`

# Parse arguments from flags
args=""
key=""
while getopts s:l:d:k: flag
do
    case "${flag}" in
          s) args+=" --suite ${OPTARG}";;
          l) args+=" --loglevel ${OPTARG}";;
          d) args+=" --log ${OPTARG}/log.html --report ${OPTARG}/report.html";;
          k) key=${OPTARG}
    esac
done

# Install required python packages
pip install --quiet -r $scriptpath/../requirements-test.txt

# Launch python scripts to setup terraform environment
python3 -m robot --variable vaultdatabase:$scriptpath/../../vault/cicd.kdbx \
                 --variable vault_key_env:$key                              \
                 $args                                                      \
                 $scriptpath/../test/cases