resource "aws_security_group" "tf" {
  name        = "allow_tf"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.default.id
  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.tf.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.http_port
  ip_protocol       = "tcp"
  to_port           = var.http_port
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_connection" {
  security_group_id = aws_security_group.tf.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.http
  ip_protocol       = "tcp"
  to_port           = var.http
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.tf.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}