# -------------------------------------------------------
# TECHNOGIX
# -------------------------------------------------------
# Copyright (c) [2021] Technogix.io
# All rights reserved
# -------------------------------------------------------
# Robotframework test suite for subnet module
# -------------------------------------------------------
# Nadège LEMPERIERE, @12 november 2021
# Latest revision: 12 november 2021
# -------------------------------------------------------


*** Settings ***
Documentation   A test case to check multiple subnets creation using module
Library         technogix_iac_keywords.terraform
Library         technogix_iac_keywords.keepass
Library         technogix_iac_keywords.cloudtrail
Library         technogix_iac_keywords.kms
Library         technogix_iac_keywords.s3
Library         ../keywords/data.py

*** Variables ***
${KEEPASS_DATABASE}                 ${vault_database}
${KEEPASS_KEY}                      ${vault_key}
${KEEPASS_GOD_KEY_ENTRY}            /engineering-environment/aws/aws-god-access-key
${KEEPASS_GOD_USER_ENTRY}           /engineering-environment/aws/aws-god-credentials
${KEEPASS_ACCOUNT_ENTRY}            /engineering-environment/aws/aws-account
${REGION}                           eu-west-1

*** Test Cases ***
Prepare environment
    [Documentation]         Retrieve god credential from database and initialize python tests keywords
    ${god_access}           Load Keepass Database Secret            ${KEEPASS_DATABASE}     ${KEEPASS_KEY}  ${KEEPASS_GOD_KEY_ENTRY}            username
    ${god_secret}           Load Keepass Database Secret            ${KEEPASS_DATABASE}     ${KEEPASS_KEY}  ${KEEPASS_GOD_KEY_ENTRY}            password
    ${god_name}             Load Keepass Database Secret            ${KEEPASS_DATABASE}     ${KEEPASS_KEY}  ${KEEPASS_GOD_USER_ENTRY}           username
    ${ACCOUNT}              Load Keepass Database Secret            ${KEEPASS_DATABASE}     ${KEEPASS_KEY}  ${KEEPASS_ACCOUNT_ENTRY}            password
    Initialize Terraform    ${REGION}   ${god_access}   ${god_secret}
    Initialize Cloudtrail   None        ${god_access}   ${god_secret}    ${REGION}
    Initialize KMS          None        ${god_access}   ${god_secret}    ${REGION}
    Initialize S3           None        ${god_access}   ${god_secret}    ${REGION}
    ${TF_PARAMETERS}=       Create Dictionary   account=${ACCOUNT}  service_principal=${god_name}
    Set Global Variable     ${TF_PARAMETERS}
    Set Global Variable     ${ACCOUNT}

Create Cloudtrail
    [Documentation]         Create Cloudtrail And Check That The AWS Infrastructure Match Specifications
    Launch Terraform Deployment                 ${CURDIR}/../data/standard  ${TF_PARAMETERS}
    ${states}   Load Terraform States           ${CURDIR}/../data/standard
    ${specs}    Load Standard Test Data         ${states['test']['outputs']['bucket']['value']}    ${states['test']['outputs']['loggroup']['value']}   ${states['test']['outputs']['trail']['value']}  ${ACCOUNT}     ${REGION}
    Trails Shall Exist And Match                ${specs['trail']}
    Key Shall Exist And Match                   ${specs['key']}
    Empty S3 Bucket                             ${states['test']['outputs']['bucket']['value']['name']}
    [Teardown]  Destroy Terraform Deployment    ${CURDIR}/../data/standard  ${TF_PARAMETERS}
