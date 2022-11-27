resource "null_resource" "configure_nfs" {

  depends_on = [aws_efs_mount_target.mount, aws_instance.this]
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file("terraform-trabalho")}"
    host        = aws_instance.this[0].public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 90", # wait for the user_data.sh to finish
      "sudo apt-get update",
      "sudo apt-get install -y curl wget",
      "curl -fsSL https://get.docker.com | bash",
      "sudo apt-get install -y git binutils make",
      "git clone https://github.com/aws/efs-utils",
      "cd efs-utils",
      "make deb",
      "sudo apt-get install -y ./build/amazon-efs-utils*deb",
      "cd ..",
      "sudo mkdir efs",
      "sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.efs.dns_name}:/ efs",
      "cd efs",
      "sudo rm -rf cpdol-trabalho-final",
      "sudo git clone https://github.com/annevaz/cpdol-trabalho-final.git",
      "sudo docker run -v /home/ubuntu/efs/cpdol-trabalho-final:/usr/share/nginx/html -d -p 80:80 nginx:latest"
    ]
  }

}