
module "ec2_instance" {
  source        = "../modules/ec2"
  env_name      = var.env_name
  instance_type = var.instance_type
  key_name      = var.key_name
  my_ip         = var.my_ip
}