####################################################################################################
# Bucket tem files dataproc
####################################################################################################

resource "google_storage_bucket" "tmp-dataproc" {
  name = "${var.solution}-tmp-dataproc${local.suffix}"
  force_destroy = local.is_dev
  uniform_bucket_level_access = true
  labels = local.labels
  location = var.region

  lifecycle_rule {

    condition {
      age = 90 # days
    }

    action {
      type = "Delete"
    }

  }
}

resource "google_storage_bucket" "landing" {
  name = "${var.solution}-lnd${local.suffix}"
  force_destroy = local.is_dev
  uniform_bucket_level_access = true
  location = var.region
  labels = local.labels
}


resource "google_storage_bucket" "bronze" {
  name = "${var.solution}-stg${local.suffix}"
  force_destroy = local.is_dev
  uniform_bucket_level_access = true
  location = var.region
  labels = local.labels
}

resource "google_storage_bucket" "silver" {
  name = "${var.solution}-stg${local.suffix}"
  force_destroy = local.is_dev
  uniform_bucket_level_access = true
  location = var.region
  labels = local.labels
}

resource "google_storage_bucket" "gold" {
  name = "${var.solution}-stg${local.suffix}"
  force_destroy = local.is_dev
  uniform_bucket_level_access = true
  location = var.region
  labels = local.labels
}
