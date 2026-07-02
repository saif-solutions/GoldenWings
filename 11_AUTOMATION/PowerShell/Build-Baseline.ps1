Clear-Host

Write-Host ""
Write-Host "=========================================="
Write-Host "Golden Wings Enterprise Baseline Builder"
Write-Host "=========================================="
Write-Host ""

Write-Host "[1/7] Generating Manifest..."
& "$PSScriptRoot\Generate-Manifest.ps1"

Write-Host ""
Write-Host "[2/7] Building Document Register..."
& "$PSScriptRoot\Build-DocumentRegister.ps1"

Write-Host ""
Write-Host "[3/7] Building SHA256 Inventory..."
& "$PSScriptRoot\Build-Hashes.ps1"

Write-Host ""
Write-Host "[4/7] Validating Document Names..."
& "$PSScriptRoot\Validate-DocumentNames.ps1"

Write-Host ""
Write-Host "[5/7] Validating Repository Structure..."
& "$PSScriptRoot\Validate-RepositoryStructure.ps1"

Write-Host ""
Write-Host "[6/7] Verifying Repository..."
& "$PSScriptRoot\Verify-Repository.ps1"

Write-Host ""
Write-Host "[7/7] Building Repository Release..."
& "$PSScriptRoot\Release-Repository.ps1"

Write-Host ""
Write-Host "=========================================="
Write-Host "Golden Wings Baseline Completed"
Write-Host "=========================================="
Write-Host ""