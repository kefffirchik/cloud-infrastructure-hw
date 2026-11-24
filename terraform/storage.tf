resource "yandex_storage_bucket" "cats" {
  bucket    = "kefffirchik-cloud-hw-cats-20261118"
  folder_id = var.folder_id
}

resource "yandex_storage_object" "cats_image" {
  bucket       = yandex_storage_bucket.cats.bucket
  key          = "cats.jpg"
  source       = "${path.module}/../02/img/cats.jpg"
  content_type = "image/jpeg"
  acl          = "public-read"
}
