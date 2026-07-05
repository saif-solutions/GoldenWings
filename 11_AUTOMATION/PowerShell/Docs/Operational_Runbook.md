# GW-EAF Operational Runbook
## Golden Wings Enterprise Automation Framework — v1.9.0

---

## 1. Purpose

This runbook provides day-to-day operational guidance for the GW-EAF framework.

---

## 2. Daily Operations

### 2.1 Check Repository Health

```powershell
# Get repository status
.\Get-RepositoryStatus.ps1

# Check Git status
Get-GitStatus

### 2.2 Verify Integrity

```powershell
# Verify repository structure
.\Verify-Repository.ps1

# Check hashes
.\Build-Hashes.ps1

### 2.3 Review Logs

| Log | Location | Purpose |
|-----|----------|---------|
| Build logs | Console output | Build progress |
| Test logs | `08_EVIDENCE/Reports/` | Test results |
| Validation logs | `08_EVIDENCE/Verification/` | Validation status |

---

## 3. Weekly Operations

### 3.1 Run Full Validation

```powershell
# Run all regression tests
.\Test-Phase1.ps1

# Run Pester tests
Invoke-Pester -Path .\Tests\Repository.Common.Tests.ps1

# Run performance tests
Invoke-Pester -Path .\Tests\Performance.Tests.ps1

# Run clean install test
.\Tests\CleanInstall.Tests.ps1

### 3.2 Generate Reports

```powershell
# Generate health report
.\Generate-Report.ps1

# Generate evidence
.\Generate-Evidence.ps1

# Generate manifest
.\Generate-Manifest.ps1

### 3.3 Update Dashboards

| Dashboard | Location | Update Frequency |
|-----------|----------|------------------|
| RD — Repository Dashboard | `04_ENTERPRISE_ASSURANCE/` | Weekly |
| RE — Governance Dashboard | `04_ENTERPRISE_ASSURANCE/` | Weekly |

---

## 4. Monthly Operations

### 4.1 Governance Review

| Register | Action |
|----------|--------|
| RF — Change Request | Review and update |
| RH — Decision Register | Review and update |
| RG — Risk Register | Review and update |
| RJ — Continuous Improvement | Review and update |

### 4.2 Security Review

```powershell
# Check for vulnerabilities
Get-GitStatus

# Verify hashes
.\Build-Hashes.ps1

### 4.3 Documentation Review

| Document | Action |
|----------|--------|
| API Reference | Verify completeness |
| Release Notes | Update if needed |
| Developer Handbook | Verify accuracy |
| Maintainer Guide | Verify accuracy |
| Operational Runbook | Verify accuracy |

---

## 5. Build Operations

### 5.1 Full Build

```powershell
# Run complete build
.\Build-Baseline.ps1

### 5.2 Specific Builds

| Build Type | Command | Output |
|------------|---------|--------|
| Baseline | `.\Build-Baseline.ps1` | Baseline package |
| Document Register | `.\Build-DocumentRegister.ps1` | `DOCUMENT_REGISTER.csv` |
| Hashes | `.\Build-Hashes.ps1` | `HASHES_2026.1.csv` |
| Manifest | `.\Generate-Manifest.ps1` | `MANIFEST.md` |
| Evidence | `.\Generate-Evidence.ps1` | Evidence JSON |
| Report | `.\Generate-Report.ps1` | Health report |

---

## 6. Release Operations

### 6.1 Pre-Release Checklist

| Item | Status |
|------|--------|
| All tests pass | ☐ |
| Documentation updated | ☐ |
| Version numbers updated | ☐ |
| Release notes updated | ☐ |
| Registers updated | ☐ |

### 6.2 Release Commands

```powershell
# 1. Validate
.\Test-Phase1.ps1

# 2. Build
.\Build-Baseline.ps1

# 3. Create commit
git add .
git commit -m "Release v1.9.0"

# 4. Create tag
git tag Repository.Common-v1.9.0

# 5. Push
git push origin main
git push origin Repository.Common-v1.9.0

# 6. Create release archive
# (See Maintainer Guide for archive creation)

## 7. Validation Operations

### 7.1 Validation Commands

```powershell
# Complete validation suite
.\Test-Phase1.ps1

