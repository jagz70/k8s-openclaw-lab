# Factory Review Artifacts

These artifacts give `openclaw-factory` concrete material for heartbeat review.

## Contents

- `specialist-templates/openclaw-aci/SPECIALIST_TEMPLATE_REVIEW.md`
  - Inventory and review checklist for the first generated specialist pattern.
- `hubble-evidence/openclaw-egress-validation.md`
  - Current network evidence notes for allowed and denied egress behavior.

## Review Expectations

The factory should:

- Verify generated specialist manifests are namespace-scoped.
- Confirm no cluster-admin or unrestricted egress is introduced.
- Check that each specialist has memory seed files and a containment policy.
- Ask for Hubble CLI/UI flow evidence when command-level evidence is not enough.
