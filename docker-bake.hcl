variable "TAGS" {
  default = "latest"
}
variable "DIRECTORY" {
  default = "ghcr.io"
}

variable "platforms" {
  default = ["windows/amd64", "linux/arm64", "linux/amd64"]
}

group "default" {
  targets = [
    "dotnet-multiplatform-docker",
  ]
}

function "tagImage" {
  params = [image]
  result = [for tag in split(",", TAGS) : "${DIRECTORY}/${image}:${tag}"]
}

target "dotnet-multiplatform-docker" {
  dockerfile = "dotnet-multiplatform-docker/Dockerfile"
  tags = tagImage("computost/dotnet-multiplatform-docker")
  platforms = platforms
}