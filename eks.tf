resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKScluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.eks_cluster.name
}


resource "aws_iam_role_policy_attachment" "AmazonEKSservice" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.eks_cluster.name
}

resource "aws_eks_cluster" "aws_eks"{
    name = "eks_cluster_ayush"
    role_arn = aws_iam_role.eks_cluster.arn

    vpc_config {
      subnet_ids = ["subnet-0e99981813f555b83","subnet-0378686b808c315d2"]
    }
    tags = {
      "Name" = "EKS_ayush"
    }
}


resource  "aws_iam_role" "eks_nodes" {
 name = "eks-node-group-ayush"
 assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"

         }
     ]
 }
 POLICY
}

resource "aws_iam_role_policy_attachment" "AMZONEKSWORKERNODEPOLIY" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazoneEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistery"{
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.eks_nodes.name
}

resource "aws_eks_node_group" "node" {
    cluster_name = aws_eks_cluster.aws_eks.name
    node_group_name = "node_ayush"
    node_role_arn = aws_iam_role.eks_nodes.arn
    subnet_ids = [ "subnet-0e99981813f555b83","subnet-0378686b808c315d2" ]
    scaling_config {
      desired_size = 1
      max_size = 1
      min_size = 1
    }
    depends_on = [
    aws_iam_role_policy_attachment.AMZONEKSWORKERNODEPOLIY,
    aws_iam_role_policy_attachment.AmazoneEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistery,
    ]
}











