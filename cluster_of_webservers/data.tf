data "aws_vpc" "default" {
   default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "tag:vpc_id"
    values = [data.aws_vpc.default.id]
  }
}
# resource "aws_subnet" "example" {
#   vpc_id            = data.aws_vpc.selected.id
#   availability_zone = "us-west-2a"
#   cidr_block        = cidrsubnet(data.aws_vpc.selected.cidr_block, 4, 1)
# }