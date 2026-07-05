# ============================================
# Phase 1-4 Validation — Regression Test Suite
# Run this to verify all scripts work
# ============================================

$ErrorActionPreference = "Continue"
$ScriptRoot = "D:\GoldenWings\11_AUTOMATION\PowerShell"
Set-Location $ScriptRoot

# Force reload the module
Import-Module .\Modules\Repository.Common.psm1 -Force

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "GW-EAF Validation Suite" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$Results = @()
$PassCount = 0
$FailCount = 0

function Run-Test {
    param(
        [string]$Name,
        [scriptblock]$Action
    )
    
    Write-Host "Running: $Name..." -ForegroundColor Yellow
    try {
        & $Action
        Write-Host "  ✅ PASS" -ForegroundColor Green
        return @{Name = $Name; Result = "PASS"}
    }
    catch {
        Write-Host "  ❌ FAIL: $($_.Exception.Message)" -ForegroundColor Red
        return @{Name = $Name; Result = "FAIL"; Error = $_.Exception.Message}
    }
}

# Test 1: Module Import
$Result = Run-Test -Name "Module Import" -Action {
    Import-Module .\Modules\Repository.Common.psm1 -Force
}
$Results += $Result

# Test 2: Export Count (55)
$Result = Run-Test -Name "Export Count (55)" -Action {
    $Count = (Get-Command -Module Repository.Common).Count
    if ($Count -ne 55) { throw "Expected 55, got $Count" }
}
$Results += $Result

# Test 3: Configuration Service
$Result = Run-Test -Name "Configuration Service" -Action {
    $Config = Get-RepositoryConfiguration
    if ($null -eq $Config) { throw "Configuration returned null" }
    if ($Config.Version -ne "2026.1") { throw "Version mismatch: $($Config.Version)" }
}
$Results += $Result

# Test 4: Logging Service (Legacy)
$Result = Run-Test -Name "Logging Service (Legacy)" -Action {
    Write-Success "Test success message"
    Write-WarningMessage "Test warning message"
    Write-Info "Test info message"
}
$Results += $Result

# Test 5: Logging Service (New)
$Result = Run-Test -Name "Logging Service (New)" -Action {
    Write-Log "Test log message" -Level Info
}
$Results += $Result

# Test 6: Repository Service
$Result = Run-Test -Name "Repository Service" -Action {
    $State = Get-RepositoryState
    if ($null -eq $State) { throw "State returned null" }
}
$Results += $Result

# Test 7: Document Service
$Result = Run-Test -Name "Document Service" -Action {
    $Docs = Get-Documents -ExcludeArchives -ExcludeBaseline
    if ($null -eq $Docs) { throw "Documents returned null" }
}
$Results += $Result

# Test 8: Validation Service
$Result = Run-Test -Name "Validation Service" -Action {
    $Structure = Test-RepositoryStructure
    if ($null -eq $Structure) { throw "Structure validation returned null" }
}
$Results += $Result

# Test 9: Hash Service
$Result = Run-Test -Name "Hash Service" -Action {
    $Hash = Get-RepositoryFileHash -Path "$ScriptRoot\Modules\Repository.Common.psm1"
    if ([string]::IsNullOrEmpty($Hash)) { throw "Hash returned empty" }
}
$Results += $Result

# Test 10: Manifest Service
$Result = Run-Test -Name "Manifest Service" -Action {
    $Data = Get-ManifestData
    if ($null -eq $Data) { throw "Manifest data returned null" }
}
$Results += $Result

# Test 11: Evidence Service
$Result = Run-Test -Name "Evidence Service" -Action {
    $Evidence = New-Evidence -Operation "Test" -Status "Success"
    if ($null -eq $Evidence) { throw "Evidence returned null" }
}
$Results += $Result

# Test 12: Report Service
$Result = Run-Test -Name "Report Service" -Action {
    $Report = New-Report -Type "Health"
    if ($null -eq $Report) { throw "Report returned null" }
}
$Results += $Result

# Test 13: Git Service
$Result = Run-Test -Name "Git Service" -Action {
    $Status = Get-GitStatus
    if ($null -eq $Status) { throw "GitStatus returned null" }
    if (-not $Status.IsGitRepository) { throw "Not a Git repository" }
}
$Results += $Result

# Test 14: Build-Baseline.ps1
$Result = Run-Test -Name "Build-Baseline.ps1" -Action {
    & .\Build-Baseline.ps1
}
$Results += $Result

# Test 15: Build-DocumentRegister.ps1
$Result = Run-Test -Name "Build-DocumentRegister.ps1" -Action {
    & .\Build-DocumentRegister.ps1
}
$Results += $Result

# Test 16: Build-Hashes.ps1
$Result = Run-Test -Name "Build-Hashes.ps1" -Action {
    & .\Build-Hashes.ps1
}
$Results += $Result

# Test 17: Generate-Manifest.ps1
$Result = Run-Test -Name "Generate-Manifest.ps1" -Action {
    & .\Generate-Manifest.ps1
}
$Results += $Result

# Test 18: Generate-RepositoryMetadata.ps1
$Result = Run-Test -Name "Generate-RepositoryMetadata.ps1" -Action {
    & .\Generate-RepositoryMetadata.ps1
}
$Results += $Result

# Test 19: Validate-DocumentNames.ps1
$Result = Run-Test -Name "Validate-DocumentNames.ps1" -Action {
    & .\Validate-DocumentNames.ps1
}
$Results += $Result

# Test 20: Validate-RepositoryStructure.ps1
$Result = Run-Test -Name "Validate-RepositoryStructure.ps1" -Action {
    & .\Validate-RepositoryStructure.ps1
}
$Results += $Result

# Test 21: Verify-Repository.ps1
$Result = Run-Test -Name "Verify-Repository.ps1" -Action {
    & .\Verify-Repository.ps1
}
$Results += $Result

# Test 22: Repository-Statistics.ps1
$Result = Run-Test -Name "Repository-Statistics.ps1" -Action {
    & .\Repository-Statistics.ps1
}
$Results += $Result

# Test 23: Release-Repository.ps1
$Result = Run-Test -Name "Release-Repository.ps1" -Action {
    & .\Release-Repository.ps1
}
$Results += $Result

# Test 24: Get-RepositoryStatus.ps1
$Result = Run-Test -Name "Get-RepositoryStatus.ps1" -Action {
    & .\Get-RepositoryStatus.ps1
}
$Results += $Result

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Validation Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$PassCount = ($Results | Where-Object { $_.Result -eq "PASS" }).Count
$FailCount = ($Results | Where-Object { $_.Result -eq "FAIL" }).Count

Write-Host "PASS: $PassCount" -ForegroundColor Green
Write-Host "FAIL: $FailCount" -ForegroundColor Red

if ($FailCount -eq 0) {
    Write-Host ""
    Write-Host "✅ ALL TESTS PASSED — GW-EAF v1.9 Ready for Lock" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "❌ TESTS FAILED — Review errors before locking" -ForegroundColor Red
    foreach ($Result in $Results | Where-Object { $_.Result -eq "FAIL" }) {
        Write-Host "  $($Result.Name): $($Result.Error)" -ForegroundColor Red
    }
}

Write-Host ""