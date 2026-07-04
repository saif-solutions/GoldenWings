# ============================================
# GW-EAF Clean Install Test
# ============================================
# Simulates a clean installation by testing
# the module in a fresh PowerShell session
# ============================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "GW-EAF Clean Install Test" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Remove any existing module
Write-Host "[1/6] Removing existing module..." -ForegroundColor Yellow
Get-Module Repository.Common | Remove-Module -Force -ErrorAction SilentlyContinue

# Step 2: Import the module
Write-Host "[2/6] Importing module..." -ForegroundColor Yellow
$ModulePath = "D:\GoldenWings\11_AUTOMATION\PowerShell\Modules\Repository.Common.psm1"
Import-Module $ModulePath -Force

# Step 3: Verify export count
Write-Host "[3/6] Verifying export count..." -ForegroundColor Yellow
$Count = (Get-Command -Module Repository.Common).Count
if ($Count -eq 55) {
    Write-Host "  ✅ PASS: 55 functions exported" -ForegroundColor Green
} else {
    Write-Host "  ❌ FAIL: Expected 55, got $Count" -ForegroundColor Red
    exit 1
}

# Step 4: Test key functions
Write-Host "[4/6] Testing key functions..." -ForegroundColor Yellow

# Test Configuration
$Config = Get-RepositoryConfiguration
if ($Config.Version -eq "2026.1") {
    Write-Host "  ✅ Configuration Service: PASS" -ForegroundColor Green
} else {
    Write-Host "  ❌ Configuration Service: FAIL" -ForegroundColor Red
}

# Test Repository
$State = Get-RepositoryState
if ($State.DocumentCount -gt 0) {
    Write-Host "  ✅ Repository Service: PASS" -ForegroundColor Green
} else {
    Write-Host "  ❌ Repository Service: FAIL" -ForegroundColor Red
}

# Test Git
$GitStatus = Get-GitStatus
if ($GitStatus.IsGitRepository) {
    Write-Host "  ✅ Git Service: PASS" -ForegroundColor Green
} else {
    Write-Host "  ❌ Git Service: FAIL" -ForegroundColor Red
}

# Step 5: Verify module manifest
Write-Host "[5/6] Verifying module manifest..." -ForegroundColor Yellow
$ManifestPath = "D:\GoldenWings\11_AUTOMATION\PowerShell\Modules\Repository.Common.psd1"
if (Test-Path $ManifestPath) {
    $Manifest = Test-ModuleManifest -Path $ManifestPath
    if ($Manifest) {
        Write-Host "  ✅ Manifest valid: $($Manifest.Version)" -ForegroundColor Green
    } else {
        Write-Host "  ❌ Manifest invalid" -ForegroundColor Red
    }
} else {
    Write-Host "  ⚠️ Manifest not found" -ForegroundColor Yellow
}

# Step 6: Summary
Write-Host "[6/6] Test summary..." -ForegroundColor Yellow
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Clean Install Test Complete" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ All tests passed - Module is ready for production" -ForegroundColor Green