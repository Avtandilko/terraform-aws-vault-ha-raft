output "vpc_id" {
  description = <<-EOT
    VPC ID created in a module and associated with it. Need to be exposed 
    for assigning other resources to the same VPC or for configuration a 
    peering connections
  EOT
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = <<-EOT
    List of Public Subnet IDs created in a module and associated with it. 
    Under the hood is using "Internet Gateway" to external connections 
    for the "Route 0.0.0.0/0". When variable "node_allow_public" = true, 
    this network assigned to the instancies. For other cases this useful 
    to assign another resource in this VPS for example Bastion host which 
    need to be exposed publicly by own IP and not behind a NAT.
  EOT
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = <<-EOT
    List of Private Subnet IDs created in a module and associated with it. 
    Under the hood is using "NAT Gateway" to external connections for the 
    "Route 0.0.0.0/0". When variable "node_allow_public" = false, this 
    network assigned to the instancies. For other cases, this useful to 
    assign another resource in this VPS for example Database which can 
    work behind a NAT (or without NAT at all and external connections 
    for security reasons) and not needs to be exposed publicly by own IP.
  EOT
  value       = module.vpc.private_subnets
}

output "ssh_private_key" {
  description = <<-EOT
    SSH private key which generated by module and its public key 
    part assigned to each of nodes. Don't recommended do this as 
    a private key will be kept open and stored in a state file. 
    Instead of this set variable "ssh_authorized_keys". Please note, 
    if "ssh_authorized_keys" set "ssh_private_key" return empty output
  EOT
  value = (
    local.ssh_authorized_keys ? "" : tls_private_key.core[0].private_key_pem
  )
}

output "alb_dns_name" {
  description = <<-EOT
    ALB external endpoint DNS name. Should use to assign 
    "CNAME" record of public domain
  EOT
  value       = aws_lb.cluster.dns_name
}

output "cluster_url" {
  description = <<-EOT
    Cluster public URL with schema, domain, and port.
    All parameters depend on inputs values and calculated automatically 
    for convenient use. Can be created separately outside a module
  EOT
  value       = local.cluster_url
}

output "nat_public_ips" {
  description = <<-EOT
    NAT public IPs assigned as an external IP for requests from 
    each of the nodes. Convenient to use for restrict application, 
    audit logs, some security groups, or other IP-based security 
    policies. Note: if set "node_allow_public" each node will get 
    its own public IP which will be used for external requests
  EOT
  value       = module.vpc.nat_public_ips
}
