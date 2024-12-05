# Repository Overview  
This repository contains Terraform code for provisioning and managing AWS infrastructure resources, including:

- VPC  
- Private and Public Subnets  
- Internet Gateway  
- Route Tables  
- NAT Gateway  
- Elastic IP  
- EC2 Instances  
- Elastic Load Balancer (ELB)  

The infrastructure is designed to work cohesively to support a web application hosted on two private EC2 instances. The Elastic Load Balancer (ELB) distributes incoming traffic evenly between these private EC2 instances, ensuring high availability and scalability.

## Key Components and Roles  
1. Internet Gateway: Provides internet access for the public subnet.  
2. NAT Gateway: Facilitates outbound internet access for resources in the private subnet via the associated route table.  
3. Elastic Load Balancer: Balances traffic across the private EC2 instances to ensure reliable application delivery.

## Modular Design
The Terraform codebase is modularized for:

- Reusability: Modules can be reused across different environments or projects.  
- Security: Sensitive configurations are abstracted and controlled via input variables.  
- Simplicity: Modularization reduces complexity and improves code readability, making it easier to maintain and extend.  


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

4. Customize the variables in the `variable.tf` and create a `terraform.tfvars` file according to your requirements.

5. Review the Terraform plan:
    ```
    terraform plan
    ```

6. Apply the Terraform configuration:
    ```
    terraform apply
    ```
