# Packer-AzureDevOps

To create an Ubuntu OS image in Azure, we use a simple code. For Packer, we now use HCL instead of JSON since JSON is not supported in newer versions. The Packer file should have the extension FileName.pkr.hcl.

Additionally, we need to create a file named variables.pkr.hcl to define the values for variables such as clientid, clientsecret, subscriptionid, and tenantid. More variables can be declared in this file if required.
