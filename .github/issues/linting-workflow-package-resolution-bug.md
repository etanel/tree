# Linting workflow bug: package resolution + formatting failures in CI

## Summary
The CI linting step fails when running:

```bash
dart format --set-exit-if-changed .
```

Observed errors include repeated warnings:

- `Failed to resolve package URI "package:flutter_lints/flutter.yaml" in include.`

And formatting drift detection:

- `Formatted 245 files (9 changed)`
- `Error: Process completed with exit code 1.`

## Impact
- Pull requests cannot be merged reliably because lint/format checks fail.
- Developers get noisy package-resolution warnings that obscure actionable failures.

## Reproduction
1. Trigger CI workflow (`.github/workflows/ci.yml`) on PR or push.
2. Observe `Check formatting` step output.

## Root-cause hypotheses
1. Missing dev dependency for `flutter_lints` in root package when `analysis_options.yaml` includes `package:flutter_lints/flutter.yaml`.
2. Repository has formatting drift that causes `--set-exit-if-changed` to fail.

## Proposed fixes
1. Ensure root `pubspec.yaml` includes required dev dependencies:
   - `flutter_lints`
   - `flutter_test` (SDK)
2. Run `flutter pub get` before format/analyze/test in CI.
3. Decide formatting policy:
   - Enforce `--set-exit-if-changed` and require contributors to format before pushing, or
   - Run formatter in a dedicated bot workflow that commits formatting updates.

## Acceptance criteria
- No package-resolution warnings for `analysis_options.yaml` in CI.
- `dart format --set-exit-if-changed .` passes on a clean branch.
- `flutter analyze` and `flutter test` run successfully in CI.
