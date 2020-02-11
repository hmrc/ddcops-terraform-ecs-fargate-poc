variable "region" {
  description = "Region that the instances will be created"
}

/*====
environment specific variables
======*/

variable "sandbox_database_name" {
  description = "The database name for sandbox"
}

variable "sandbox_database_username" {
  description = "The username for the sandbox database"
}

variable "sandbox_database_password" {
  description = "The user password for the sandbox database"
}

variable "sandbox_secret_key_base" {
  description = "The Rails secret key for sandbox"
}

variable "domain" {
  default = "The domain of your application"
}
