# ============================================
# GW-EAF PowerShell Gallery Publication Script
# ============================================
# Usage: .\Publish-Module.ps1 -ApiKey $env:NUGET_API_KEY
# ============================================

param(
    [Parameter(Mandatory)]
    [string]$ApiKey,
    
    [string]$ModulePath = "D:\GoldenWings\11_AUTOMATION\PowerShell\Modules",
    
    [switch]$DryRun
)

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "GW-EAF PowerShell Gallery Publisher" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Navigate to module path
Set-Location $ModulePath

# Validate manifest exists
if (-not (Test-Path ".\Repository.Common.psd1")) {
    Write-Error "Module manifest not found at $ModulePath"
    exit 1
}

# Test module manifest
Write-Host "Validating module manifest..." -ForegroundColor Yellow
$Manifest = Test-ModuleManifest -Path .\Repository.Common.psd1
if (-not $Manifest) {
    Write-Error "Module manifest validation failed"
    exit 1
}
Write-Host "✅ Module manifest validated" -ForegroundColor Green

# Import module to test
Write-Host "Testing module import..." -ForegroundColor Yellow
Import-Module .\Repository.Common.psm1 -Force

# Verify export count
$Count = (Get-Command -Module Repository.Common).Count
if ($Count -ne 55) {
    Write-Error "Expected 55 functions, got $Count"
    exit 1
}
Write-Host "✅ Module import test passed ($Count functions)" -ForegroundColor Green

# Dry run
if ($DryRun) {
    Write-Host ""
    Write-Host "DRY RUN — No changes will be published" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Module: Repository.Common" -ForegroundColor Cyan
    Write-Host "Version: $($Manifest.Version)" -ForegroundColor Cyan
    Write-Host "Functions: $Count" -ForegroundColor Cyan
    Write-Host "Path: $ModulePath" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "To publish, run: .\Publish-Module.ps1 -ApiKey <your-api-key>" -ForegroundColor Yellow
    exit 0
}

# Publish to PowerShell Gallery
Write-Host ""
Write-Host "Publishing to PowerShell Gallery..." -ForegroundColor Yellow

try {
    Publish-Module `
        -Path .\ `
        -NuGetApiKey $ApiKey `
        -Repository PSGallery `
        -Verbose
    
    Write-Host ""
    Write-Host "✅ Module published successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Install with:" -ForegroundColor Cyan
    Write-Host "  Install-Module -Name GW-EAF -Force" -ForegroundColor White
    Write-Host ""
    Write-Host "Import with:" -ForegroundColor Cyan
    Write-Host "  Import-Module GW-EAF -Force" -ForegroundColor White
    Write-Host ""
}
catch {
    Write-Error "Failed to publish: $($_.Exception.Message)"
    exit 1
}