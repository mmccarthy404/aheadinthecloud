variable "local" {
  type = object({
    env    = string
    region = string
    domain = string
  })
}