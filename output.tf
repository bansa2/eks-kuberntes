output "eks_cluster_endpoint" {
    value = aws_eks_cluster.aws_eks.endpoint
  
}

output "eks_cluster_certificate" {
    value = aws_eks_cluster.aws_eks.certificate_authority
  
}