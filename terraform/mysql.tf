resource "yandex_mdb_mysql_cluster" "mysql" {
  name                = "netology-mysql"
  environment         = "PRESTABLE"
  network_id          = yandex_vpc_network.network.id
  version             = "8.0"
  deletion_protection = true

  resources {
    resource_preset_id = "s2.micro"
    disk_type_id       = "network-ssd"
    disk_size          = 20
  }

  maintenance_window {
    type = "ANYTIME"
  }

  backup_window_start {
    hours   = 23
    minutes = 59
  }

  host {
    zone             = "ru-central1-d"
    subnet_id        = yandex_vpc_subnet.private.id
    assign_public_ip = false
  }

  host {
    zone             = "ru-central1-a"
    subnet_id        = yandex_vpc_subnet.private_a.id
    assign_public_ip = false
  }
}

resource "yandex_mdb_mysql_database" "netology" {
  cluster_id = yandex_mdb_mysql_cluster.mysql.id
  name       = "netology_db"
}

resource "yandex_mdb_mysql_user" "netology" {
  cluster_id = yandex_mdb_mysql_cluster.mysql.id
  name       = "netology_user"
  password   = var.mysql_password

  permission {
    database_name = yandex_mdb_mysql_database.netology.name
    roles         = ["ALL"]
  }
}
