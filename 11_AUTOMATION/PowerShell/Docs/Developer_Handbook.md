# GW-EAF Developer Handbook

## Golden Wings Enterprise Automation Framework — v1.9.0

---

## 1. Overview

The Golden Wings Enterprise Automation Framework (GW-EAF) is a layered PowerShell framework that provides reusable automation services for repository management.

**Key Facts:**
- **10 Services**
- **55 Exported Functions**
- **Version:** 1.9.0
- **Status:** ✅ Certified — Production Ready

---

## 2. Module Layout
# 11_AUTOMATION/PowerShell/
│
├── Modules/
│   ├── Repository.Common.psm1 # Main framework module
│   └── Repository.Common.psd1 # Module manifest
│
├── Tests/
│   ├── Repository.Common.Tests.ps1 # Pester tests
│   ├── Performance.Tests.ps1 # Performance tests
│   └── CleanInstall.Tests.ps1 # Clean install tests
│
├── Docs/
│   ├── GW-EAF-API-Reference.md # Complete API reference
│   ├── RELEASE_NOTES_v1.9.md # Release notes
│   ├── Developer_Handbook.md # This document
│   ├── Maintainer_Guide.md # Maintenance guide
│   ├── Operational_Runbook.md # Operations guide
│   └── Quick_Start.md # Quick start guide
│
└── [Orchestration Scripts]
    ├── Build-Baseline.ps1
    ├── Build-DocumentRegister.ps1
    ├── Build-Hashes.ps1
    ├── Generate-Manifest.ps1
    ├── Generate-RepositoryMetadata.ps1
    ├── Get-RepositoryStatus.ps1
    ├── Release-Repository.ps1
    ├── Repository-Statistics.ps1
    ├── Validate-DocumentNames.ps1
    ├── Validate-RepositoryStructure.ps1
    └── Verify-Repository.ps1

---

## 3. Service Boundaries

| Service | Functions | Description |
|---------|-----------|-------------|
| **Configuration** | 7 | Centralized repository configuration |
| **Logging** | 8 | Structured logging with levels |
| **Orchestration** | 1 | Build step framework |
| **Utilities** | 4 | File and path utilities |
| **Timing** | 2 | Build timing |
| **Statistics** | 1 | Repository statistics |
| **Release** | 2 | Release helpers |
| **Repository** | 4 | Repository discovery and state |
| **Document** | 4 | Document metadata management |
| **Validation** | 3 | Validation framework |
| **Hash** | 3 | Hash generation and verification |
| **Manifest** | 3 | Manifest generation |
| **Evidence** | 3 | Evidence management |
| **Report** | 3 | Report generation |
| **Git** | 7 | Git operations |

---

## 4. Folder Conventions

| Folder | Purpose |
|--------|---------|
| `00_README/` | Repository overview and documentation |
| `01_GOVERNANCE/` | Governance documents |
| `02_CONSTITUTIONAL_FRAMEWORK/` | Constitutional documents |
| `03_ENTERPRISE_ARCHITECTURE/` | Architecture documents |
| `04_ENTERPRISE_ASSURANCE/` | Assurance documents |
| `05_ENTERPRISE_BASELINE/` | Immutable baselines |
| `06_GOVERNANCE_RECORDS/` | Governance records |
| `07_TEMPLATES/` | Templates |
| `08_EVIDENCE/` | Evidence and hashes |
| `09_ARCHIVES/` | Release archives |
| `10_MACHINE_READABLE/` | JSON, YAML, schemas |
| `11_AUTOMATION/` | PowerShell automation |
| `99_REFERENCE/` | Reference material |

---

## 5. Naming Standards

### 5.1 Functions

- Use approved PowerShell verbs: `Get-`, `Set-`, `Test-`, `Invoke-`, `Export-`, `New-`, `Start-`, `Stop-`, `Write-`, `Parse-`
- Singular not plural: `Get-Document` not `Get-Documents`
- Consistent across services

### 5.2 Scripts

- `Verb-Noun.ps1` format
- Example: `Build-Baseline.ps1`

### 5.3 Parameters

- PascalCase
- Optional parameters: `[Parameter(Mandatory=$false)]`

---

## 6. Testing Strategy

### 6.1 Test Types

| Test Type | Location | Command |
|-----------|----------|---------|
| Regression | `Test-Phase1.ps1` | `.\Test-Phase1.ps1` |
| Pester | `Tests/Repository.Common.Tests.ps1` | `Invoke-Pester -Path .\Tests\Repository.Common.Tests.ps1` |
| Performance | `Tests/Performance.Tests.ps1` | `Invoke-Pester -Path .\Tests\Performance.Tests.ps1` |
| Clean Install | `Tests/CleanInstall.Tests.ps1` | `.\Tests\CleanInstall.Tests.ps1` |

### 6.2 Expected Results

| Test Type | Expected |
|-----------|----------|
| Regression | 24/24 PASS |
| Pester | 11/11 PASS |
| Performance | 4/4 PASS |
| Clean Install | 6/6 PASS |

---

## 7. Release Workflow

1. Run all validation tests
2. Update version numbers
3. Update documentation
4. Commit changes
5. Create Git tag
6. Push to GitHub
7. Create release archive


---

## 8. Dependency Rules

