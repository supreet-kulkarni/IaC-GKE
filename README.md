# GKE Deployment with GitHub Actions (OIDC + Terraform + GitOp
This repository demonstrates a secure, production-ready CI/CD pipeline to provision and deploy applications on `Google Kubernetes Engine` using GitHub Actions, Terraform, and Argo CD — without using any long-lived credentials.

## Key Features
- No Service Account Keys (OIDC-based authentication)
- Secure access using Workload Identity Federation
- Infrastructure provisioning using Terraform
- Application deployment via GitOps (Argo CD)
- Environment-based configuration (dev, prod)
- Clean separation of secrets.

## OIDC Setup (Workload Identity Federation)

This setup allows `GitHub Actions` to securely authenticate with `Google Cloud Platform` without storing any credentials.

1. **Create Workload Identity Pool**
```
gcloud iam workload-identity-pools create "github-pool" \
 --project=PROJECT_ID  --location="global"   --display-name="GitHub Pool"
```

`PROJECT_ID`
  Add the GCP project Id

2. **Create OIDC Provider**

```
gcloud iam workload-identity-pools providers create-oidc "github-provider"\
 --project=PROJECT_ID  --location="global" --workload-identity-pool="github-pool"\
  --display-name="github provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository,attribute.job_workflow_ref=assertion.job_workflow_ref" \
  --issuer-uri="https://token.actions.githubusercontent.com" 
  --attribute-condition="attribute.repository==YOUR_ORG/YOUR_REPO"
  ```
  `PROJECT_ID`
    Add the GCP project Id

  `YOUR_ORG`
    Add the GitHub organization name 

  `YOUR_REPO`
    Add the GitHub repository name

  3. **Create Service Account**
  ```
  gcloud iam service-accounts create githubactions-sa   --project=PROJECT_ID
  ```

`PROJECT_ID`
  Add the GCP project Id

  4. **Grant Required Roles**
```
gcloud projects add-iam-policy-binding PROJECT_ID \
--member="serviceAccount:githubactions-sa@PROJECT_ID.iam.gserviceaccount.com"\
--role="roles/editor"
```

```
gcloud iam service-accounts add-iam-policy-binding \
  terraform-sa@PROJECT_ID.iam.gserviceaccount.com \
  --role="roles/iam.serviceAccountTokenCreator" \
  --member="serviceAccount:githubactions-sa@PROJECT_ID.iam.gserviceaccount.com"
```

5. **Allow GitHub to Impersonate Service Account**
```
gcloud iam service-accounts add-iam-policy-binding  githubactions-sa@PROJECT_ID.iam.gserviceaccount.com --role="roles/iam.workloadIdentityUser"  --member="principalSet://iam.googleapis.com/projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/github-pool/attribute.repository/YOUR_ORG/YOUR_REPO"
```

`PROJECT_ID`
  Add the GCP project Id

`PROJECT_NUMBER`
  Add the GCP project number


`YOUR_ORG`
  Add the GitHub organization name 

`YOUR_REPO`
  Add the GitHub repository name
  
## GitHub Actions Configuration
- Create the new Environment and give the `dev` (settings->environments->new environment)
- create the below Secrets and variables

**Secrets**
| Name             | Description                         |
| ---------------- | ----------------------------------- |
| `WIF_PROVIDER`   | Workload Identity Provider resource <br> projects/PROJECT_NUMBER/locations/global/workloadIdentityPools POOL_NAME/providers/PROVIDER_NAME |
| `GCP_SA_EMAIL`   | Service Account email               |
| `GCP_PROJECT_ID` | GCP Project ID                      |

**Variables**
| Variable           | Description          |
| ------------------ | --------------       |
| `GKE_CLUSTER`      | GKE cluster name     |
| `LOCATION`         | GKE cluster location |     



## Conclusion

This setup demonstrates a modern DevOps + GitOps workflow combining:

- Google Cloud Platform
- GitHub Actions
- Argo CD
- Terraform


