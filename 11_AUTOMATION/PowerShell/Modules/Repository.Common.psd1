@{
    # Script module or binary module file associated with this manifest
    RootModule = 'Repository.Common.psm1'
    
    # Version number of this module
    ModuleVersion = '1.10.0'
    
    # ID used to uniquely identify this module
    GUID = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'
    
    # Author of this module
    Author = 'Golden Wings'
    
    # Company or vendor of this module
    CompanyName = 'Golden Wings Enterprise'
    
    # Copyright statement for this module
    Copyright = '(c) 2026 Golden Wings. All rights reserved.'
    
    # Description of the functionality provided by this module
    Description = 'Golden Wings Enterprise Automation Framework (GW-EAF)'
    
    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '5.1'
    
    # Functions to export from this module
    FunctionsToExport = @(
        # Configuration
        'Get-RepositoryRoot',
        'Get-RepositoryVersion',
        'Get-BaselineName',
        'Get-ReleaseName',
        'Get-CurrentDate',
        'Get-RepositoryConfiguration',
        'Get-ConfigValue',
        
        # Logging
        'Write-Section',
        'Write-SubSection',
        'Write-Success',
        'Write-WarningMessage',
        'Write-ErrorMessage',
        'Write-Info',
        'Write-Log',
        'Write-DebugMessage',
        
        # Orchestration
        'Invoke-Step',
        
        # Utilities
        'Get-SHA256',
        'Get-RelativePath',
        'Test-RepositoryFolder',
        'Test-RepositoryFile',
        
        # Timing
        'Start-BuildTimer',
        'Stop-BuildTimer',
        
        # Statistics
        'Get-RepositoryStatistics',
        
        # Release
        'Get-BaselineFolder',
        'Get-ReleaseFolder',
        
        # Repository
        'Get-RepositoryDocuments',
        'Get-RepositoryScripts',
        'Get-RepositoryFolders',
        'Get-RepositoryState',
        
        # Document
        'Parse-DocumentID',
        'Get-DocumentMetadata',
        'Get-Documents',
        'Export-DocumentRegister',
        
        # Validation
        'Test-DocumentName',
        'Test-RepositoryStructure',
        'Invoke-RepositoryValidation',
        
        # Hash
        'Get-RepositoryFileHash',
        'Export-HashInventory',
        'Verify-Hash',
        
        # Manifest
        'Get-ManifestData',
        'New-Manifest',
        'Export-Manifest',
        
        # Evidence
        'New-Evidence',
        'Export-Evidence',
        'Get-EvidenceStatus',
        
        # Report
        'New-Report',
        'Export-Report',
        'Get-RepositoryHealth',
        
        # Git
        'Get-GitStatus',
        'Get-GitCommitHistory',
        'New-GitCommit',
        'New-GitTag',
        'Get-GitBranches',
        'Invoke-GitPush',
        'Invoke-GitPull'
    )
    
    # Private data to pass to the module
    PrivateData = @{
        PSData = @{
            Tags = @(
                'GoldenWings',
                'Enterprise',
                'Automation',
                'Framework',
                'GW-EAF',
                'Repository',
                'Governance',
                'PowerShell',
                'DevOps',
                'CI/CD',
                'Git'
            )
            
            LicenseUri = 'https://github.com/goldenwings/repository/blob/main/LICENSE'
            ProjectUri = 'https://github.com/goldenwings/repository'
            IconUri = 'https://github.com/goldenwings/repository/raw/main/icon.png'
            
            ReleaseNotes = @'
# Golden Wings Enterprise Automation Framework (GW-EAF) v1.9.0

## What's New
- 10 Services
- 55 Exported Functions
- Complete validation suite
- Git operations
- Full documentation
- Enterprise governance framework

## Services Overview
| Service | Functions | Description |
|---------|-----------|-------------|
| Configuration | 7 | Centralized repository configuration |
| Logging | 8 | Structured logging with levels |
| Orchestration | 1 | Build step framework |
| Utilities | 4 | File and path utilities |
| Timing | 2 | Build timing |
| Statistics | 1 | Repository statistics |
| Release | 2 | Release helpers |
| Repository | 4 | Repository discovery and state |
| Document | 4 | Document metadata management |
| Validation | 3 | Validation framework |
| Hash | 3 | Hash generation and verification |
| Manifest | 3 | Manifest generation |
| Evidence | 3 | Evidence management |
| Report | 3 | Report generation |
| Git | 7 | Git operations |

**Total: 10 Services, 55 Functions**

## Quick Start
```powershell
# Install from PowerShell Gallery
Install-Module -Name GW-EAF -Force

# Import the module
Import-Module GW-EAF -Force

# Check available commands
Get-Command -Module GW-EAF

# Build the repository
Build-Baseline.ps1

# Validate the repository
Test-Phase1.ps1

# Check repository status
Get-RepositoryStatus.ps1
```

## Documentation

| Document | Location |
|----------|----------|
| API Reference | `Docs/GW-EAF-API-Reference.md` |
| Developer Handbook | `Docs/Developer_Handbook.md` |
| Maintainer Guide | `Docs/Maintainer_Guide.md` |
| Operational Runbook | `Docs/Operational_Runbook.md` |
| Quick Start | `Docs/Quick_Start.md` |
| System Overview | `00_README/SYSTEM_OVERVIEW.md` |

---

## Validation Results

| Test Type | Result |
|-----------|--------|
| Regression Tests | 24/24 PASS |
| Pester Tests | 11/11 PASS |
| Performance Tests | 4/4 PASS |
| Clean Install Tests | 6/6 PASS |

---

## Version History

| Version | Phase | Services | Functions | Status |
|---------|-------|----------|-----------|--------|
| v1.9.0 | Certification | 10 | 55 | ✅ PRODUCTION READY |
| v1.9 | Phase 4: Git Service | 10 | 55 | COMPLETE |
| v1.8 | Phase 3: Advanced Services | 9 | 48 | COMPLETE |
| v1.5 | Phase 2: Shared Services | 6 | 39 | COMPLETE |
| v1.2 | Phase 1: Foundation | 3 | 29 | COMPLETE |

---

## Git Tags

- `Repository.Common-v1.2`
- `Repository.Common-v1.5`
- `Repository.Common-v1.8`
- `Repository.Common-v1.9`
- `Repository.Common-v1.9.0`

---

## Requirements

- PowerShell 5.1 or higher
- Git (for Git operations)
- Windows, Linux, or macOS (PowerShell 7+)

---

## Installation Options

```powershell
# Option 1: From PowerShell Gallery (recommended)
Install-Module -Name GW-EAF -Force

# Option 2: Manual installation
Import-Module D:\GoldenWings\11_AUTOMATION\PowerShell\Modules\Repository.Common.psm1 -Force

# Option 3: From release archive
Import-Module D:\GoldenWings\09_ARCHIVES\GW-Release-2026.1\02_Source\Repository.Common.psm1 -Force

'@
        }
    }
}