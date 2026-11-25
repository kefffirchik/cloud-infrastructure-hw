resource "yandex_kms_symmetric_key" "storage" {
  name              = "storage-encryption-key"
  description       = "Encryption key for Object Storage bucket"
  folder_id         = var.folder_id
  default_algorithm = "AES_256"
  rotation_period   = "8760h"
}

resource "yandex_kms_symmetric_key_iam_binding" "storage" {
  symmetric_key_id = yandex_kms_symmetric_key.storage.id
  role             = "kms.keys.encrypterDecrypter"

  members = [
    "serviceAccount:aje3j1b1pajsmirvu3vq"
  ]
}