| Service | Depends On |
|---------|------------|
| Configuration | None |
| Logging | Configuration |
| Repository | Configuration, Logging |
| Document | Repository, Logging |
| Validation | Repository, Document, Logging |
| Hash | Logging |
| Manifest | Document, Metadata, Hash, Logging |
| Evidence | Manifest, Hash, Logging |
| Report | Metadata, Statistics, Logging |
| Git | Configuration, Logging |

**Rules:**
- Configuration has NO dependencies
- Services never call scripts
- No duplicate logic
- No circular dependencies

---

## 9. Extension Rules

### 9.1 Adding a New Service

1. Define service interface in architecture document
2. Add functions to `Repository.Common.psm1`
3. Add functions to `Export-ModuleMember` list
4. Update module manifest (`FunctionsToExport`)
5. Update API Reference documentation
6. Add Pester tests
7. Run validation suite

### 9.2 Adding a New Function

1. Add function to appropriate service section
2. Include comment-based help
3. Export function
4. Update API Reference
5. Add tests
6. Update documentation

---

## 10. Coding Conventions

### 10.1 Error Handling

- Use try/catch for operations that may fail
- Log errors with `Write-ErrorMessage`
- Return meaningful error messages
- Use `Write-WarningMessage` for warnings

### 10.2 Logging

- Use `Write-Log` with appropriate level
- `Info`: Normal operations
- `Warning`: Non-critical issues
- `Error`: Critical failures
- `Success`: Completed operations
- `Debug`: Detailed troubleshooting

### 10.3 Output Contracts

- Functions return objects, not text
- Use `PSCustomObject` for structured data
- Consistent property naming
- Pipeline support where applicable

---

## 11. Orchestration Model

### 11.1 Script Philosophy

- **Scripts** own orchestration
- **Frameworks** own reusable capability
- **Documents** own policy
- **Models** own meaning
- **Evidence** owns verification

### 11.2 Script Pattern

```powershell
Import-Module "$PSScriptRoot\Modules\Repository.Common.psm1" -Force

# Step 1: Initialize
Start-BuildTimer

# Step 2: Use Services
$Documents = Get-Documents -ExcludeArchives

# Step 3: Process Results
Export-DocumentRegister -Documents $Documents -OutputPath $OutputFile

# Step 4: Report
Write-Success "Operation completed"

# Step 5: Complete
Stop-BuildTimer

### 11.3 Prohibited Patterns

| ❌ Prohibited |
|---------------|
| Do NOT implement business logic in scripts |
| Do NOT hardcode paths |
| Do NOT duplicate logic |
| Do NOT bypass framework services |
| Do NOT use Write-Host directly (use Write-Log) |

---

## 12. Git Service Usage

### 12.1 Checking Status

```powershell
# Get repository status
Get-GitStatus

# Get commit history
Get-GitCommitHistory -Count 10

# List branches
Get-GitBranches

### 12.2 Making Changes

```powershell
# Stage all changes and commit
New-GitCommit -Message "Your commit message" -StageAll

### 12.3 Tagging

```powershell
# Create a tag
New-GitTag -TagName "Repository.Common-v1.9.0"

## 13. Quick Reference

```powershell
# Import module
Import-Module Repository.Common -Force

# Check module
Get-Command -Module Repository.Common

# Build repository
.\Build-Baseline.ps1

# Validate
.\Test-Phase1.ps1

# Check status
.\Get-RepositoryStatus.ps1

# Release
.\Release-Repository.ps1

## 14. Getting Help

| Resource | Location |
|----------|----------|
| API Reference | `Docs/GW-EAF-API-Reference.md` |
| Release Notes | `Docs/RELEASE_NOTES_v1.9.md` |
| Maintainer Guide | `Docs/Maintainer_Guide.md` |
| Operational Runbook | `Docs/Operational_Runbook.md` |
| Quick Start | `Docs/Quick_Start.md` |
| Architecture Decision Index | `04_ENTERPRISE_ASSURANCE/ADR_Index.md` |

---

## 15. Troubleshooting

### 15.1 Common Issues

| Issue | Resolution |
|-------|------------|
| Module import fails | Check file path, execution policy |
| Tests fail | Check environment, dependencies |
| Git operations fail | Check repository initialization |
| Hardcoded paths found | Use `Get-RepositoryRoot` instead |

### 15.2 Diagnostic Commands

```powershell
# Check module
Import-Module Repository.Common -Force
(Get-Command -Module Repository.Common).Count
# Expected: 55

# Check repository
Get-RepositoryRoot
Get-RepositoryState

## 16. Version Information

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


---

## 📋 SUMMARY

| Document | Format | Location |
|----------|--------|----------|
| Developer_Handbook.md | ✅ Markdown | `11_AUTOMATION/PowerShell/Docs/` |
| Maintainer_Guide.md | ✅ Markdown | `11_AUTOMATION/PowerShell/Docs/` |
| Operational_Runbook.md | ✅ Markdown | `11_AUTOMATION/PowerShell/Docs/` |
| Quick_Start.md | ✅ Markdown | `11_AUTOMATION/PowerShell/Docs/` |

---

## ✅ CONFIRMATION REQUIRED

**Type `"DONE"` when you have saved all four files in Markdown format.**