# Cloudflare-DNS-Record-Terraform

This repository is a template to manage Cloudflare's DNS records with Terraform and `cf-terraforming` on GitHub Actions.

## How to use
1. **Create a new repository using this template**
Click "Use this template" button at the top of the repository page to create a new repository in your GitHub account.
2. **Obtain Cloudflare API TOKEN & ZONE ID**
- Create API Token that includes the permissions to edit the Zone Resources in Cloudflare Dash Board.
- Get your Zone ID in your domain's overview page of the Cloudflare Dashboard
3. **Add secrets to the repository**
Add the following secrets in your repository under `Settings` -> `Secrets and variables` -> `Actions`.
- `CLOUDFLARE_API_TOKEN`: your Cloudflare API Token
- `CLOUDFLARE_ZONE_ID`: your Cloudflare Zone ID
4. **Create a `init` branch**
Create a new branch named `init` in your repository. You can do this on GitHub, or locally
```bash
git checkout -b init
git push origin init
```

5. **GitHub Actions initializes existing DNS record automatically**(No action required in this step)
- When the `init` branch is created, GitHub Actions will:
  1. Run `cf-terraforming` to generate `terraform/records.tf` and `terraform/import.sh` from your existing DNS records.
  2. Automatically remove Cloudflare Email Routing MX records from the generated files.
  3. Apply the configuration to initialize Terraform state.
  4. Commit the generated file (only `records.tf` but not the Terraform state file) to the init branch.
 `cf-terraforming` to generate `terraform/records.tf` from your existing DNS records.
- The generated `records.tf` file will be committed to the`init` branch automatically.
6. **Merge into `main` branch**
- Open a Pull Request from the `init` branch to the `main` branch.
- Review the changes and merge the pull request.
7. **Manage DNS record**
- Editting `terraform/records.tf`file to add, update, or delete DNS records as needed on another branch.
8. **Commit changes and push them to the `main` branch**
After editing `terraform/records.tf`, commit your changes and push them to the main branch
```bash
git add .
git commit -m "Update DNS records"
git push origin main
```
9. GitHub Actions automatically applies changes
- When you push changes to the `main` branch, GitHub Actions will:
  1. Run `terraform init` to prepare the environment.
  2. Run `terraform apply` to apply the changes to your Cloudflare DNS records.

## Advanced
### How state is managed
- This setup currently uses a local state file (`terraform/terraform.tfstate`), which is uploaded to GitHub Actions artifacts.
- If you want to use a remote backend (e.g., AWS S3, Terraform Cloud), update your terraform configuration accordingly.

## License
This project is licensed under the MIT License. See the LICENSE file for details.