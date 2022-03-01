locals {
  common_tags = {
    Name         = var.company
    company      = var.company
    project      = "${var.company}-${var.project}"
    billing_code = var.billing_code
  }
}