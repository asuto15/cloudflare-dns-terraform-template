# Cloudflare-DNS-Record-Terraform

This repository is a template to manage Cloudflare's DNS records with Terraform and `cf-terraforming` on GitHub Actions.

## Prerequisite
This repository uses `terraform` & `cf-terraforming` commands. Please install them in advance.

## How to use
### Initial setup
1. **Create a new repository using this template**
    - Click the "Use this template" button at the top of this repository page to create a new repository in your GitHub account.
2. **Obtain Cloudflare API TOKEN & ZONE ID**
    - Create API Token that includes the permissions to edit the Zone Resources in Cloudflare Dash Board.
    - Get your Zone ID in your domain's overview page of the Cloudflare Dashboard
3. **Add secrets to the repository**
    - Add the following secrets in your repository under `Settings` -> `Secrets and variables` -> `Actions`.
      - `CLOUDFLARE_API_TOKEN`: your Cloudflare API Token
      - `CLOUDFLARE_ZONE_ID`: your Cloudflare Zone ID
4. **Export Environment Variables**
    - Export the following variables
    ```bash
    export CLOUDFLARE_API_TOKEN=""
    export CLOUDFLARE_ZONE_ID=""
    ```
5. **Run the Initialization script**
    - Use the `initialize.sh` script to import existing DNS records into Terraform for management.
    ```bash
    git checkout -b init
    ./scripts/initialize.sh
    ```
    - During this process, DNS records will be imported into `terraform/records.tf` by `cf-terraforming`.
      - Cloudflare Email Routing's MX records (e.g., `route*.mx.cloudflare.net`) will be excluded, as they cannot be managed by Terraform.
6. **Commit the changes and push to remote**
    - After running the script, commit the changes:
    ```bash
    git add .
    git commit -m "Initialize Terraform configuration"
    git push origin init
    ```
7. **Open and Merge a PR to the `main` branch**
    - Create a Pull Request from the `init` branch to the `main` branch.
    - Review and merge the PR to finalize the initial setup.

### Managing DNS records
1. **Edit DNS records in a new branch**
    - Modify the `terraform/records.tf` file to add, update, or delete DNS records as needed.
2. **Commit your changes**
    - Save and commit your changes to the new branch.
3. **Open a PR to the `main` branch and Review & Merge it**
    - Open a Pull Request from the `init` branch to the `main` branch.
    - Review the changes and merge the pull request.
    ```bash
    git add .
    git commit -m "Update DNS records"
    git push origin main
    ```
4. GitHub Actions automatically applies changes
    - When you push changes to the `main` branch, GitHub Actions will:
      1. Run `terraform init` to prepare the environment.
      2. Run `terraform apply` to apply the changes to your Cloudflare DNS records.

## Advanced
### How state is managed
- This setup currently uses a local state file (`terraform/terraform.tfstate`), which is uploaded to GitHub Actions artifacts.
- If you want to use a remote backend (e.g., AWS S3, Terraform Cloud), update your terraform configuration accordingly.

## License
This project is licensed under the MIT License. See the LICENSE file for details.