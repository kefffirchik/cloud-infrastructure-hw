resource "yandex_kubernetes_cluster" "k8s" {
  name        = "netology-k8s"
  description = "Regional Kubernetes cluster"
  folder_id   = var.folder_id
  network_id  = yandex_vpc_network.network.id

  master {
    version   = "1.35"
    public_ip = true

    regional {
      region = "ru-central1"

      location {
        zone      = yandex_vpc_subnet.public_a.zone
        subnet_id = yandex_vpc_subnet.public_a.id
      }

      location {
        zone      = yandex_vpc_subnet.public.zone
        subnet_id = yandex_vpc_subnet.public.id
      }

      location {
        zone      = yandex_vpc_subnet.public_e.zone
        subnet_id = yandex_vpc_subnet.public_e.id
      }
    }
  }

  service_account_id      = yandex_iam_service_account.k8s.id
  node_service_account_id = yandex_iam_service_account.k8s.id

  release_channel     = "STABLE"
  cluster_ipv4_ranges = ["10.112.0.0/16"]
  service_ipv4_range  = "10.96.0.0/16"

  kms_provider {
    key_id = yandex_kms_symmetric_key.storage.id
  }

  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s_agent,
    yandex_resourcemanager_folder_iam_member.k8s_public_admin,
    yandex_resourcemanager_folder_iam_member.k8s_images_puller,
    yandex_kms_symmetric_key_iam_binding.storage
  ]
}

resource "yandex_kubernetes_node_group" "workers" {
  cluster_id  = yandex_kubernetes_cluster.k8s.id
  name        = "netology-workers"
  description = "Autoscaling Kubernetes worker nodes"
  version     = "1.35"

  instance_template {
    platform_id = "standard-v3"

    network_interface {
      nat        = true
      subnet_ids = [yandex_vpc_subnet.public_a.id]
    }

    resources {
      cores         = 2
      memory        = 4
      core_fraction = 100
    }

    boot_disk {
      type = "network-hdd"
      size = 30
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    auto_scale {
      min     = 3
      max     = 6
      initial = 3
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }

  deploy_policy {
    max_expansion   = 0
    max_unavailable = 1
  }
}
