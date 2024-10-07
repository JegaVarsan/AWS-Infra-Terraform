The infrastructure in AWS has been constructed using Terraform. The resources listed below have been developed, including:
1) VPC
2) Internet Gateway
3) Subnets
4) Route Table
5) Security Group
6) EC2 Instance
   
The state files are kept in an S3 bucket.

Terraform code has been triggered by Github Actions; hence, we must supply the code's path and authorization for "auto-approve" in Terraform apply. Both the building and destruction of infrastructure have their own workflows. 

Additionally, one can view the differences in infrastructure between the intended and present states using a Python code (current infrastructure is recorded in a state file). To utilize that, you must take the following actions:
1) Perform terraform plan and extract the out file
   
          terraform plan -out output.tfplan
3) Convert the plan to JSON and store that in a seperate file
   
           terraform show -json output.tfplan > temp.json
5) Make a copy of the JSON content and save it in a separate file, such as varsan.json. 
6) Execute the Python script by providing the varsan.json file, and observe the modifications.
