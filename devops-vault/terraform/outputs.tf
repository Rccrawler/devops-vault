output "ci_user" {
  value = minio_iam_user.ci_user.name
}

output "ci_access_key" {
  value = minio_accesskey.ci_access.access_key
  sensitive = true
}

output "ci_secret_key" {
  value = minio_accesskey.ci_access.secret_key
  sensitive = true
}

output "bucket" {
  value = minio_s3_bucket.uploads.bucket
}
