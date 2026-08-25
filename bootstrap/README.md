# Initial Bootstrap Runbook

This document records the procedure, execution identities, and evidence for
introducing Terraform and Cloud Build to a personal GCP project for the first
time.

This directory is not a Terraform root. It separates one-time preparation,
imports, plans, and applies from the Cloud Build configuration used for normal
operations.

## Assumptions and Exclusions

The following prerequisites apply:

- One personal GCP project already exists
- A billing account is attached to the project
- A private repository exists under the personal GitHub account
- `gcloud`, Terraform, and Git are available on the developer workstation
- Only personal accounts are used for GCP and GitHub operations

Do not copy the following into this lab:

- Organization project IDs, service accounts, or bucket names
- Organization IAM, Organization Policy, or credentials
- Organization-specific Cloud Build configuration or Secret Manager values

## Bootstrap Values

Confirm these values before execution. Do not record secrets in this table or
commit them to Git.

| Item | Value | Verification method |
| --- | --- | --- |
| GCP project ID | Not set | GCP Console / `gcloud config get-value project` |
| GCP project number | Not set | GCP Console / `gcloud projects describe` |
| Region | Not set | Terraform and Cloud Build configuration |
| GitHub repository | `irmnt/gcp-terraform-bootstrap-lab` | GitHub |
| Cloud Build connection name | Not set | Cloud Build repositories |
| Linked repository name | Not set | Cloud Build repositories |
| Terraform service account | Not set | IAM |
| Terraform state bucket | Not set | Cloud Storage |
| Cloud Build log bucket | Not set | Cloud Storage |
| Target commit SHA | Not set | `git rev-parse HEAD` |

## Management Boundary

Keep resources that must be created manually during the initial bootstrap
separate from resources ultimately managed by Terraform.

| Resource | Initial creation method | Post-bootstrap management |
| --- | --- | --- |
| GCP project and billing | GCP Console | Outside Terraform |
| Required APIs | GCP Console or `gcloud` | Import into `env/lab/api` |
| Terraform state bucket | GCP Console or `gcloud` | Import into `env/lab/cloudstorage` |
| Cloud Build log bucket | GCP Console or `gcloud` | Import into `env/lab/cloudstorage` |
| GitHub host connection | Cloud Build and GitHub authorization screens | Outside Terraform |
| Linked repository | Cloud Build repositories | Import into `env/lab/cloudbuild` |
| Build service account and IAM | Apply initially as the developer account | Manage in `env/lab/cloudbuild` |
| Plan and apply triggers | Terraform apply | Manage in `env/lab/cloudbuild` |

The GitHub host connection includes browser-based GitHub App authorization, so
this lab treats it as a manual bootstrap prerequisite. Terraform takes over the
linked repository after it is imported.

## Procedure

### 1. Prepare the Code

Create the Terraform roots and modules, then run the following static checks
before connecting to remote state:

```text
terraform fmt -check -diff
terraform init -backend=false
terraform validate
```

Do not run imports, plans, or applies against shared state at this stage.

### 2. Pin the Execution Target

Merge the reviewed code into `main` and check out the target commit on the
developer workstation. Immediately before execution, verify the commit with
`git rev-parse HEAD` and record the SHA under Bootstrap Values.

### 3. Prepare Bootstrap Prerequisites

Enable the required APIs and create the Terraform state and Cloud Build log
buckets. Enable Object Versioning and uniform bucket-level access on the
Terraform state bucket.

Next, create the Cloud Build GitHub host connection and link this repository.
Use the same region for the connection, linked repository, and triggers.

### 4. Initialize the Remote Backend

Use the same Terraform state bucket for each root, with a distinct prefix for
each state:

```text
terraform/lab/api
terraform/lab/cloudstorage
terraform/lab/cloudbuild
```

After initializing the backend, run `terraform state list` and confirm that the
target resource is absent before importing it. Do not re-import a resource that
is already registered in state.

### 5. Import Existing Resources

Preserve the following order:

1. Import the manually enabled APIs into `env/lab/api`
2. Import the Terraform state and log buckets into `env/lab/cloudstorage`
3. Review a plan for each root, including the refresh results
4. Import the linked repository into `env/lab/cloudbuild`
5. Review the Cloud Build root plan and then apply it

Add import IDs and Terraform resource addresses to this runbook after the
resource definitions are finalized. Do not execute imports using guessed IDs.

### 6. Verify Cloud Build

Verify the following behavior for the Terraform-managed triggers:

- A pull request starts `cloudbuild/plan.yaml`
- A push to `main` starts `cloudbuild/apply.yaml`
- The build runs as the configured Terraform service account
- The API, Cloud Storage, and Cloud Build order is preserved
- The terminal result of each Terraform plan or apply is confirmed

A successful HTTP response or started build is not sufficient evidence. Confirm
the final Terraform result for every component.

## Stop Conditions

Stop and verify the configuration and execution target if any of the following
conditions occur:

- The active `gcloud` project is not the intended personal project
- Git `HEAD` does not match the recorded target commit SHA
- GCP or GitHub is authenticated with an organization account
- The import target is already registered in Terraform state
- The plan contains an unexpected deletion, replacement, or IAM change
- Cloud Build runs as an unexpected service account

## Execution Log

During execution, record declared Terraform configuration separately from the
observed live GCP state.

| Date and time | Execution location | Execution identity | Operation | Result and evidence |
| --- | --- | --- | --- | --- |
| Not run | - | - | - | - |
