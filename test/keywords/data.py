# -------------------------------------------------------
# Copyright (c) [2021] Nadege Lemperiere
# All rights reserved
# -------------------------------------------------------
# Keywords to create data for module test
# -------------------------------------------------------
# Nadège LEMPERIERE, @13 november 2021
# Latest revision: 13 november 2021
# -------------------------------------------------------

# System includes
from json import load, dumps

# Robotframework includes
from robot.libraries.BuiltIn import BuiltIn, _Misc
from robot.api import logger as logger
from robot.api.deco import keyword
ROBOT = False

# ip address manipulation
from ipaddress import IPv4Network

@keyword('Load Standard Test Data')
def load_standard_test_data(bucket, loggroup, trail, account, region) :

    result = {}
    result['trail'] = []
    result['key'] = []

    result['trail'].append({})
    result['trail'][0]['name'] = 'trail'
    result['trail'][0]['data'] = {}

    result['trail'][0]['data']['Name']                          = 'test-test'
    result['trail'][0]['data']['S3BucketName']                  = bucket['name']
    result['trail'][0]['data']['S3KeyPrefix']                   = 'global'
    result['trail'][0]['data']['IncludeGlobalServiceEvents']    = True
    result['trail'][0]['data']['HomeRegion']                    = region
    result['trail'][0]['data']['TrailARN']                      = trail['arn']
    result['trail'][0]['data']['LogFileValidationEnabled']      = True
    result['trail'][0]['data']['CloudWatchLogsLogGroupArn']     = loggroup['arn'] + ':*'
    result['trail'][0]['data']['CloudWatchLogsRoleArn']         = loggroup['role']
    result['trail'][0]['data']['KmsKeyId']                      = trail['key']
    result['trail'][0]['data']['Tags']                          = []
    result['trail'][0]['data']['Tags'].append({'Key'        : 'Version'             , 'Value' : 'test'})
    result['trail'][0]['data']['Tags'].append({'Key'        : 'Project'             , 'Value' : 'test'})
    result['trail'][0]['data']['Tags'].append({'Key'        : 'Module'              , 'Value' : 'test'})
    result['trail'][0]['data']['Tags'].append({'Key'        : 'Environment'         , 'Value' : 'test'})
    result['trail'][0]['data']['Tags'].append({'Key'        : 'Owner'               , 'Value' : 'moi.moi@moi.fr'})
    result['trail'][0]['data']['Tags'].append({'Key'        : 'Name'                , 'Value' : 'test.test.test.cloudtrail'})

    result['key'].append({})
    result['key'][0]['name'] = 'key'
    result['key'][0]['data'] = {}
    result['key'][0]['data']['KeyId']                   = trail['key'].split('/')[1]
    result['key'][0]['data']['Arn']                     = trail['key']
    result['key'][0]['data']['Enabled']                 = True
    result['key'][0]['data']['KeyUsage']                = 'ENCRYPT_DECRYPT'
    result['key'][0]['data']['KeyState']                = 'Enabled'
    result['key'][0]['data']['Origin']                  = 'AWS_KMS'
    result['key'][0]['data']['CustomerMasterKeySpec']   = 'SYMMETRIC_DEFAULT'
    result['key'][0]['data']['AWSAccountId']            = account
    result['key'][0]['data']['Policy']                  = {"Version": "2012-10-17", "Statement": [{"Sid": "AllowKeyModificationToRootAndGod", "Effect": "Allow", "Principal": {"AWS": ["arn:aws:iam::833168553325:user/principal", "arn:aws:iam::833168553325:root"]}, "Action": "kms:*", "Resource": "*"}, {"Sid": "AllowKeyDescriptionToCloudtrail", "Effect": "Allow", "Principal": {"Service": "cloudtrail.amazonaws.com"}, "Action": "kms:DescribeKey", "Resource": "*"}, {"Sid": "AllowEncryptionToCloudtrail", "Effect": "Allow", "Principal": {"Service": "cloudtrail.amazonaws.com"}, "Action": "kms:GenerateDataKey*", "Resource": "*", "Condition": {"StringLike": {"kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:833168553325:trail/*"}}}, {"Sid": "AllowDecryptionToCloudtrail", "Effect": "Allow", "Principal": {"Service": "cloudtrail.amazonaws.com"}, "Action": "kms:Decrypt", "Resource": "*", "Condition": {"Null": {"kms:EncryptionContext:aws:cloudtrail:arn": "false"}}}]}
    result['key'][0]['data']['Tags']                    = []
    result['key'][0]['data']['Tags'].append({'TagKey'        : 'Version'             , 'TagValue' : 'test'})
    result['key'][0]['data']['Tags'].append({'TagKey'        : 'Project'             , 'TagValue' : 'test'})
    result['key'][0]['data']['Tags'].append({'TagKey'        : 'Module'              , 'TagValue' : 'test'})
    result['key'][0]['data']['Tags'].append({'TagKey'        : 'Environment'         , 'TagValue' : 'test'})
    result['key'][0]['data']['Tags'].append({'TagKey'        : 'Owner'               , 'TagValue' : 'moi.moi@moi.fr'})
    result['key'][0]['data']['Tags'].append({'TagKey'        : 'Name'                , 'TagValue' : 'test.test.test.cloudtrail'})

    logger.debug(dumps(result))

    return result
