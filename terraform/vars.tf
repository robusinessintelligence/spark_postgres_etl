###################################################################################################
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ATTENTION !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# Any changes made to this file may cause irreparable errors to the infrastructure created
# by Terraform. Only make changes if you are CERTAIN of what you are doing. Test changes
# in the dev environment whenever you HAVE to make them.
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

# variable "project_hash" {
#   type        = string
#   description = "Hash of the project name"
# }

# variable "pipeline_project" {
#   type        = string
#   description = "Google Cloud project identifier for the pipeline"
# }

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

# variable "subnet" {
#   type        = string
#   description = "Project subnetwork"
# }

# variable "service_account" {
#   type        = string
#   description = "Service account being used"
# }

# variable "testing" {
#   type        = bool
#   description = "Whether this execution is for a test"
#   default     = false
# }

# variable "vpc" {
#   type        = string
#   description = "VPC used by the project's Vertex AI"
# }

# variable "git_repository" {
#   type        = string
#   description = "GitLab repository for the solution"
# }

# variable "composer_dags_team" {
#   type        = string
#   description = "Team responsible for Composer DAGs"
# }

# variable "composer_bucket" {
#   type        = string
#   description = "GCS Bucket for Composer DAGs"
# }