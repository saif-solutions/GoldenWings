Import-Module "$PSScriptRoot\Modules\Repository.Common.psm1" -Force

# ==========================================
# Golden Wings Enterprise Repository
# Verify-Repository.ps1
# Repository Structure Verification
# ==========================================

$RepositoryRoot = Get-RepositoryRoot

$RequiredFolders = @(
    "00_README",
    "01_GOVERNANCE",
    "02_CONSTITUTIONAL_FRAMEWORK",
    "03_ENTERPRISE_ARCHITECTURE",
    "04_ENTERPRISE_ASSURANCE",
    "05_ENTERPRISE_BASELINE",
    "06_GOVERNANCE_RECORDS",
    "07_TEMPLATES",
    "08_EVIDENCE",
    "09_ARCHIVES",
    "10_MACHINE_READABLE",
    "11_AUTOMATION",
    "99_REFERENCE"
)

Write-Host ""
Write-Host "==========================================="
Write-Host "Golden Wings Repository Verification"
Write-Host "==========================================="
Write-Host ""

foreach ($Folder in $RequiredFolders) {
    $Path = Join-Path $RepositoryRoot $Folder
    if (Test-Path $Path) {
        Write-Host "[PASS] $Folder"
    } else {
        Write-Host "[FAIL] $Folder"
    }
}

Write-Host ""
Write-Host "Checking Required Files..."
Write-Host ""

$RequiredFiles = @(
    "00_README\README.md",
    "00_README\CHANGELOG.md",
    "00_README\DOCUMENT_REGISTER.csv",
    (Join-Path (Get-BaselineFolder) "MANIFEST.md"),
    (Join-Path (Get-ReleaseFolder) "MANIFEST.md")
)

foreach ($File in $RequiredFiles) {
    if (Test-Path $File) {
        Write-Host "[PASS] $File"
    } else {
        Write-Host "[FAIL] $File"
    }
}

Write-Host ""
Write-Host "Verification Complete."