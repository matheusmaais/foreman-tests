output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value     = aws_eks_cluster.this.endpoint
  sensitive = true
}

output "cluster_certificate_authority" {
  value     = aws_eks_cluster.this.certificate_authority[0].data
  sensitive = true
}

output "cluster_security_group_id" {
  value = aws_security_group.cluster.id
}

output "node_security_group_id" {
  value = aws_security_group.node.id
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.this.arn
}

output "oidc_provider_url" {
  value = aws_iam_openid_connect_provider.this.url
}

output "node_role_arn" {
  value = aws_iam_role.node.arn
}

output "irsa_app_role_arn" {
  value = aws_iam_role.irsa_app.arn
}

output "kms_secrets_key_arn" {
  value     = aws_kms_key.secrets.arn
  sensitive = true
}

output "kms_ebs_key_arn" {
  value     = aws_kms_key.ebs.arn
  sensitive = true
}
