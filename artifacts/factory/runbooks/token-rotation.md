# Token Rotation Runbook

Date: 2026-05-08
Scope: runtime/API tokens referenced by generated OpenClaw specialist instances.

## Safety Rules

- Never print, commit, paste, or request raw token values.
- Rotate by updating Kubernetes Secrets or the external secret source, not by embedding values in manifests.
- Keep Git changes limited to references, metadata, policy, and runbook updates.
- Prefer short-lived or scoped tokens where providers support them.

## Rotation Preconditions

1. Identify the specialist namespace and Secret name referenced by the OpenClawInstance.
2. Identify which workloads consume the Secret through `envFrom`, mounted files, or external secret sync.
3. Confirm the new token has only the minimum required scope.
4. Prepare a rollback token or confirmed reissue process.
5. Schedule rotation during a low-risk window if restart is required.

## Rotation Procedure

1. Create the replacement token in the provider console or secret manager.
2. Update the Kubernetes Secret or external secret source without exposing the value in logs.
3. Trigger the consuming pod to reload the Secret:
   - prefer a controlled rollout/restart of only the affected specialist;
   - avoid broad namespace or cluster restarts.
4. Verify runtime behavior with minimal, non-sensitive checks:
   - provider health/API probe succeeds;
   - GitHub/API access still works if required;
   - no response body or token value is recorded.
5. Revoke the old token only after the new token is confirmed working.
6. Record rotation metadata:
   - namespace;
   - Secret name;
   - token/provider label, not value;
   - rotation time;
   - verifier;
   - follow-up date.

## Post-Rotation Checks

- Search committed workspace/artifacts for accidental secret material before opening a PR.
- Confirm Cilium egress policy remains unchanged unless the destination set intentionally changed.
- Attach Hubble or command-level evidence for allowed provider access and denied metadata egress.
- Update any rotation schedule or owner metadata.

## Rollback

If verification fails before revoking the old token, restore the previous Secret value from the approved secret manager, restart only the affected specialist, and preserve redacted logs for review. If the old token was already revoked, issue a new scoped token and repeat the procedure.
