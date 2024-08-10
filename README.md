#1. Github user with permissions should be created and the credentials should be added as github secrets
#2. terraformstatesru s3 bucket should be created manually to store the state file
#3. Cloudflare API token should be added as github secrets
#4. Region should be added to github secrets
#5. If the infrastructure is destroyed using terraform destroy, remove the state file manually from the state bucket
#6. If using a custom domain the domain name should be registered by the registry and the domain should be added to the hosted zone. In this project I am using Cloudflare for both domain registration and DNS management
#7. If the infrastructure is changed manually in the AWS console, the state file should be updated manually using terraform refresh and terraform configuration should be updated to reflect the new changes
#8. Update the terraformtf.vars based on your requirements
#9. Update the backend files index.html, styles.css & scripts.jss based on your requirements