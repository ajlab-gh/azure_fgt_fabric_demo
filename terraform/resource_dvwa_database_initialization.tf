resource "null_resource" "initialize_dvwa" {
  provisioner "local-exec" {
    command = <<EOF
      while ! curl -s ${local.attack_targets.fgt.DVWAURL}/setup.php > /dev/null; do
        echo "Waiting for DVWA to be available..."
        sleep 5
      done
      curl -s ${local.attack_targets.fgt.DVWAURL}/setup.php --data "create_db=Create+%2F+Reset+Database" > /dev/null
      echo "DVWA database initialized."
EOF
  }
}
