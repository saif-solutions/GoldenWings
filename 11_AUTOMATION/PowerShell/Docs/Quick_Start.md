# GW-EAF Quick Start Guide
## Golden Wings Enterprise Automation Framework — v1.9.0

### One Page — Get Started in 5 Minutes

---

## 1. Navigate to the Repository

```powershell
cd D:\GoldenWings


## 2. Import the Module
```powershell
Import-Module .\11_AUTOMATION\PowerShell\Modules\Repository.Common.psm1 -Force

## 3. Check the Module

```powershell
Get-Command -Module Repository.Common

**Expected:** 55 functions

---

## 4. Run Validation

```powershell
cd D:\GoldenWings\11_AUTOMATION\PowerShell
.\Test-Phase1.ps1

**Expected:** All tests pass

---

## 5. Build the Repository

```powershell
.\Build-Baseline.ps1

**Expected:** Complete baseline generated

---

## 6. Check Status

```powershell
.\Get-RepositoryStatus.ps1

**Expected:** Repository status displayed

---

## Quick Reference

| Command | Description |
|---------|-------------|
| `.\Build-Baseline.ps1` | Build complete baseline |
| `.\Test-Phase1.ps1` | Run all validation tests |
| `.\Get-RepositoryStatus.ps1` | Check repository status |
| `.\Release-Repository.ps1` | Create release |
| `.\Generate-Report.ps1` | Generate health report |
| `.\Generate-Evidence.ps1` | Generate evidence |
| `.\Generate-Manifest.ps1` | Generate manifest |

---

## Common Tasks

### Check Module Health

```powershell
# Quick health check
Get-RepositoryHealth

### Generate Document Register

```powershell
.\Build-DocumentRegister.ps1

### Validate Document Names

```powershell
.\Validate-DocumentNames.ps1

### Validate Repository Structure

```powershell
.\Validate-RepositoryStructure.ps1

### Verify Repository

```powershell
.\Verify-Repository.ps1

## Need Help?

| Resource | Location |
|----------|----------|
| API Reference | `Docs/GW-EAF-API-Reference.md` |
| Developer Handbook | `Docs/Developer_Handbook.md` |
| Maintainer Guide | `Docs/Maintainer_Guide.md` |
| Operational Runbook | `Docs/Operational_Runbook.md` |
| Architecture Decision Index | `04_ENTERPRISE_ASSURANCE/ADR_Index.md` |

---

## Version Information

| Property | Value |
|----------|-------|
| Framework Version | 1.9.0 |
| Exported Functions | 55 |
| Services | 10 |
| Status | ✅ Certified — Production Ready |

---

**END OF DOCUMENT**

> *"GW-EAF v1.9.0 is complete, certified, and ready for production use."*