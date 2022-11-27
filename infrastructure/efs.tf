resource "aws_efs_file_system" "efs" {
creation_token = "${local.prefix}-efs"
tags = {
	Name = "${local.prefix}-efs"
  }
}

resource "aws_efs_mount_target" "mount" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.this.id
  security_groups = [aws_security_group.sg-web.id]
}