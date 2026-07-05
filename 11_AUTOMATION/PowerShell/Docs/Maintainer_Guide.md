# GW-EAF Maintainer Guide
## Golden Wings Enterprise Automation Framework — v1.9.0

---

## 1. Purpose

This guide is for maintainers responsible for ongoing maintenance, updates, and releases of the GW-EAF framework.

---

## 2. Release Process

### 2.1 Versioning

GW-EAF follows semantic versioning: **Major.Minor.Patch**

| Version Type | When to Use | Example |
|--------------|-------------|---------|
| Major | Breaking changes | v2.0.0 |
| Minor | New features (backward compatible) | v1.10.0 |
| Patch | Bug fixes (backward compatible) | v1.9.1 |

### 2.2 Release Steps

Step 1: Run all validation tests
Step 2: Update version numbers
Step 3: Update documentation
Step 4: Commit changes
Step 5: Create Git tag
Step 6: Push to GitHub
Step 7: Create release archive
Step 8: Update governance registers

### 2.3 Version Numbers to Update

| File | Location | Field |
|------|----------|-------|
| `Repository.Common.psm1` | Header | `# Version : X.X` |
| `Repository.Common.psd1` | ModuleVersion | `'X.X.X'` |
| RD — Repository Dashboard | Header | `Version: X.X.X` |
| RE — Governance Dashboard | Header | `Version: X.X.X` |
| Release Notes | `Docs/RELEASE_NOTES_v1.9.md` | Add new version |

---

## 3. Tagging

### 3.1 Creating a Tag

```powershell
# Create lightweight tag
git tag Repository.Common-v1.9.0

# Create annotated tag (recommended)
git tag -a Repository.Common-v1.9.0 -m "Release v1.9.0: Production Ready"

### 3.2 Pushing Tags

```powershell
# Push a specific tag
git push origin Repository.Common-v1.9.0

# Push all tags
git push origin --tags

### 3.3 Tag Naming Convention

| Format | Example |
|--------|---------|
| `Repository.Common-v{Major}.{Minor}.{Patch}` | `Repository.Common-v1.9.0` |

---

## 4. Release Archive

### 4.1 Creating a Release Archive

```powershell
# Set release path
$ReleasePath = "D:\GoldenWings\09_ARCHIVES\GW-Release-{Year}.{Version}"

# Create folder structure
New-Item -ItemType Directory -Force -Path "$ReleasePath\02_Source"
New-Item -ItemType Directory -Force -Path "$ReleasePath\03_Documentation"
New-Item -ItemType Directory -Force -Path "$ReleasePath\04_Validation"
New-Item -ItemType Directory -Force -Path "$ReleasePath\05_Evidence\Hashes"
New-Item -ItemType Directory -Force -Path "$ReleasePath\06_GitMetadata"
New-Item -ItemType Directory -Force -Path "$ReleasePath\07_Reports"
New-Item -ItemType Directory -Force -Path "$ReleasePath\99_Manifest"

# Copy files
Copy-Item "D:\GoldenWings\11_AUTOMATION\PowerShell\Modules\Repository.Common.psm1" "$ReleasePath\02_Source\" -Force
Copy-Item "D:\GoldenWings\11_AUTOMATION\PowerShell\Modules\Repository.Common.psd1" "$ReleasePath\02_Source\" -Force
Copy-Item "D:\GoldenWings\11_AUTOMATION\PowerShell\Docs\*.md" "$ReleasePath\03_Documentation\" -Force
Copy-Item "D:\GoldenWings\11_AUTOMATION\PowerShell\Tests\*.ps1" "$ReleasePath\04_Validation\" -Force
Copy-Item "D:\GoldenWings\08_EVIDENCE\Hashes\HASHES_2026.1.csv" "$ReleasePath\05_Evidence\Hashes\" -Force

# Generate SHA256 inventory
Get-ChildItem -Path $ReleasePath -Recurse -File |
    Where-Object { $_.Name -ne "SHA256_INVENTORY.csv" } |
    Get-FileHash -Algorithm SHA256 |
    Select-Object Path, Hash |
    Export-Csv -Path "$ReleasePath\99_Manifest\SHA256_INVENTORY.csv" -NoTypeInformation -Encoding UTF8

### 4.2 Archive Contents

| Folder | Contents |
|--------|----------|
| `02_Source/` | `Repository.Common.psm1`, `Repository.Common.psd1` |
| `03_Documentation/` | All markdown documentation |
| `04_Validation/` | Pester, Performance, Clean Install tests |
| `05_Evidence/Hashes/` | SHA256 inventory of repository |
| `06_GitMetadata/` | `tags.txt` |
| `07_Reports/` | Validation reports |
| `99_Manifest/` | Release manifest, SHA256 inventory |

---

## 5. Manifest Generation

### 5.1 Repository Manifest

```powershell
# Generate manifest
.\Generate-Manifest.ps1

