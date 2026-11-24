output "network_id" {
  description = "VPC network ID"
  value       = yandex_vpc_network.network.id
}

output "public_subnet_id" {
  description = "Public subnet ID"
  value       = yandex_vpc_subnet.public.id
}

output "private_subnet_id" {
  description = "Private subnet ID"
  value       = yandex_vpc_subnet.private.id
}

output "nat_internal_ip" {
  description = "NAT instance internal IP"
  value       = yandex_compute_instance.nat.network_interface[0].ip_address
}

output "nat_external_ip" {
  description = "NAT instance external IP"
  value       = yandex_compute_instance.nat.network_interface[0].nat_ip_address
}

output "public_vm_external_ip" {
  description = "Public VM external IP"
  value       = yandex_compute_instance.public.network_interface[0].nat_ip_address
}

output "private_vm_internal_ip" {
  description = "Private VM internal IP"
  value       = yandex_compute_instance.private.network_interface[0].ip_address
}

output "private_route_table_id" {
  description = "Private subnet route table ID"
  value       = yandex_vpc_route_table.private.id
}
