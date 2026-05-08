# Specialist PVC Backup / Restore Runbook

Date: 2026-05-08
Scope: generated OpenClaw specialist instances such as `openclaw-aci`.

## Safety Rules

- Propose infrastructure changes through Git PRs.
- Never copy, print, commit, or request raw secrets.
- Treat workspace PVC contents as sensitive operational state.
- Prefer namespace-scoped access and avoid cluster-wide privileges.
- Capture evidence and checksums as artifacts, not secret data.

## Backup Preconditions

1. Identify the specialist namespace, for example `openclaw-aci`.
2. Identify the workspace PVC mounted by the specialist pod.
3. Confirm the specialist pod is healthy or intentionally quiesced.
4. Confirm the backup destination is encrypted and access-controlled.
5. Record the source namespace, PVC name, timestamp, and operator.

## Backup Procedure

1. Quiesce writes where practical:
   - pause user traffic or scheduled jobs for the specialist;
   - confirm no long-running write-heavy task is active.
2. Create a Kubernetes `Job` in the specialist namespace that mounts the workspace PVC read-only when supported.
3. Stream an archive from the mounted workspace to the approved backup target.
4. Exclude transient caches when they are safe to rebuild.
5. Generate a checksum manifest for the archive.
6. Store backup metadata separately from the archive:
   - namespace;
   - PVC name;
   - OpenClawInstance name;
   - image/version if known;
   - backup timestamp;
   - checksum;
   - restore test status.

## Restore Procedure

1. Restore into a non-production namespace first.
2. Create or bind a replacement PVC with the expected access mode and size.
3. Run a restore `Job` that mounts the target PVC and extracts the archive.
4. Verify ownership, permissions, and expected workspace files.
5. Start the specialist against the restored PVC.
6. Run smoke checks:
   - OpenClaw instance starts;
   - workspace files are readable;
   - memory/context files load;
   - no raw secrets are present in committed files;
   - Cilium policy still denies metadata endpoints.
7. Promote to production only after human review.

## Validation Evidence To Attach

- Backup job manifest or PR link.
- Backup timestamp and checksum manifest.
- Restore test namespace and result.
- Smoke-check output with secrets redacted.
- Any Hubble flow evidence showing restored specialist egress remains contained.

## Rollback

If restore validation fails, keep the original PVC unchanged, scale the restored instance down, preserve logs for review, and open a follow-up issue/PR with the failure evidence.
