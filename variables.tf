variable "db_username" {
  description = "PostgreSQL username"
  type        = string
}

variable "db_password" {
  description = "PostgreSQL password"
  type        = string
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "mydatabase"
}

variable "ecs_task_memory" {
  description = "ECS task memory size"
  type        = number
  default     = 512
}

variable "ecs_task_cpu" {
  description = "ECS task CPU size"
  type        = number
  default     = 256
}