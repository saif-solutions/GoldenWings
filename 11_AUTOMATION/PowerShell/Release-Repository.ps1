Clear-Host

Write-Host ""
Write-Host "======================================="
Write-Host "Golden Wings Repository Release"
Write-Host "======================================="
Write-Host ""

Write-Host "[1/4] Building Document Register..."
& "$PSScriptRoot\Build-DocumentRegister.ps1"

Write-Host ""
Write-Host "[2/4] Building SHA256 Inventory..."
& "$PSScriptRoot\Build-Hashes.ps1"

Write-Host ""
Write-Host "[3/4] Verifying Repository..."
& "$PSScriptRoot\Verify-Repository.ps1"

Write-Host ""
Write-Host "[4/4] Updating Release Archive..."

$BaselineFolder = "D:\GoldenWings\05_ENTERPRISE_BASELINE\GW-BASELINE-2026.1"
$ReleaseFolder  = "D:\GoldenWings\09_ARCHIVES\GW-Release-2026.1"

Copy-Item "$BaselineFolder\MANIFEST.md" "$ReleaseFolder" -Force
Copy-Item "$BaselineFolder\HASHES.txt" "$ReleaseFolder" -Force
Copy-Item "$BaselineFolder\SIGNATURES.txt" "$ReleaseFolder" -Force

Write-Host ""
Write-Host "======================================="
Write-Host "Repository Release Completed"
Write-Host "======================================="