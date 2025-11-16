variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "prefix" {
  type = string
}

variable "vm_ids" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}
