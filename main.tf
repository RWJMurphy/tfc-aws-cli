locals {
  commands = {
    # Commands
    git : "git --version",
    ssh : "ssh -V",
    curl : "curl --version",
    wget : "wget --version",
    jq : "jq --version",
    unzip : "unzip -v",
    ping : "ping -V",
    pip : "pip --version",
    python3 : "python3 --version",
    mercurial : "hg version",
  }
}

resource "terraform_data" "exec" {
  for_each = local.commands

  triggers_replace = [
    uuid()
  ]
  provisioner "local-exec" {
    command = each.value
  }
}

resource "terraform_data" "aws_cli" {
  triggers_replace = [
    uuid()
  ]
  provisioner "local-exec" {
    command = "aws --version"
  }
}

resource "terraform_data" "install_aws_cli" {
  triggers_replace = [
    uuid()
  ]
  provisioner "local-exec" {
    command = "PIP_BREAK_SYSTEM_PACKAGES=1 pip install 'awscli ~= 1.30.0'; aws --version"
  }

  depends_on = [terraform_data.aws_cli]
}
