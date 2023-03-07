# Terraform-AWS-REST-API-with-Jenkins-and-Docker-Example

Terraform is used to set up the app (backend/frontend) and Jenkins. It is responsible of creating, managing and destroying the infrastructure. It creates an EC2 instance, and runs the app and Jenkins in the instance as Docker containers.

Jenkins is used as the (CI/)CD tool. Rebuilds the app on pushes to GitHub repository.

App consists of backend and frontend as a REST API that can be hosted in different origins.

Project is configured to be used with a private repository, but with the deletion of a few lines, can be used with public repositories.

Information regarding used technologies can be found in their respective directories.

To get this project running, just go to the `terraform` folder, follow the instructions and that's all.
