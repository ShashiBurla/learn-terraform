variable "resource_group" {
  default = "devops-practiece" 
}
variable "location" {
  default = "Denmark East"
}
variable "image_id" {
  default = "/subscriptions/e890e2a1-2eca-4c0b-8e51-dd98c583dd43/resourceGroups/devops-practiece/providers/Microsoft.Compute/galleries/rhel10.1/images/1.0.0"
}

variable "components" {
  default = {
    frontend     = "Standard_B1s"
    # mysql        = "Standard_B1s"
    # valkey       = "Standard_B1s"
    # mongodb      = "Standard_B1s"
    # rabbitmq     = "Standard_B1s"
    # catalogue    = "Standard_B1s"
    # user         = "Standard_B1s"
    # cart         = "Standard_B1s"
    # shipping     = "Standard_B1s"
    # order        = "Standard_B1s"
    # notification = "Standard_B1s"
    # ratings      = "Standard_B1s"
    # payment      = "Standard_B1s"
  }
}