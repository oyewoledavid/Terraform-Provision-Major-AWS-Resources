## TERRAFORM
This repository contains Terraform code for managing infrastructure resources such as vpc,private and public subnets, internet gateway, route tables, NAT Gateway, Elastic IP, EC2 instances and a Elastic Load Balancer (ELB). This resources are provisioned to work together in such a way that the ELB distribute traffics into the two private EC2 instances where our webapp will be hosted.

### Prerequisites
Before using this code, make sure you have the following prerequisites installed:
- Terraform
- AWS account
- AWS CLI

### Getting Started
To get started with this code, follow these steps:

1. Clone the repository:
    ```
    git clone https://github.com/oyewoledavid/Terraform-Provision-Major-AWS-Resources.git
    ```

2. Change into the project directory:
    ```
    cd your-repo
    ```

3. Initialize Terraform:
    ```
    terraform init
    ```

4. Customize the variables in the `variable.tf` file according to your requirements.

5. Review the Terraform plan:
    ```
    terraform plan
    ```

6. Apply the Terraform configuration:
    ```
    terraform apply
    ```
