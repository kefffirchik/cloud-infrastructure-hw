resource "yandex_compute_instance_group" "lamp" {
  name               = "lamp-instance-group"
  folder_id          = var.folder_id
  service_account_id = "aje3j1b1pajsmirvu3vq"

  instance_template {
    platform_id = "standard-v3"

    resources {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }

    boot_disk {
      mode = "READ_WRITE"

      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
        size     = 10
        type     = "network-hdd"
      }
    }

    network_interface {
      network_id = yandex_vpc_network.network.id
      subnet_ids = [yandex_vpc_subnet.public.id]
      nat        = true
    }

    metadata = {
      ssh-keys = "ubuntu:${file(pathexpand(var.ssh_public_key_path))}"

      user-data = <<-CLOUDINIT
        #cloud-config
        write_files:
          - path: /var/www/html/index.html
            permissions: '0644'
            content: |
              <!DOCTYPE html>
              <html>
              <head>
                <title>Netology Cloud Homework</title>
              </head>
              <body>
                <h1>Yandex Cloud Instance Group</h1>
                <img src="https://storage.yandexcloud.net/${yandex_storage_bucket.cats.bucket}/${yandex_storage_object.cats_image.key}" alt="Cats" width="500">
              </body>
              </html>
        runcmd:
          - systemctl restart apache2
      CLOUDINIT
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.zone]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  health_check {
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3

    http_options {
      port = 80
      path = "/"
    }
  }

  load_balancer {
    target_group_name = "lamp-target-group"
  }
}
