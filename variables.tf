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
# Contact e-mail for this deployment
# -------------------------------------------------------
variable "email" {
	type 	= string
}

# -------------------------------------------------------
# Environment for this deployment (prod, preprod, ...)
# -------------------------------------------------------
variable "environment" {
	type 	= string
}

# -------------------------------------------------------
# Topic context for this deployment
# -------------------------------------------------------
variable "project" {
	type    = string
}
variable "module" {
	type 	= string
}
variable "name" {
	type 	= string
}

# -------------------------------------------------------
# Solution version
# -------------------------------------------------------
variable "git_version" {
	type    = string
	default = "unmanaged"
}

# -------------------------------------------------------
# Allowed users for encrypt / decrypt
# -------------------------------------------------------
variable "service_principal" {
	type = string
}
variable "account" {
	type = string
}

#  -------------------------------------------------------
# Bucket description
# --------------------------------------------------------
variable "bucket" {
	type = object({
		name 	= string
		prefix	= string
	})
}

#  -------------------------------------------------------
# Loggroup configuration for cloudtrail
# --------------------------------------------------------
variable "cloudwatch" {
	type = object({
		arn 	= string
		role	= string
	})
}

#  -------------------------------------------------------
# Events to collect with cloudtrail
# --------------------------------------------------------
variable "events" {
	type = list(object({
		type 	= string,
		value	= string
	}))
}
