locals {
  common_tags_f2i = {
    company      = var.company
    project      = "${var.company} -${var.project}"
    billing_code = var.billing_code
  }
  # tags_isr = 
}