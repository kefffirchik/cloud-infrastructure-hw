data "yandex_compute_image" "nat" {
  image_id = "fd80mrhj8fl2oe87o4e1"
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}
