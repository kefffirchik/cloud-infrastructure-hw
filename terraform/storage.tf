resource "yandex_storage_bucket" "cats" {
  bucket    = "kefffirchik-cloud-hw-cats-20261118"
  folder_id = var.folder_id

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.storage.id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  depends_on = [
    yandex_kms_symmetric_key_iam_binding.storage
  ]
}

resource "yandex_storage_object" "cats_image" {
  bucket       = yandex_storage_bucket.cats.bucket
  key          = "cats.jpg"
  source       = "${path.module}/../02/img/cats.jpg"
  content_type = "image/jpeg"
  acl          = "public-read"
}
