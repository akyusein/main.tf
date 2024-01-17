provider "local" {}

# Define a Docker network
resource "null_resource" "create_network" {
  provisioner "local-exec" {
    command = "docker network create my_network"
  }
}

# NGINX Load Balancer
resource "null_resource" "nginx_lb" {
  provisioner "local-exec" {
    command = "docker run -d --name nginx_lb -p 8080:80 --network my_network nginx:latest"
  }

  depends_on = [null_resource.create_network]
}

# Apache Web Server
resource "null_resource" "apache_server" {
  provisioner "local-exec" {
    command = "docker run -d --name apache_server --network my_network httpd:latest"
  }

  depends_on = [null_resource.create_network]
}

# PostgreSQL Database
resource "null_resource" "postgres_db" {
  provisioner "local-exec" {
    command = "docker run -d --name postgres_db --network my_network -e POSTGRES_USER=myuser -e POSTGRES_PASSWORD=mypassword -e POSTGRES_DB=mydatabase postgres:latest"
  }

  depends_on = [null_resource.create_network]
}
