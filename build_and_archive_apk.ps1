# PowerShell script to build and automatically archive versioned APKs

# Extract version from pubspec.yaml
$pubspec = Get-Content "pubspec.yaml" -Raw
if ($pubspec -match "version:\s*([^\r\n]+)") {
    $version = $matches[1].Trim()
} else {
    $version = "unknown"
}

# Clean version name for filename safety
$cleanVersion = $version -replace "[:/\\]", "_"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Building APK for version: $version" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Run Flutter build
flutter build apk --release

if ($LASTEXITCODE -eq 0) {
    $targetDir = "apks"
    if (!(Test-Path $targetDir)) {
        New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
    }

    $sourceApk = "build\app\outputs\flutter-apk\app-release.apk"
    $destinationApk = "$targetDir\AquaVerify_v$cleanVersion.apk"

    Copy-Item $sourceApk $destinationApk -Force
    Write-Host "`n✔ APK successfully copied to: $destinationApk" -ForegroundColor Green
    Get-ChildItem $targetDir | Format-Table Name, Length, LastWriteTime
} else {
    Write-Host "`n✖ Build failed. Check errors above." -ForegroundColor Red
}
