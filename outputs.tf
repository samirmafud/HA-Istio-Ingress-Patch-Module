output "subnets_id" {
  description = "ID de las subnets"
  value       = join(",", var.subnets_id)
}