# Location
D:\GoldenWings\05_ENTERPRISE_BASELINE\GW-BASELINE-2026.1\MANIFEST.md

### 5.2 Release Manifest

```powershell
# GW-Release-{Year}.{Version} — Release Manifest

## Release Information
- Version: {Version}
- Date: {Date}
- Git Tag: Repository.Common-v{Version}
- Baseline: GW-BASELINE-2026.1

## Validation Results
- Regression Tests: {Passed}/{Total} PASS
- Pester Tests: {Passed}/{Total} PASS
- Performance Tests: {Passed}/{Total} PASS
- Clean Install Tests: {Passed}/{Total} PASS

## Integrity
- SHA256 Inventory: Included
- Baseline Verification: Passed
- Git Tags: Verified

## 6. Evidence Management

### 6.1 Evidence Types

| Type | Location | Description |
|------|----------|-------------|
| Hashes | `08_EVIDENCE/Hashes/` | SHA256 inventory |
| Signatures | `08_EVIDENCE/Signatures/` | Digital signatures |
| Approvals | `08_EVIDENCE/Approvals/` | Approval records |
| Reports | `08_EVIDENCE/Reports/` | Validation reports |
| Verification | `08_EVIDENCE/Verification/` | Verification logs |

### 6.2 Evidence Generation

```powershell
# Generate hash inventory
.\Build-Hashes.ps1

# Generate evidence
.\Generate-Evidence.ps1

# Generate report
.\Generate-Report.ps1

## 7. Governance Registers

### 7.1 Registers to Update

| Register | When to Update | Field to Add |
|----------|----------------|--------------|
| RF — Change Request | Every release | CR-ID, Date, Change, Impact |
| RH — Decision Register | Every release | ADR-ID, Decision, Rationale |
| RG — Risk Register | Every release | Risk Status |
| RJ — Continuous Improvement | Every release | Improvement Status |

### 7.2 Final Entries

**Change Register (RF):**
CR-2026-099 | July 2026 | Founder | GW-EAF v1.9.0 Framework | Major | Enterprise-wide | Approved | GW-BASELINE-2026.1 | July 2026 | Framework certified. Project closed.

**Decision Register (RH):**
DR-2026-007 | July 2026 | GW-EAF v1.9.0 Declared Production-Ready | 10 services, 55 functions, all tests passing | Founder | GW-BASELINE-2026.1 | Implemented

## 8. Troubleshooting

### 8.1 Common Issues

| Issue | Resolution |
|-------|------------|
| Module import fails | Check file path, execution policy |
| Tests fail | Check environment, dependencies |
| Release archive fails | Check permissions, disk space |
| Git push fails | Check authentication, network |

### 8.2 Validation Commands

```powershell
# Run all validation
.\Test-Phase1.ps1

# Check module import
Import-Module .\Modules\Repository.Common.psm1 -Force
(Get-Command -Module Repository.Common).Count

# Check Git status
Get-GitStatus

## 9. Dependencies

### 9.1 External Dependencies

| Dependency | Version | Purpose |
|------------|---------|---------|
| PowerShell | 5.1+ | Runtime |
| Git | Latest | Version control |
| GitHub | N/A | Remote repository |
| Pester | 3.4.0+ | Testing |

### 9.2 Internal Dependencies

| Dependency | Purpose |
|------------|---------|
| `Repository.Common.psm1` | Core framework |
| `Repository.Common.psd1` | Module manifest |
| Test scripts | Validation |

---

## 10. Security Considerations

### 10.1 Secrets Management

| | Practice |
|---|----------|
| ❌ | Never commit secrets to source control |
| ❌ | Never store credentials in code |
| ❌ | Never hardcode tokens |
| ✅ | Use approved secret vault |

### 10.2 Access Control

| Resource | Access Level |
|----------|--------------|
| Repository | Read/Write for developers |
| GitHub | Push access for maintainers |
| CI/CD | Automated pipeline access |

---

## 11. Backup & Recovery

### 11.1 Backup Commands

```powershell
# Backup repository
Copy-Item -Path "D:\GoldenWings" -Destination "D:\Backups\GoldenWings_$(Get-Date -Format 'yyyyMMdd')" -Recurse

# Backup Git metadata
cd D:\GoldenWings
git bundle create "D:\Backups\goldenwings_$(Get-Date -Format 'yyyyMMdd').bundle" --all

### 11.2 Recovery Commands

```powershell
# Restore from backup
Copy-Item -Path "D:\Backups\GoldenWings_latest" -Destination "D:\GoldenWings" -Recurse

# Restore Git bundle
git clone "D:\Backups\goldenwings_latest.bundle" "D:\GoldenWings"

# Verify restoration
.\Verify-Repository.ps1

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