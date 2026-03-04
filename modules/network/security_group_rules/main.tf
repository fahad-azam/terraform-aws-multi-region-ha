# Primary Region: Private Inbound from Public
resource "aws_security_group_rule" "primary_private_inbound" {
  type                     = "ingress"
  from_port                = local.private_inbound.from_port   # e.g., 0
  to_port                  = local.private_inbound.to_port     # e.g., 65535
  protocol                 = local.private_inbound.protocol    # e.g., "tcp" or "-1"
  security_group_id        = var.primary_private_sg_id
  source_security_group_id = var.primary_public_sg_id
}

# Standby Region: Private Inbound from Public
resource "aws_security_group_rule" "standby_private_inbound" {
  provider                 = aws.standby_region_aws      # Critical for multi-region
  type                     = "ingress"
  from_port                = local.private_inbound.from_port
  to_port                  = local.private_inbound.to_port
  protocol                 = local.private_inbound.protocol
  security_group_id        = var.standby_private_sg_id
  source_security_group_id = var.standby_public_sg_id
}

resource "aws_security_group_rule" "primary_private_outbound" {
    type                     = "egress"
    from_port                = local.private_outbound.from_port   # e.g., 0
    to_port                  = local.private_outbound.to_port     # e.g., 0
    protocol                 = local.private_outbound.protocol    # e.g., "-1"
    security_group_id        = var.primary_private_sg_id
    cidr_blocks             = local.private_outbound.cidr_blocks # e.g., ["0.0.0.0/0"]  
  
}
resource "aws_security_group_rule" "standby_private_outbound" {
    provider                 = aws.standby_region_aws      # Critical for multi-region
    type                     = "egress"
    from_port                = local.private_outbound.from_port   # e.g., 0
    to_port                  = local.private_outbound.to_port     # e.g., 0
    protocol                 = local.private_outbound.protocol    # e.g., "-1"
    security_group_id        = var.standby_private_sg_id
    cidr_blocks             = local.private_outbound.cidr_blocks # e.g., ["0.0.0.0/0"]  
  
}

resource "aws_security_group_rule" "primary_public_ingress" {
  for_each          = var.public_inbound_rules
  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidrs
  security_group_id = var.primary_public_sg_id
}
resource "aws_security_group_rule" "standby_public_ingress" {
    provider           = aws.standby_region_aws      # Critical for multi-region
  for_each          = var.public_inbound_rules
  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidrs
  security_group_id = var.standby_public_sg_id
}
# Primary Public Outbound
resource "aws_security_group_rule" "primary_public_egress" {
  type              = "egress"
  from_port         = local.private_outbound.from_port
  to_port           = local.private_outbound.to_port
  protocol          = local.private_outbound.protocol
  security_group_id = var.primary_public_sg_id
  cidr_blocks       = local.private_outbound.cidr_blocks
}

# Standby Public Outbound
resource "aws_security_group_rule" "standby_public_egress" {
  provider          = aws.standby_region_aws
  type              = "egress"
  from_port         = local.private_outbound.from_port
  to_port           = local.private_outbound.to_port
  protocol          = local.private_outbound.protocol
  security_group_id = var.standby_public_sg_id
  cidr_blocks       = local.private_outbound.cidr_blocks
}
