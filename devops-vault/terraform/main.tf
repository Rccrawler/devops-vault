resource "random_uuid" "id" {}

resource "minio_s3_bucket" "uploads" {
  bucket         = var.bucket_name
  acl            = "private"
  object_locking = false
}

# Crea un IAM user (service account)
resource "minio_iam_user" "ci_user" {
  name = var.username
}

# Crea access key/secretKey para ese usuario (si no proporcionas access_key)
resource "minio_accesskey" "ci_access" {
  user = minio_iam_user.ci_user.name
  # optional: access_key, secret_key -> si no pones, la provider genera
  # access_key = var.access_key
  # secret_key = var.secret_key
}

# Policy que permite PutObject/GetObject en el bucket uploads
data "template_file" "policy" {
  template = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Effect":"Allow",
      "Action":[
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource":[
        "arn:aws:s3:::${minio_s3_bucket.uploads.bucket}",
        "arn:aws:s3:::${minio_s3_bucket.uploads.bucket}/*"
      ]
    }
  ]
}
EOF
}

resource "minio_s3_bucket_policy" "uploads_policy" {
  bucket = minio_s3_bucket.uploads.bucket
  policy = data.template_file.policy.rendered
}

# conecta policy al user (provider tiene recursos para policy attachment)
resource "minio_user_policy_attachment" "attach" {
  user   = minio_iam_user.ci_user.name
  policy = minio_s3_bucket_policy.uploads_policy.policy
  # Nota: si el provider no expone "user_policy_attachment", puede hacerse
  # con minio_user_policy resource. Si tienes problemas con la versión,
  # míralo en la documentación del provider.
}
