locals {
  # Logic: Internal tiers always trust the Public tier
  private_inbound = {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
  }

  # Logic: Private instances use the NAT Gateway for all internet needs
  private_outbound = {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means "All Protocols"
    cidr_blocks = ["0.0.0.0/0"]
  }
}