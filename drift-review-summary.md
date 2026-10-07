# Terraform Drift Review Summary

**Full Name:** Felix Emeka Nwobodo

**Date:** 07/10/2026

## 1. Change Introduced

A manual tag (Key: TestDrift, Value: manual-change) was added directly to the
book-review-web-sg security group via the AWS Console, bypassing Terraform.
This was true infrastructure drift, not a Terraform configuration change — the
.tf files were never modified.

## 2. Evidence Collected

terraform plan -detailed-exitcode returned exit code 2, and the resulting plan
JSON showed one in-place update to module.security.aws_security_group.web,
removing the untracked TestDrift tag from tags and tags_all. No resources
were added or destroyed — Plan: 0 to add, 1 to change, 0 to destroy.

## 3. Risk Assessment

The Bash check and Claude Code both classified the pending change itself as
low-risk — a tag-only correction with no impact on security group rules,
ports, or ingress/egress CIDRs. However, the same policy scan flagged a
pre-existing SSH-from-anywhere rule (0.0.0.0/0 on port 22) on the web tier —
a real but unrelated, already-accepted exposure that caused the overall
report to show FAIL. Claude correctly distinguished this pre-existing
exposure from the pending change itself.

## 4. Human-Approved Action

I reviewed terraform plan directly in the terminal, confirmed it only removed
the drift tag, and ran terraform apply manually (outside Claude Code and
outside the drift-check script) to reconcile the infrastructure back to
match the Terraform configuration. Apply completed with 0 added, 1 changed,
0 destroyed.

## 5. Verification

A second terraform plan after the apply returned "No changes." A final
/tf-drift-review run confirmed Overall Status: HEALTHY, with all 3 checks
passing and no WARN or FAIL results.

## 6. Safety Decision

Claude was allowed to gather evidence and analyze it because that work is
low-risk and reversible — it only reads state via terraform plan and show.
Executing terraform apply is irreversible and can affect live infrastructure,
so that action was reserved for me. This was enforced by two independent
layers: CLAUDE.md's safety rules (which shaped Claude's behavior) and a
PreToolUse hook (a deterministic gate that blocks any terraform apply attempt
while the drift report shows Overall Status: FAIL, regardless of Claude's
own reasoning).

## 7. Agentic Loop Mapping

Gather: tf-drift-check.sh ran terraform plan -detailed-exitcode, converted
the plan to JSON, and checked for destructive actions and open ingress rules.

Analyze: the /tf-drift-review Skill read the generated report and JSON,
explained the drift in plain language, and distinguished the low-risk tag
change from the unrelated pre-existing SSH exposure.

Human Act: I reviewed terraform plan myself and ran terraform apply manually
after confirming the change was safe and expected.

Verify: a second /tf-drift-review run confirmed the environment returned to
HEALTHY, with no pending changes remaining.
