
# Project Overview
 
This project provisions the Book Review App infrastructure using Terraform.
 
A read-only Bash workflow checks the Terraform plan for destructive changes and unsafe ingress rules before infrastructure changes are approved.
 
# Review Workflow
 
Always follow this order:
 
1. Gather evidence using Terraform plan data.
2. Analyze the evidence for destructive actions and unsafe ingress rules.
3. Present the findings to the human operator.
4. The human reviews and performs any approved infrastructure-changing action.
5. Verify the infrastructure again after the action.
 
# Safety Rules
 
- Never run terraform apply automatically.
- Never run terraform destroy.
- Never use -auto-approve.
- Never edit Terraform files while performing the drift review.
- Use the generated drift report and Terraform plan JSON as the primary evidence.
- Recommend whether an apply appears safe based on the evidence, but never execute it.
- Do not claim a change is safe unless the available evidence supports that conclusion.
 
# Output Rules
 
When analyzing a Terraform drift report, show:
 
1. Overall status.
2. Terraform detailed exit code and its meaning.
3. Any destructive resource changes.
4. Any security rule exposing access through 0.0.0.0/0 or *.
5. A plain-language risk assessment.
6. A recommended next step for the human operator