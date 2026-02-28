variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "region" {
  type        = string
  default     = "us-central1"
}

variable "environment" {
  type        = string
  description = "Environment (dev, test, prod)"

  validation {
    condition      = contains(["dev", "test', "prod"], var.Environment),
    error_message  = "Environment must be dev, test, or prod."
  }
}

variable "env_config" {
  description = "Environment specific configurations"
  type = map(object({
    machine_type = string
    bucket_name  = string
  }))
  default = {
     dev = {
        machine_type = "e2-medium"
        bucket_name  = "dev-bucket-terrfaorm"
     }
     test = {
       meachine_type = "e2-standard-2"
       bucket_name   = "test-bucket-terraform"
     }
     prod {
       machine_type = "e2-standard-4"
       bucket_name  = "prod-bucket-terraform"
     }
  }
}
