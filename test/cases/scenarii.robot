# -------------------------------------------------------
# Copyright (c) [2021] Nadege Lemperiere
# All rights reserved
# -------------------------------------------------------
# Robotframework test suite for subnet module
# -------------------------------------------------------
# Nadège LEMPERIERE, @12 november 2021
# Latest revision: 20 november 2023
# -------------------------------------------------------


*** Settings ***
Documentation   A test case to check multiple subnets creation using module
Library         aws_iac_keywords.terraform
Library         aws_iac_keywords.keepass
Library         aws_iac_keywords.cloudtrail
Library         aws_iac_keywords.kms
Library         aws_iac_keywords.s3
Library         ../keywords/data.py
Library         OperatingSystem

*** Variables ***
${KEEPASS_DATABASE}                 ${vault_database}
${KEEPASS_KEY_ENV}                  ${vault_key_env}
${KEEPASS_PRINCIPAL_KEY_ENTRY}      /aws/aws-principal-access-key
${KEEPASS_PRINCIPAL_USER_ENTRY}     /aws/aws-principal-credentials
${KEEPASS_ACCOUNT_ENTRY}            /aws/aws-account
${REGION}                           eu-west-1

*** Test Cases ***
Prepare environment
    [Documentation]         Retrieve principal credential from database and initialize python tests keywords
    ${vault_key}            Get Environment Variable    ${KEEPASS_KEY_ENV}
    ${principal_access}     Load Keepass Database Secret            ${KEEPASS_DATABASE}     ${vault_key}  ${KEEPASS_PRINCIPAL_KEY_ENTRY}            username
    ${principal_secret}     Load Keepass Database Secret            ${KEEPASS_DATABASE}     ${vault_key}  ${KEEPASS_PRINCIPAL_KEY_ENTRY}            password
    ${principal_name}       Load Keepass Database Secret            ${KEEPASS_DATABASE}     ${vault_key}  ${KEEPASS_PRINCIPAL_USER_ENTRY}           username
    ${ACCOUNT}              Load Keepass Database Secret            ${KEEPASS_DATABASE}     ${vault_key}  ${KEEPASS_ACCOUNT_ENTRY}            password
    Initialize Terraform    ${REGION}   ${principal_access}   ${principal_secret}
    Initialize Cloudtrail   None        ${principal_access}   ${principal_secret}    ${REGION}
    Initialize KMS          None        ${principal_access}   ${principal_secret}    ${REGION}
    Initialize S3           None        ${principal_access}   ${principal_secret}    ${REGION}
    ${TF_PARAMETERS}=       Create Dictionary   account=${ACCOUNT}  service_principal=${principal_name}
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
