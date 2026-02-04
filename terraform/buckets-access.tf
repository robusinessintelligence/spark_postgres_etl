####################################################################################################
## Storage Bucket IAM Configuration
## This resource manages access to the project's data buckets.
####################################################################################################

# Using IAM Binding for Authoritative access control
# Reference: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam


resource "google_storage_bucket_iam_binding" "datalake_landing_viewer" {
    
    bucket = google_storage_bucket.landing.name
    role   = "roles/storage.objectViewer"

    members = [
        # Production Read-Only Security Group
        "group:GCP-ReadOnly-${var.data_project}@yourdomain.com",

        # Pipeline Service Account (Spark/Dataproc)
        "serviceAccount:${var.service_account_email}",
    ]
}

resource "google_storage_bucket_iam_binding" "datalake_bronze_viewer" {
    
    bucket = google_storage_bucket.bronze.name
    role   = "roles/storage.objectUser"

    members = [
        # Production Read-Only Security Group
        "group:GCP-ReadOnly-${var.data_project}@yourdomain.com",

        # Pipeline Service Account (Spark/Dataproc)
        "serviceAccount:${var.service_account_email}",
        
        # Optional: Analytics Team access
        # "group:gcp-data-analytics@yourdomain.com",
    ]
}

# Example of an IAM Member for a more granular (Non-Authoritative) access
# Use this if other processes also manage permissions on the same bucket
resource "google_storage_bucket_iam_member" "datalake_gold_crud" {
    bucket = google_storage_bucket.gold.name
    
    role   = "roles/storage.objectUser"

    # Pipeline Service Account (Spark/Dataproc)
    member = "serviceAccount:${var.service_account_email}"
}