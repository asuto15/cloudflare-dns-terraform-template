# Cloudflare-DNS-Record-Terraform

This repository is a template to manage Cloudflare's DNS records with Terraform and `cf-terraforming` on GitHub Actions.

## Prerequisites

Before using this repository, ensure the following tools are installed:

- **Terraform**: [Install Terraform](https://www.terraform.io/downloads)
- **cf-terraforming**: [cf-terraforming Releases](https://github.com/cloudflare/cf-terraforming)
- **Python 3**: [Install Python](https://www.python.org/downloads/)

## How to use
### Initial setup
1. **Create a new repository using this template**
    - Click the "Use this template" button at the top of this repository page to create a new repository in your GitHub account.

2. **Obtain Cloudflare API Token & Zone ID**
    - Create an API token with permissions to edit Zone Resources in the Cloudflare Dashboard.
    - Get your Zone ID in your domain's overview page of the Cloudflare Dashboard.

3. **Add secrets to the repository**
    - Add the following secrets in your repository under `Settings` -> `Secrets and variables` -> `Actions`.
      - `CLOUDFLARE_API_TOKEN`: your Cloudflare API Token
      - `CLOUDFLARE_ZONE_ID`: your Cloudflare Zone ID

4. **Export Environment Variables**
    - Export the following variables
    ```bash
    export CLOUDFLARE_API_TOKEN="your_api_token"
    export CLOUDFLARE_ZONE_ID="your_zone_id"
    ```

5. **Run the Sync Script**
    - Use the `sync.sh` script to import existing DNS records into Terraform for management.
    ```bash
    git checkout -b init
    ./scripts/sync.sh
    ```
    - During this process:
      - DNS records will be imported into `terraform/records.tf`.
      - The commands to manage records by terraform `terraform import` will be imported into `terraform/import.sh` and they will be executed.
      - Cloudflare Email Routing's `MX` records (e.g., `route*.mx.cloudflare.net`) will be excluded, as they cannot be managed by Terraform.

6. **Commit the changes**
    - After running the script, commit the changes:
    ```bash
    git add .
    git commit -m "Initialize Terraform configuration"
    git push origin init
    ```

7. **Open and Merge a PR**
    - Create a Pull Request from the `init` branch to the `main` branch.
    - Review and merge the PR to finalize the initial setup.

### Managing DNS records

1. **Run the Sync Script**
    - Use the same `sync.sh` script to synchronize changes:
     ```bash
     ./scripts/sync.sh
     ```

2. **Edit DNS records**
    - Modify the `terraform/records.tf` file to add, update, or delete DNS records as needed.

3. **Commit the changes**
    - Save and commit your changes to a new branch.

4. **Open and Merge a PR**
    - Open a Pull Request from the new branch to the `main` branch.
    - Review and merge the PR.

5. GitHub Actions automatically applies changes
    - When you push changes to the `main` branch, GitHub Actions will:
      1. Run `terraform init` to prepare the environment.
      2. Run `terraform apply` to apply the changes to your Cloudflare DNS records.


## Advanced
### How state is managed
- This setup currently uses a local state file (`terraform/terraform.tfstate`), which is uploaded to GitHub Actions artifacts.
- If you want to use a remote backend (e.g., AWS S3, Terraform Cloud), update your terraform configuration accordingly.

## License
This project is licensed under the MIT License. See the LICENSE file for details.