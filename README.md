# GCP Terraform Bootstrap Lab

This lab uses only a personal Google Cloud project and GitHub repository to
rehearse the initial Terraform and Cloud Build bootstrap process with a small,
focused configuration.

Do not copy project IDs, service accounts, bucket names, credentials, IAM
settings, or other configuration from an employer or any other organization
into this repository.

## Objectives

- Rehearse the order for introducing Terraform management to an existing GCP project
- Use a GCS remote backend and keep each Terraform root in a separate state
- Understand the boundaries between a Cloud Build GitHub connection, linked repository, and triggers
- Distinguish the bootstrap operator from the service account used by subsequent Cloud Build executions
- Document how manually created resources are imported into Terraform state

## Scope

This lab uses one existing personal GCP project. Creating the GCP project,
configuring its billing account, and managing organization-level policies are
outside the scope of Terraform in this repository.

## Repository Structure

```text
.
├── bootstrap
│   └── README.md
├── cloudbuild
│   ├── plan.yaml
│   └── apply.yaml
├── env
│   └── lab
│       ├── api
│       │   ├── backend.tf
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   ├── providers.tf
│       │   ├── terraform.tfvars.example
│       │   ├── variables.tf
│       │   └── versions.tf
│       ├── cloudstorage
│       │   └── ...
│       └── cloudbuild
│           └── ...
├── modules
│   ├── api
│   ├── cloudstorage
│   └── cicd
├── .gitignore
└── README.md
```

The directories have the following responsibilities.

| Terraform root | Primary resources | State prefix |
| --- | --- | --- |
| `env/lab/api` | Google Cloud APIs used by the lab | `terraform/lab/api` |
| `env/lab/cloudstorage` | Terraform state and Cloud Build log buckets | `terraform/lab/cloudstorage` |
| `env/lab/cloudbuild` | Terraform service account, IAM, repository, and triggers | `terraform/lab/cloudbuild` |

Reusable resource definitions belong under `modules`. The directories under
`env/lab` are the root modules from which Terraform CLI commands are run.

Each root contains its own `backend.tf`, provider constraints, input variables,
example values, and outputs. Copy the example files locally before execution:

```text
backend.hcl.example       -> backend.hcl
terraform.tfvars.example -> terraform.tfvars
```

The populated files are excluded from Git.

## Implementation Defaults

- Terraform CLI: `~> 1.15.0`; Cloud Build uses `hashicorp/terraform:1.15.8`
- Google provider: `~> 7.42.0`
- Cloud Build repository type: regional Cloud Build repositories (2nd gen)
- Pull-request trigger target: `main`, requiring a repository owner or collaborator to comment `/gcbrun`
- Push trigger target: `main`, with manual build approval required by default
- Bucket access: uniform bucket-level access with public access prevention
- Terraform state bucket: Object Versioning enabled and deletion protected
- Cloud Build logs: user-owned GCS bucket with a 30-day object lifecycle rule

The Terraform Cloud Build service account receives the following project-level
roles for this isolated lab:

- `roles/cloudbuild.editor`
- `roles/iam.securityReviewer`
- `roles/iam.serviceAccountViewer`
- `roles/serviceusage.serviceUsageAdmin`
- `roles/storage.admin`

These roles are intentionally visible in code for review. In particular,
`roles/storage.admin` and `roles/serviceusage.serviceUsageAdmin` are broad within
the single lab project. The service account does not receive Project IAM Admin;
changes to its IAM bindings or to the service account itself remain bootstrap
operator actions.

## Bootstrap Approach

The initial bootstrap follows this order:

1. Create the Terraform configuration and run static checks without connecting to the remote backend
2. Merge the reviewed code into `main` and pin the exact commit SHA to execute
3. Manually prepare the required APIs and the Terraform state and Cloud Build log buckets
4. Manually complete the Cloud Build GitHub connection and repository link
5. Import the APIs, Cloud Storage buckets, and Cloud Build repository into Terraform state in that order
6. Review the plan for each root before applying it
7. Verify the pull-request plan trigger and the `main` branch apply trigger

Record the detailed checks and evidence in the
[initial bootstrap runbook](bootstrap/README.md).

## Execution Locations and Identities

Record both the execution location and identity so that the following phases
are not confused.

| Phase | Execution location | Execution identity |
| --- | --- | --- |
| Initial bootstrap | Developer workstation (planned) | Personal Google account |
| Post-bootstrap plan and apply | Cloud Build | Terraform service account |

A GitHub repository linked to Cloud Build is a source reference. Linking the
repository does not place its files on a developer workstation or in Cloud
Shell.

## Version Control Policy

- Generate and commit `.terraform.lock.hcl` for each root module
- Do not commit `terraform.tfstate`, `.terraform/`, or saved plan files
- Do not commit populated `terraform.tfvars` or `backend.hcl` files
- Use `terraform.tfvars.example` and `backend.hcl.example` as shareable templates
- Do not create, store, or commit service account keys or other credentials

## Current Status

- [x] Create the GitHub repository
- [x] Document the bootstrap approach and planned structure
- [x] Create the Terraform roots and modules
- [x] Create the Cloud Build configuration
- [ ] Inspect the current personal GCP project state using read-only commands
- [ ] Run the bootstrap procedure
- [ ] Verify pull-request plan and `main` branch apply executions
