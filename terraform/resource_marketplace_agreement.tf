resource "null_resource" "marketplace_agreement" {
  for_each = local.vm_image

  provisioner "local-exec" {
    command = "az vm image terms accept --publisher ${each.value.publisher} --offer ${each.value.offer} --plan ${each.value.sku}"
  }

  triggers = {
    publisher = each.value.publisher
    offer     = each.value.offer
    sku       = each.value.sku
  }
}
