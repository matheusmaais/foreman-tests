resource "aws_security_group" "cluster" {
  name_prefix = "${var.cluster_name}-cluster-"
  description = "EKS cluster control plane"
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { Name = "${var.cluster_name}-cluster" })
}

resource "aws_security_group" "node" {
  name_prefix = "${var.cluster_name}-node-"
  description = "EKS worker nodes"
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { Name = "${var.cluster_name}-node" })
}

# Cluster -> Node: kubelet
resource "aws_security_group_rule" "cluster_to_node_kubelet" {
  type                     = "egress"
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cluster.id
  source_security_group_id = aws_security_group.node.id
  description              = "Cluster to node kubelet"
}

# Cluster -> Node: HTTPS (for webhook/extension API servers on nodes)
resource "aws_security_group_rule" "cluster_to_node_https" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cluster.id
  source_security_group_id = aws_security_group.node.id
  description              = "Cluster to node HTTPS"
}

# Node -> Cluster: HTTPS (API server)
resource "aws_security_group_rule" "node_to_cluster_https" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.node.id
  source_security_group_id = aws_security_group.cluster.id
  description              = "Node to cluster API server"
}

# Ingress: Node accepts kubelet from cluster
resource "aws_security_group_rule" "node_ingress_kubelet" {
  type                     = "ingress"
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  security_group_id        = aws_security_group.node.id
  source_security_group_id = aws_security_group.cluster.id
  description              = "Kubelet from cluster"
}

# Ingress: Node accepts HTTPS from cluster
resource "aws_security_group_rule" "node_ingress_https_from_cluster" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.node.id
  source_security_group_id = aws_security_group.cluster.id
  description              = "HTTPS from cluster"
}

# Ingress: Cluster accepts HTTPS from nodes
resource "aws_security_group_rule" "cluster_ingress_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cluster.id
  source_security_group_id = aws_security_group.node.id
  description              = "HTTPS from nodes"
}

# Node-to-node communication (kubelet + HTTPS only)
resource "aws_security_group_rule" "node_to_node_kubelet" {
  type                     = "ingress"
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  security_group_id        = aws_security_group.node.id
  source_security_group_id = aws_security_group.node.id
  description              = "Node to node kubelet"
}

resource "aws_security_group_rule" "node_to_node_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.node.id
  source_security_group_id = aws_security_group.node.id
  description              = "Node to node HTTPS"
}