# Individual validations
.\Validate-DocumentNames.ps1
.\Validate-RepositoryStructure.ps1
.\Verify-Repository.ps1

### 7.2 Expected Results

| Test | Expected |
|------|----------|
| Document names | All comply |
| Repository structure | All folders exist |
| Required files | All present |
| Module import | Success |
| Export count | 55 |

---

## 8. Backup Operations

### 8.1 Backup Commands

```powershell
# Backup repository
Copy-Item -Path "D:\GoldenWings" -Destination "D:\Backups\GoldenWings_$(Get-Date -Format 'yyyyMMdd')" -Recurse

# Backup Git metadata
cd D:\GoldenWings
git bundle create "D:\Backups\goldenwings_$(Get-Date -Format 'yyyyMMdd').bundle" --all

### 8.2 Backup Schedule

| Backup Type | Frequency | Location |
|-------------|-----------|----------|
| Working copy | Daily | Local backup |
| Git bundle | Weekly | Local backup |
| Release archive | Monthly | Archive folder |
| Offsite backup | Monthly | External storage |

---

## 9. Troubleshooting Commands

### 9.1 Common Issues

| Issue | Diagnostic | Resolution |
|-------|------------|------------|
| Module import fails | `Test-Path .\Modules\Repository.Common.psm1` | Check file exists |
| Tests fail | `$ErrorActionPreference = "Continue"` | Run with verbose output |
| Build fails | `.\Build-Baseline.ps1 -Verbose` | Check error details |
| Git issues | `git status` | Check repository state |

### 9.2 Quick Diagnostic

```powershell
# Diagnostic script
Write-Host "=== GW-EAF Diagnostic ===" -ForegroundColor Cyan

# Check module
if (Test-Path .\Modules\Repository.Common.psm1) {
    Write-Host "✅ Module exists" -ForegroundColor Green
} else {
    Write-Host "❌ Module missing" -ForegroundColor Red
}

# Check export count
Import-Module .\Modules\Repository.Common.psm1 -Force
$Count = (Get-Command -Module Repository.Common).Count
if ($Count -eq 55) {
    Write-Host "✅ Export count: $Count" -ForegroundColor Green
} else {
    Write-Host "❌ Export count: $Count (expected 55)" -ForegroundColor Red
}

# Check Git
$Status = Get-GitStatus
if ($Status.IsGitRepository) {
    Write-Host "✅ Git repository: $($Status.Branch)" -ForegroundColor Green
} else {
    Write-Host "❌ Not a Git repository" -ForegroundColor Red
}

## 10. Emergency Procedures

### 10.1 Rollback

```powershell
# Rollback to previous tag
git checkout Repository.Common-v1.8

# Or rollback to previous commit
git checkout {previous-commit-hash}

### 10.2 Recovery

```powershell
# Restore from backup
Copy-Item -Path "D:\Backups\GoldenWings_latest" -Destination "D:\GoldenWings" -Recurse

# Restore Git bundle
git clone "D:\Backups\goldenwings_latest.bundle" "D:\GoldenWings"

# Verify restoration
.\Verify-Repository.ps1

## 11. Contact Information

| Role | Responsibility | Escalation Path |
|------|----------------|-----------------|
| Maintainer | Daily operations | Tech Lead |
| Tech Lead | Technical issues | CTO |
| CTO | Major issues | CEO |

---

## 12. Version Information

| Property | Value |
|----------|-------|
| Framework Version | 1.9.0 |
| Baseline | GW-BASELINE-2026.1 |
| Git Tag | Repository.Common-v1.9.0 |
| Exported Functions | 55 |
| Services | 10 |
| Status | ✅ Certified — Production Ready |

---

**END OF DOCUMENT**

> *"GW-EAF v1.9.0 is complete, certified, and ready for production use."*