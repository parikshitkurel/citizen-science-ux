# APK Releases & Versions Directory

This folder contains versioned builds of the **AquaVerify** Android application.

| File | Version | Build Date | Description |
|---|---|---|---|
| [`AquaVerify_v1.0.0+1.apk`](file:///c:/Users/Parikshit%20Kurel/Documents/Citizen%20Science%20UX/apks/AquaVerify_v1.0.0+1.apk) | `1.0.0+1` | September 30, 2026 | Initial Release Build |

---

### How to Build & Archive a New Version

1. Update the `version` field in [`pubspec.yaml`](file:///c:/Users/Parikshit%20Kurel/Documents/Citizen%20Science%20UX/pubspec.yaml) (e.g. `version: 1.0.1+2`).
2. Run the build script in PowerShell:
   ```powershell
   .\build_and_archive_apk.ps1
   ```
   *The script will automatically compile the release APK and place a version-tagged copy directly into this `apks/` directory.*
