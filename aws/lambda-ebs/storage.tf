#
# file-system for lambdas
#
resource "aws_efs_file_system" "disk" {
  tags = merge(
    var.project_tags,
    var.storage_tags,
    { Name = "${var.project_name}-lambda-efs" }
  )
}

# FIXME: create a mount target for each az in the vpc
resource "aws_efs_mount_target" "disk" {
  file_system_id  = aws_efs_file_system.disk.id
  subnet_id       = aws_subnet.efs.id
  security_groups = [module.lambda_efs_sg.this_security_group_id]
}

resource "aws_efs_access_point" "disk_write" {
  file_system_id = aws_efs_file_system.disk.id

  root_directory {
    path = "/inference"
    creation_info {
      owner_gid   = 1001
      owner_uid   = 1001
      permissions = "744"
    }
  }

  posix_user {
    gid = 1001
    uid = 1001
  }

  tags = merge(
    var.project_tags,
    var.storage_tags
  )
}

resource "aws_efs_access_point" "disk_read" {
  file_system_id = aws_efs_file_system.disk.id

  root_directory {
    path = "/inference"
  }

  posix_user {
    gid = 1002
    uid = 1002
  }

  tags = merge(
    var.project_tags,
    var.storage_tags
  )
}
