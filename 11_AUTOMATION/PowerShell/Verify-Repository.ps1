Import-Module "$PSScriptRoot\Modules\Repository.Common.psm1" -Force

# ==========================================
# Golden Wings Enterprise Repository
# Verify-Repository.ps1
# Repository Structure Verification
# ==========================================

Clear-Host

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

Write-Host "Checking Required Folders..." -ForegroundColor Yellow
Write-Host ""

foreach ($Folder in $RequiredFolders) {
    $Path = Join-Path $RepositoryRoot $Folder
    if (Test-Path $Path) {
        Write-Host "[PASS] $Folder" -ForegroundColor Green
    } else {
        Write-Host "[FAIL] $Folder" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Checking Required Files..." -ForegroundColor Yellow
Write-Host ""

# Build file paths correctly - using full paths directly
$RequiredFiles = @(
    # These are relative paths - join with repository root
    "00_README\README.md",
    "00_README\CHANGELOG.md",
    "00_README\DOCUMENT_REGISTER.csv"
)

foreach ($File in $RequiredFiles) {
    $Path = Join-Path $RepositoryRoot $File
    if (Test-Path $Path) {
        Write-Host "[PASS] $File" -ForegroundColor Green
    } else {
        Write-Host "[FAIL] $File" -ForegroundColor Red
        Write-Host "      Expected: $Path" -ForegroundColor Gray
    }
}

# These are already full paths - use them directly
$FullPathFiles = @(
    (Join-Path (Get-BaselineFolder) "MANIFEST.md"),
    (Join-Path (Get-ReleaseFolder) "MANIFEST.md")
)

foreach ($File in $FullPathFiles) {
    if (Test-Path $File) {
        Write-Host "[PASS] $File" -ForegroundColor Green
    } else {
        Write-Host "[FAIL] $File" -ForegroundColor Red
        Write-Host "      Expected: $File" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "Verification Complete."