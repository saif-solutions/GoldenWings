@{
    # Script module or binary module file associated with this manifest
    RootModule = 'Repository.Common.psm1'
    
    # Version number of this module
    ModuleVersion = '1.9.0'
    
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
            Tags = @('GoldenWings', 'Enterprise', 'Automation', 'Framework', 'GW-EAF')
            ReleaseNotes = @'
# Golden Wings Enterprise Automation Framework (GW-EAF) v1.9.0

## Release Notes

### Overview
GW-EAF v1.9.0 represents the culmination of four implementation phases,
transforming a collection of independent PowerShell scripts into a
cohesive, service-oriented automation framework.

### Phase 1: Foundation Services (v1.2)
- Configuration Service
- Logging Service
- Repository Service
- 29 exported functions

### Phase 2: Shared Services (v1.5)
- Document Service
- Validation Service
- Hash Service
- +10 functions (39 total)

### Phase 3: Advanced Services (v1.8)
- Manifest Service
- Evidence Service
- Report Service
- +9 functions (48 total)

### Phase 4: Git Service (v1.9)
- Git Service
- +7 functions (55 total)

### Key Features
- 10 services
- 55 exported functions
- Layered architecture
- Backward compatibility
- 24/24 validation tests passing
- Comprehensive Git integration

### Validation Summary
- All 24 regression tests passed
- Document register: 120 documents
- Repository metadata: 177 files
- Hash inventory: 146 files hashed
- Git operations: Full support for status, commit, tag, push, pull
'@
        }
    }
}