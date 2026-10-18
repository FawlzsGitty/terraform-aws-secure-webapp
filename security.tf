# ---------- Security groups ----------
resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "ALB: HTTP from my IP only"
  vpc_id      = aws_vpc.main.id
  tags        = { Name = "alb-sg" }
}

resource "aws_security_group" "app" {
  name        = "app-sg"
  description = "Juice Shop: port 3000 from ALB only, no SSH"
  vpc_id      = aws_vpc.main.id
  tags        = { Name = "app-sg" }
}

# ---------- ALB rules ----------
resource "aws_vpc_security_group_ingress_rule" "alb_http_from_me" {
  security_group_id = aws_security_group.alb.id
  description       = "HTTP from my IP only (vulnerable app)"
  cidr_ipv4         = var.my_ip
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "alb_to_app" {
  security_group_id            = aws_security_group.alb.id
  description                  = "Forward to Juice Shop"
  referenced_security_group_id = aws_security_group.app.id
  ip_protocol                  = "tcp"
  from_port                    = 3000
  to_port                      = 3000
}

# ---------- App rules ----------
resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id            = aws_security_group.app.id
  description                  = "Juice Shop from ALB only"
  referenced_security_group_id = aws_security_group.alb.id
  ip_protocol                  = "tcp"
  from_port                    = 3000
  to_port                      = 3000
}

resource "aws_vpc_security_group_egress_rule" "app_https_out" {
  security_group_id = aws_security_group.app.id
  description       = "HTTPS out: SSM, Docker Hub, package repos"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "app_http_out" {
  security_group_id = aws_security_group.app.id
  description       = "HTTP out: package repos"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}