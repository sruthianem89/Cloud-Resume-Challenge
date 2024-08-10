- Github user with permissions should be created and the credentials should be added as GitHub secrets.
- `terraformstatesru` S3 bucket should be created manually to store the state file.
- Cloudflare API token should be added as GitHub secrets.
- Region should be added to GitHub secrets.
- If the infrastructure is destroyed using `terraform destroy`, remove the state file manually from the state bucket.
- If using a custom domain, the domain name should be registered by the registry and the domain should be added to the hosted zone. In this project, I am using Cloudflare for both domain registration and DNS management.
- If the infrastructure is changed manually in the AWS console, the state file should be updated manually using `terraform refresh` and terraform configuration should be updated to reflect the new changes.
- Update the `terraform.tfvars` based on your requirements.
- Update the backend files `index.html`, `styles.css`, and `scripts.js` based on your requirements.