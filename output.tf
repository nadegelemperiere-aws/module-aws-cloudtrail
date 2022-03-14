# -------------------------------------------------------
# TECHNOGIX
# -------------------------------------------------------
# Copyright (c) [2021] Technogix.io
# All rights reserved
# -------------------------------------------------------
# Module to deploy an aws subnet with all the secure
# components required
# -------------------------------------------------------
# Nadège LEMPERIERE, @12 november 2021
# Latest revision: 12 november 2021
# -------------------------------------------------------


output "arn" {
    value = aws_cloudtrail.trail.arn
}

output "id" {
    value = aws_cloudtrail.trail.id
}

output "key" {
    value = aws_kms_key.key.arn
}