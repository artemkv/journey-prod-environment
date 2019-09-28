1. Create a bucket named "journey-250514-tf-state" to store the state.
2. Create a service account with the following roles:

    - Cloud Datastore Owner
    - Security Admin
    - Service Account Admin
    - Pub/Sub Admin
    - Storage Admin

3. Download a key file and save as key.json (gitingnored)

After that, run:

```
terraform init
terraform apply
terraform destroy
```