# -------------------------------------------------------
# TECHNOGIX
# -------------------------------------------------------
# Copyright (c) [2021] Technogix.io
# All rights reserved
# -------------------------------------------------------
# Module to deploy an aws cloudtrail with all the secure
# components required
# -------------------------------------------------------
# Nadège LEMPERIERE, @12 november 2021
# Latest revision: 12 november 2021
# -------------------------------------------------------

# -------------------------------------------------------
# Configure Cloudtrail to log console activities in s3
# -------------------------------------------------------
resource "aws_cloudtrail" "trail" {

	name                            = "${var.project}-${var.name}"
    s3_bucket_name                  = var.bucket.name
	s3_key_prefix					= var.bucket.prefix
    cloud_watch_logs_group_arn      = "${var.cloudwatch.arn}:*" # CloudTrail requires the Log Stream wildcard
    cloud_watch_logs_role_arn       = var.cloudwatch.role
	include_global_service_events	= true
	is_multi_region_trail			= true
	enable_log_file_validation		= true
	kms_key_id 						= aws_kms_key.key.arn

	dynamic "event_selector" {

		for_each = var.events
		content {
			read_write_type           = "All"
			include_management_events = true

			data_resource {
				type   = event_selector.value.type
				values = [event_selector.value.value]
			}
		}
	}

    tags = {
		Name           	= "${var.project}.${var.environment}.${var.module}.cloudtrail"
		Environment     = var.environment
		Owner   		= var.email
		Project   		= var.project
		Version 		= var.git_version
		Module  		= var.module
	}
}

# -------------------------------------------------------
# Cloudtrail encryption key
# -------------------------------------------------------
resource "aws_kms_key" "key" {

	description             	= "Cloudtrail encryption key"
	key_usage					= "ENCRYPT_DECRYPT"
	customer_master_key_spec	= "SYMMETRIC_DEFAULT"
	deletion_window_in_days		= 7
	enable_key_rotation			= true
  	policy						= jsonencode({
  		Version = "2012-10-17",
  		Statement = [
			{
				Sid 			= "AllowKeyModificationToRootAndGod"
				Effect			= "Allow"
				Principal		= {
					"AWS" : [
						"arn:aws:iam::${var.account}:root",
						"arn:aws:iam::${var.account}:user/${var.service_principal}"
					]
				}
				Action 			= [ "kms:*" ],
                Resource		= "*"
       		},
			{
      			Sid 		= "AllowKeyDescriptionToCloudtrail"
      			Effect 		= "Allow"
				Principal 	= {
					"Service" : [ "cloudtrail.amazonaws.com" ]
				}
      			Action  	= [ "kms:DescribeKey"],
                Resource	= "*"
    		},
			{
      			Sid 		= "AllowEncryptionToCloudtrail"
      			Effect 		= "Allow"
				Principal 	= {
					"Service" : [ "cloudtrail.amazonaws.com" ]
				}
      			Action  	= [ "kms:GenerateDataKey*"],
                Resource	= "*"
				Condition 	= {
					StringLike = {
						"kms:EncryptionContext:aws:cloudtrail:arn" : ["arn:aws:cloudtrail:*:${var.account}:trail/*"]
					}
				}
    		},
			{
      			Sid 		= "AllowDecryptionToCloudtrail"
      			Effect 		= "Allow"
				Principal 	= {
					"Service" : [ "cloudtrail.amazonaws.com"	]
				}
      			Action  	= [ "kms:Decrypt"],
                Resource	= "*"
				Condition 	= {
					Null = {
						"kms:EncryptionContext:aws:cloudtrail:arn": "false"
					}
				}
    		}
  		]
	})

	tags = {
		Name           	= "${var.project}.${var.environment}.${var.module}.cloudtrail"
		Environment     = var.environment
		Owner   		= var.email
		Project   		= var.project
		Version 		= var.git_version
		Module  		= var.module
	}
}
