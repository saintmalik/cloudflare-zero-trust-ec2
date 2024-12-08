# ==============================================================================
# FCK-NAT MODULE
# ==============================================================================
module "fck-nat" {
  source        = "RaJiska/fck-nat/aws"
  version       = "1.3.0"
  name          = "fck-nat-${var.env}"
  vpc_id        = aws_vpc.main.id
  subnet_id     = aws_subnet.public.id
  instance_type = "t4g.nano"
  ha_mode       = true
  # eip_allocation_ids = ["${aws_eip.preprod_eip.id}"]
  tags = {
    Name = "fck-nat-${var.env}"
  }
}

resource "aws_route" "eni_route" {
  count                  = 1
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = module.fck-nat.eni_id
}
