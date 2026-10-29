# terraform-aws-secure-webapp

🚧 **Work in progress**

Terraform project deploying OWASP Juice Shop (an intentionally vulnerable app) on AWS behind hardened infrastructure, with controls mapped to NIST SP 800-53.

## Done
- Private subnet EC2 with no public IP, behind an ALB (SC-7)
- ALB restricted to a single admin IP; app reachable only from the ALB security group (SC-7, AC-4)
- No SSH; access via SSM Session Manager (AC-17)
- Least-privilege IAM role (AC-6)
- IMDSv2 enforced (CM-6)
- Encrypted EBS volume (SC-28)

## In Progress
- HTTPS/TLS on the ALB (SC-8)
- AWS WAF
- GuardDuty + Security Hub
- VPC Flow Logs + CloudTrail (AU-2)
- CI security scanning (tfsec/Checkov)

## Usage
```bash
terraform init
terraform apply -var="my_ip=<YOUR_IP>/32"
terraform destroy -var="my_ip=<YOUR_IP>/32"
```

⚠️ Juice Shop is deliberately vulnerable. Keep access restricted.
