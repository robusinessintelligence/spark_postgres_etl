###################################################################################################
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ATTENTION !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# Any changes made to this file may cause irreparable errors to the infrastructure created
###################################################################################################

locals {
  labels = {
    "solution" = var.solution
    "branch"   = var.branch
  }
  solution_code = split("-", var.solution)[0]
  is_prod       = var.env == "prod"
  is_dev        = var.env != "prod"
  suffix        = var.env == "prod" ? "" : "-${lower(var.branch)}"
}

variable "env" {
  type        = string
  description = "Environment of the code"
}

variable "data_project" {
  type        = string
  description = "Google Cloud project identifier for the data"
}

variable "service_account_email" {
    type        = string
    description = "email for service account"
}

variable "region" {
  type        = string
  description = "Region for the project resources"
}

variable "branch" {
  type        = string
  description = "Code branch. Used to create the code structure to be used"
}

variable "solution" {
  type        = string
  description = "Project solution name"
}
