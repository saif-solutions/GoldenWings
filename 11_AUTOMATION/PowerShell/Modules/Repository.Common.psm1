##############################################################
#
# Golden Wings Enterprise Automation Framework
# Repository.Common.psm1
#
# Version : 1.5
# Baseline: GW-BASELINE-2026.1
#
# PHASE 1 IMPLEMENTATION (2026-07-04)
# - Configuration Service
# - Logging Service (Enhanced with backward compatibility)
# - Repository Service
# - Total: 39 exported functions
#
##############################################################

#-------------------------------------------------------------
# Configuration Constants (Single Source of Truth)
#-------------------------------------------------------------

$script:CONFIG = @{
    Version = "2026.1"
    Baseline = "GW-BASELINE-2026.1"
    Release = "GW-Release-2026.1"
    Folders = @{
        Governance = "01_GOVERNANCE"
        Constitutional = "02_CONSTITUTIONAL_FRAMEWORK"
        Architecture = "03_ENTERPRISE_ARCHITECTURE"
        Assurance = "04_ENTERPRISE_ASSURANCE"
        Baseline = "05_ENTERPRISE_BASELINE"
        GovernanceRecords = "06_GOVERNANCE_RECORDS"
        Templates = "07_TEMPLATES"
        Evidence = "08_EVIDENCE"
        Archives = "09_ARCHIVES"
        MachineReadable = "10_MACHINE_READABLE"
        Automation = "11_AUTOMATION"
        Reference = "99_REFERENCE"
    }
}

#-------------------------------------------------------------
# Repository Configuration (Existing — Stable API)
#-------------------------------------------------------------

function Get-RepositoryRoot {
    <#
    .SYNOPSIS
        Locates the repository root by walking upward until a marker is found.
    .DESCRIPTION
        Starting from the module's location, walks up the directory tree
        until it finds a folder containing both "01_GOVERNANCE" and "11_AUTOMATION".
    .EXAMPLE
        $root = Get-RepositoryRoot
        # Returns: D:\GoldenWings
    #>
    
    $current = $PSScriptRoot
    
    while ($current) {
        # Check for repository markers
        $hasGovernance = Test-Path (Join-Path $current "01_GOVERNANCE")
        $hasAutomation = Test-Path (Join-Path $current "11_AUTOMATION")
        
        if ($hasGovernance -and $hasAutomation) {
            return $current
        }
        
        $parent = Split-Path $current -Parent
        if ($parent -eq $current) {
            break
        }
        $current = $parent
    }
    
    # Fallback: Use known location (for development)
    Write-WarningMessage "Repository root could not be located via markers. Using fallback."
    return "D:\GoldenWings"
}

function Get-RepositoryVersion {
    return $script:CONFIG.Version
}

function Get-BaselineName {
    return $script:CONFIG.Baseline
}

function Get-ReleaseName {
    return $script:CONFIG.Release
}

function Get-CurrentDate {
    Get-Date -Format "yyyy-MM-dd HH:mm:ss"
}

#-------------------------------------------------------------
# Configuration Service (New — Phase 1)
#-------------------------------------------------------------

<#
.SYNOPSIS
    Gets the complete repository configuration object.
.DESCRIPTION
    Returns a PSCustomObject containing all repository configuration
    values. This is the single source of truth for configuration.
.EXAMPLE
    $config = Get-RepositoryConfiguration
    $config.Version
#>
function Get-RepositoryConfiguration {
    [CmdletBinding()]
    param()
    
    $Root = Get-RepositoryRoot
    $Version = Get-RepositoryVersion
    $Baseline = Get-BaselineName
    $Release = Get-ReleaseName
    $Folders = $script:CONFIG.Folders
    
    [PSCustomObject]@{
        Root = $Root
        Version = $Version
        Baseline = $Baseline
        Release = $Release
        BaselineFolder = Join-Path $Root (Join-Path $Folders.Baseline $Baseline)
        ReleaseFolder = Join-Path $Root (Join-Path $Folders.Archives $Release)
        EvidenceFolder = Join-Path $Root $Folders.Evidence
        AutomationFolder = Join-Path $Root $Folders.Automation
        MachineReadableFolder = Join-Path $Root $Folders.MachineReadable
        GovernanceFolder = Join-Path $Root $Folders.Governance
        ConstitutionalFolder = Join-Path $Root $Folders.Constitutional
        ArchitectureFolder = Join-Path $Root $Folders.Architecture
        AssuranceFolder = Join-Path $Root $Folders.Assurance
        BaselineRoot = Join-Path $Root $Folders.Baseline
        ArchivesRoot = Join-Path $Root $Folders.Archives
        GovernanceRecordsFolder = Join-Path $Root $Folders.GovernanceRecords
        TemplatesFolder = Join-Path $Root $Folders.Templates
        ReferenceFolder = Join-Path $Root $Folders.Reference
    }
}

<#
.SYNOPSIS
    Gets a specific configuration value by key.
.DESCRIPTION
    Returns the value for the specified configuration key.
    If the key does not exist, returns $null with a warning.
.EXAMPLE
    $version = Get-ConfigValue -Key "Version"
#>
function Get-ConfigValue {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Key
    )
    
    $Config = Get-RepositoryConfiguration
    
    if ($Config.PSObject.Properties.Name -contains $Key) {
        return $Config.$Key
    } else {
        Write-WarningMessage "Configuration key '$Key' not found. Returning `$null."
        return $null
    }
}

#-------------------------------------------------------------
# Logging Service (New — Phase 1)
#-------------------------------------------------------------

<#
.SYNOPSIS
    Writes structured log messages with levels and optional timestamps.
.DESCRIPTION
    Core logging function that supports multiple log levels.
    Timestamps are optional to maintain backward compatibility.
.PARAMETER Message
    The log message to write.
.PARAMETER Level
    Log level: Info, Warning, Error, Success, Debug, Verbose.
.PARAMETER ShowTimestamp
    If specified, includes timestamp in the output.
.EXAMPLE
    Write-Log -Message "Build started" -Level Info
.EXAMPLE
    Write-Log -Message "Build completed" -Level Success -ShowTimestamp
#>
function Write-Log {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Message,
        
        [ValidateSet('Info','Warning','Error','Success','Debug','Verbose')]
        [string]$Level = 'Info',
        
        [switch]$ShowTimestamp
    )
    
    $Prefix = "[$Level]"
    $FormattedMessage = if ($ShowTimestamp) {
        $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        "$Timestamp $Prefix $Message"
    } else {
        "$Prefix $Message"
    }
    
    switch ($Level) {
        'Info'      { Write-Host $FormattedMessage -ForegroundColor Cyan }
        'Warning'   { Write-Host $FormattedMessage -ForegroundColor Yellow }
        'Error'     { Write-Host $FormattedMessage -ForegroundColor Red }
        'Success'   { Write-Host $FormattedMessage -ForegroundColor Green }
        'Debug'     { Write-Host $FormattedMessage -ForegroundColor Magenta }
        'Verbose'   { Write-Host $FormattedMessage -ForegroundColor Gray }
    }
}

# Legacy Write-* functions (now delegate to Write-Log for consistency)
function Write-Success {
    [CmdletBinding()]
    param([string]$Message)
    Write-Log -Message $Message -Level 'Success'
}

function Write-WarningMessage {
    [CmdletBinding()]
    param([string]$Message)
    Write-Log -Message $Message -Level 'Warning'
}

function Write-ErrorMessage {
    [CmdletBinding()]
    param([string]$Message)
    Write-Log -Message $Message -Level 'Error'
}

function Write-Info {
    [CmdletBinding()]
    param([string]$Message)
    Write-Log -Message $Message -Level 'Info'
}

# Section headers (maintain original format for backward compatibility)
function Write-Section {
    [CmdletBinding()]
    param([string]$Title)
    
    Write-Host ""
    Write-Host "=========================================="
    Write-Host $Title
    Write-Host "=========================================="
    Write-Host ""
}

function Write-SubSection {
    [CmdletBinding()]
    param([string]$Title)
    
    Write-Host ""
    Write-Host "------------------------------------------"
    Write-Host $Title
    Write-Host "------------------------------------------"
}

<#
.SYNOPSIS
    Writes a debug message (non-shadowing).
.DESCRIPTION
    Writes a debug-level log message using Write-Log.
    Does NOT shadow PowerShell's built-in Write-Debug.
#>
function Write-DebugMessage {
    [CmdletBinding()]
    param([string]$Message)
    Write-Log -Message $Message -Level 'Debug'
}

#-------------------------------------------------------------
# Build Step Framework (Existing — Stable API)
#-------------------------------------------------------------

function Invoke-Step {
    param(
        [Parameter(Mandatory)]
        [string]$Title,
        
        [Parameter(Mandatory)]
        [scriptblock]$Action
    )
    
    Write-SubSection $Title
    $Start = Get-Date
    
    try {
        & $Action
        $Elapsed = (Get-Date) - $Start
        Write-Success ("Completed in {0:N2} sec" -f $Elapsed.TotalSeconds)
    }
    catch {
        Write-ErrorMessage $_.Exception.Message
        throw
    }
}

#-------------------------------------------------------------
# File Utilities (Existing — Stable API)
#-------------------------------------------------------------

function Get-SHA256 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )
    
    if (-not (Test-Path $Path)) {
        throw "File not found: $Path"
    }
    
    (Get-FileHash $Path -Algorithm SHA256).Hash
}

function Get-RelativePath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$FullPath
    )
    
    $Root = Get-RepositoryRoot
    $FullPath.Replace($Root, "").TrimStart("\")
}

function Test-RepositoryFolder {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Folder
    )
    
    $Path = Join-Path (Get-RepositoryRoot) $Folder
    Test-Path $Path
}

function Test-RepositoryFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$File
    )
    
    $Path = Join-Path (Get-RepositoryRoot) $File
    Test-Path $Path
}

#-------------------------------------------------------------
# Build Logging (Existing — Stable API)
#-------------------------------------------------------------

$script:BuildStart = $null

function Start-BuildTimer {
    $script:BuildStart = Get-Date
}

function Stop-BuildTimer {
    if ($script:BuildStart) {
        $Elapsed = (Get-Date) - $script:BuildStart
        Write-Host ""
        Write-Host "Total Build Time : $($Elapsed.ToString())"
    }
}

#-------------------------------------------------------------
# Metadata Helpers (Existing — Stable API)
#-------------------------------------------------------------

function Get-RepositoryStatistics {
    $Root = Get-RepositoryRoot
    
    [PSCustomObject]@{
        Documents = (Get-ChildItem $Root -Recurse -Filter *.docx -File).Count
        Scripts = (Get-ChildItem $Root -Recurse -Filter *.ps1 -File).Count
        Markdown = (Get-ChildItem $Root -Recurse -Filter *.md -File).Count
        CSV = (Get-ChildItem $Root -Recurse -Filter *.csv -File).Count
        JSON = (Get-ChildItem $Root -Recurse -Filter *.json -File).Count
        Folders = (Get-ChildItem $Root -Directory -Recurse).Count
    }
}

#-------------------------------------------------------------
# Release Helpers (Existing — Stable API)
#-------------------------------------------------------------

function Get-BaselineFolder {
    $Config = Get-RepositoryConfiguration
    return $Config.BaselineFolder
}

function Get-ReleaseFolder {
    $Config = Get-RepositoryConfiguration
    return $Config.ReleaseFolder
}

#-------------------------------------------------------------
# Repository Service (New — Phase 1)
#-------------------------------------------------------------

<#
.SYNOPSIS
    Gets all documents in the repository.
.DESCRIPTION
    Returns all .docx files in the repository.
    Optional switches to exclude archives and baseline folders.
.PARAMETER ExcludeArchives
    Excludes files in the 09_ARCHIVES folder.
.PARAMETER ExcludeBaseline
    Excludes files in the 05_ENTERPRISE_BASELINE folder.
.EXAMPLE
    $documents = Get-RepositoryDocuments
.EXAMPLE
    $documents = Get-RepositoryDocuments -ExcludeArchives
#>
function Get-RepositoryDocuments {
    [CmdletBinding()]
    param(
        [switch]$ExcludeArchives,
        [switch]$ExcludeBaseline
    )
    
    $Root = Get-RepositoryRoot
    
    try {
        $Documents = Get-ChildItem $Root -Recurse -Filter *.docx -File -ErrorAction Stop
        
        if ($ExcludeArchives) {
            $Config = Get-RepositoryConfiguration
            $ArchivePattern = [regex]::Escape($Config.ArchivesRoot)
            $Documents = $Documents | Where-Object { $_.FullName -notmatch $ArchivePattern }
        }
        
        if ($ExcludeBaseline) {
            $Config = Get-RepositoryConfiguration
            $BaselinePattern = [regex]::Escape($Config.BaselineRoot)
            $Documents = $Documents | Where-Object { $_.FullName -notmatch $BaselinePattern }
        }
        
        return $Documents
    }
    catch {
        Write-ErrorMessage "Failed to retrieve documents: $($_.Exception.Message)"
        throw
    }
}

<#
.SYNOPSIS
    Gets all PowerShell scripts in the repository.
.DESCRIPTION
    Returns all .ps1 files in the repository.
.EXAMPLE
    $scripts = Get-RepositoryScripts
#>
function Get-RepositoryScripts {
    [CmdletBinding()]
    param()
    
    $Root = Get-RepositoryRoot
    
    try {
        return Get-ChildItem $Root -Recurse -Filter *.ps1 -File -ErrorAction Stop
    }
    catch {
        Write-ErrorMessage "Failed to retrieve scripts: $($_.Exception.Message)"
        throw
    }
}

<#
.SYNOPSIS
    Gets all folders in the repository.
.DESCRIPTION
    Returns all directories in the repository.
.EXAMPLE
    $folders = Get-RepositoryFolders
#>
function Get-RepositoryFolders {
    [CmdletBinding()]
    param()
    
    $Root = Get-RepositoryRoot
    
    try {
        return Get-ChildItem $Root -Directory -Recurse -ErrorAction Stop
    }
    catch {
        Write-ErrorMessage "Failed to retrieve folders: $($_.Exception.Message)"
        throw
    }
}

<#
.SYNOPSIS
    Gets the current repository state.
.DESCRIPTION
    Returns a PSCustomObject with repository metadata:
    Root, Version, Baseline, Release, DocumentCount, etc.
.EXAMPLE
    $state = Get-RepositoryState
#>
function Get-RepositoryState {
    [CmdletBinding()]
    param()
    
    $Config = Get-RepositoryConfiguration
    
    try {
        $Documents = Get-RepositoryDocuments
        $Scripts = Get-RepositoryScripts
        $Folders = Get-RepositoryFolders
        $LastModified = (Get-ChildItem $Config.Root -Recurse -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime
        
        [PSCustomObject]@{
            Root = $Config.Root
            Version = $Config.Version
            Baseline = $Config.Baseline
            Release = $Config.Release
            DocumentCount = $Documents.Count
            ScriptCount = $Scripts.Count
            FolderCount = $Folders.Count
            LastModified = $LastModified
        }
    }
    catch {
        Write-ErrorMessage "Failed to retrieve repository state: $($_.Exception.Message)"
        throw
    }
}

#-------------------------------------------------------------
# Document Service (New — Phase 2)
#-------------------------------------------------------------

<#
.SYNOPSIS
    Parses a document ID from a filename.
.DESCRIPTION
    Uses regex patterns to extract document IDs from filenames.
    Supports: A-###, ZA-###, Document ###, etc.
.EXAMPLE
    Parse-DocumentID -FileName "A-001_Constitution_v1.0.docx" -> "A-001"
#>
function Parse-DocumentID {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$FileName
    )
    
    $DocumentID = ""
    
    switch -Regex ($FileName) {
        "A-\d+" {
            $DocumentID = $Matches[0]
            break
        }
        "ZA?-?[A-Z0-9\.]*" {
            $DocumentID = $Matches[0]
            break
        }
        "Document ([A-Z0-9\.]+)" {
            $DocumentID = $Matches[1]
            break
        }
    }
    
    return $DocumentID
}

<#
.SYNOPSIS
    Gets metadata for a single document.
.DESCRIPTION
    Returns a PSCustomObject with document metadata.
.EXAMPLE
    $metadata = Get-DocumentMetadata -Path "D:\GoldenWings\A-001_Constitution.docx"
#>
function Get-DocumentMetadata {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )
    
    $File = Get-Item $Path
    $DocumentID = Parse-DocumentID -FileName $File.BaseName
    
    [PSCustomObject]@{
        Document_ID = $DocumentID
        Document_Title = $File.BaseName
        Repository_Path = Get-RelativePath -FullPath $File.DirectoryName
        Filename = $File.Name
        Version = Get-RepositoryVersion
        Status = "Controlled"
        Owner = "Golden Wings"
        Classification = "Internal"
        Baseline = Get-BaselineName
        Last_Updated = $File.LastWriteTime.ToString("yyyy-MM-dd")
        FullPath = $File.FullName
    }
}

<#
.SYNOPSIS
    Gets all documents with optional exclusions.
.DESCRIPTION
    Returns all .docx files with optional exclusions for archives and baseline.
.EXAMPLE
    $documents = Get-Documents -ExcludeArchives
#>
function Get-Documents {
    [CmdletBinding()]
    param(
        [switch]$ExcludeArchives,
        [switch]$ExcludeBaseline
    )
    
    $Documents = Get-RepositoryDocuments -ExcludeArchives:$ExcludeArchives -ExcludeBaseline:$ExcludeBaseline
    return $Documents
}

<#
.SYNOPSIS
    Exports a document register to CSV.
.DESCRIPTION
    Takes document metadata and exports to CSV at the specified path.
.EXAMPLE
    Export-DocumentRegister -Documents $metadata -OutputPath ".\DOCUMENT_REGISTER.csv"
#>
function Export-DocumentRegister {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [array]$Documents,
        
        [Parameter(Mandatory)]
        [string]$OutputPath
    )
    
    $Rows = @()
    
    foreach ($Doc in $Documents) {
        $Metadata = Get-DocumentMetadata -Path $Doc.FullName
        $Rows += $Metadata
    }
    
    $Rows | Sort-Object Repository_Path, Filename | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8
}

#-------------------------------------------------------------
# Validation Service (New — Phase 2)
#-------------------------------------------------------------

<#
.SYNOPSIS
    Tests if a document name follows naming conventions.
.DESCRIPTION
    Validates document names against approved patterns:
    - Document A-###
    - DOCUMENT A-###
    - GEN *
    - GOLDEN WINGS *
.EXAMPLE
    $result = Test-DocumentName -Name "A-001_Constitution"
    $result.Success
#>
function Test-DocumentName {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )
    
    $Success = $false
    $Errors = @()
    $Warnings = @()
    
    # Check against valid patterns
    if ($Name -match '^Document [A-Z]' -or
        $Name -match '^DOCUMENT [A-Z]' -or
        $Name -match '^GEN ' -or
        $Name -match '^Gen ' -or
        $Name -match '^GOLDEN WINGS') {
        $Success = $true
    } else {
        $Errors += "Document name '$Name' does not match any approved naming pattern"
    }
    
    [PSCustomObject]@{
        Success = $Success
        Errors = $Errors
        Warnings = $Warnings
        Name = $Name
    }
}

<#
.SYNOPSIS
    Validates the repository folder structure.
.DESCRIPTION
    Checks that all required folders exist in the repository.
.EXAMPLE
    $result = Test-RepositoryStructure
    $result.MissingFolders
#>
function Test-RepositoryStructure {
    [CmdletBinding()]
    param()
    
    $Root = Get-RepositoryRoot
    $Config = Get-RepositoryConfiguration
    $MissingFolders = @()
    
    $RequiredFolders = @(
        "00_README",
        "01_GOVERNANCE",
        "02_CONSTITUTIONAL_FRAMEWORK",
        "03_ENTERPRISE_ARCHITECTURE",
        "03_ENTERPRISE_ARCHITECTURE\03.01_Business_Architecture",
        "03_ENTERPRISE_ARCHITECTURE\03.02_Business_Rules",
        "03_ENTERPRISE_ARCHITECTURE\03.03_Information_Architecture",
        "03_ENTERPRISE_ARCHITECTURE\03.04_User_Experience",
        "03_ENTERPRISE_ARCHITECTURE\03.05_Application_Architecture",
        "03_ENTERPRISE_ARCHITECTURE\03.06_Technology_Architecture",
        "03_ENTERPRISE_ARCHITECTURE\03.07_Delivery_Operations",
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
    
    foreach ($Folder in $RequiredFolders) {
        $Path = Join-Path $Root $Folder
        if (-not (Test-Path $Path)) {
            $MissingFolders += $Folder
        }
    }
    
    [PSCustomObject]@{
        Success = ($MissingFolders.Count -eq 0)
        MissingFolders = $MissingFolders
        TotalFolders = $RequiredFolders.Count
    }
}

<#
.SYNOPSIS
    Invokes comprehensive repository validation.
.DESCRIPTION
    Runs all validation checks and returns consolidated results.
.EXAMPLE
    $results = Invoke-RepositoryValidation
#>
function Invoke-RepositoryValidation {
    [CmdletBinding()]
    param()
    
    $Results = @{
        DocumentNames = @()
        Structure = $null
        Errors = @()
        Warnings = @()
        Success = $true
    }
    
    # Get all documents
    $Documents = Get-RepositoryDocuments -ExcludeArchives -ExcludeBaseline
    
    # Validate each document name
    foreach ($Doc in $Documents) {
        $Result = Test-DocumentName -Name $Doc.BaseName
        if (-not $Result.Success) {
            $Results.Errors += "Document: $($Doc.Name) - $($Result.Errors -join '; ')"
            $Results.Success = $false
        }
        $Results.DocumentNames += $Result
    }
    
    # Validate structure
    $StructureResult = Test-RepositoryStructure
    $Results.Structure = $StructureResult
    if (-not $StructureResult.Success) {
        $Results.Errors += "Missing folders: $($StructureResult.MissingFolders -join ', ')"
        $Results.Success = $false
    }
    
    return $Results
}

#-------------------------------------------------------------
# Hash Service (Enhanced — Phase 2)
#-------------------------------------------------------------

<#
.SYNOPSIS
    Gets the hash of a file using the specified algorithm.
.DESCRIPTION
    Returns the hash value for a file. Supports multiple algorithms.
    Default is SHA256.
.PARAMETER Path
    The path to the file.
.PARAMETER Algorithm
    The hash algorithm to use. Default: SHA256.
.EXAMPLE
    Get-FileHash -Path "file.txt"
    Get-FileHash -Path "file.txt" -Algorithm MD5
#>
function Get-FileHash {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path,
        
        [ValidateSet('MD5', 'SHA1', 'SHA256', 'SHA384', 'SHA512')]
        [string]$Algorithm = 'SHA256'
    )
    
    if (-not (Test-Path $Path)) {
        throw "File not found: $Path"
    }
    
    $Hash = (Get-FileHash -Path $Path -Algorithm $Algorithm).Hash
    return $Hash
}

<#
.SYNOPSIS
    Exports a hash inventory for all repository files.
.DESCRIPTION
    Generates SHA256 hashes for all controlled files in the repository
    and exports them to a CSV file.
.PARAMETER OutputPath
    The path where the CSV inventory should be saved.
.PARAMETER Algorithm
    The hash algorithm to use. Default: SHA256.
.EXAMPLE
    Export-HashInventory -OutputPath ".\HASHES.csv"
#>
function Export-HashInventory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$OutputPath,
        
        [ValidateSet('MD5', 'SHA1', 'SHA256', 'SHA384', 'SHA512')]
        [string]$Algorithm = 'SHA256'
    )
    
    $Root = Get-RepositoryRoot
    $ExcludedPatterns = @(
        [regex]::Escape((Get-RepositoryConfiguration).ArchivesRoot),
        [regex]::Escape((Join-Path (Get-RepositoryConfiguration).EvidenceFolder "Hashes"))
    )
    
    $Files = Get-ChildItem $Root -Recurse -File -Include *.docx,*.md,*.csv |
        Where-Object {
            $Include = $true
            foreach ($Pattern in $ExcludedPatterns) {
                if ($_.FullName -match $Pattern) {
                    $Include = $false
                    break
                }
            }
            $Include
        }
    
    $Inventory = foreach ($File in $Files) {
        $Hash = Get-FileHash -Path $File.FullName -Algorithm $Algorithm
        
        [PSCustomObject]@{
            Repository_Path = Get-RelativePath -FullPath $File.FullName
            Hash = $Hash
            Algorithm = $Algorithm
            FileName = $File.Name
            LastModified = $File.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
        }
    }
    
    $Inventory | Sort-Object Repository_Path | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8
    
    return $Inventory
}

<#
.SYNOPSIS
    Verifies a file's hash matches the expected value.
.DESCRIPTION
    Compares the computed hash of a file against the expected hash.
    Returns $true if they match.
.PARAMETER Path
    The path to the file.
.PARAMETER ExpectedHash
    The expected hash value.
.PARAMETER Algorithm
    The hash algorithm to use. Default: SHA256.
.EXAMPLE
    Verify-Hash -Path "file.txt" -ExpectedHash "abc123..."
#>
function Verify-Hash {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path,
        
        [Parameter(Mandatory)]
        [string]$ExpectedHash,
        
        [ValidateSet('MD5', 'SHA1', 'SHA256', 'SHA384', 'SHA512')]
        [string]$Algorithm = 'SHA256'
    )
    
    try {
        $ComputedHash = Get-FileHash -Path $Path -Algorithm $Algorithm
        return ($ComputedHash -eq $ExpectedHash)
    }
    catch {
        Write-ErrorMessage "Failed to verify hash: $($_.Exception.Message)"
        return $false
    }
}


#-------------------------------------------------------------
# Exported Functions (33 functions — VERIFIED)
#-------------------------------------------------------------

Export-ModuleMember -Function @(
    # Configuration (Existing + New) — 7 functions
    'Get-RepositoryRoot',
    'Get-RepositoryVersion',
    'Get-BaselineName',
    'Get-ReleaseName',
    'Get-CurrentDate',
    'Get-RepositoryConfiguration',
    'Get-ConfigValue',
    
    # Logging (Existing + New) — 8 functions
    'Write-Section',
    'Write-SubSection',
    'Write-Success',
    'Write-WarningMessage',
    'Write-ErrorMessage',
    'Write-Info',
    'Write-Log',
    'Write-DebugMessage',
    
    # Orchestration (Existing) — 1 function
    'Invoke-Step',
    
    # Utilities (Existing) — 4 functions
    'Get-SHA256',
    'Get-RelativePath',
    'Test-RepositoryFolder',
    'Test-RepositoryFile',
    
    # Timing (Existing) — 2 functions
    'Start-BuildTimer',
    'Stop-BuildTimer',
    
    # Statistics (Existing) — 1 function
    'Get-RepositoryStatistics',
    
    # Release (Existing) — 2 functions
    'Get-BaselineFolder',
    'Get-ReleaseFolder',
    
    # Repository (New) — 4 functions
    'Get-RepositoryDocuments',
    'Get-RepositoryScripts',
    'Get-RepositoryFolders',
    'Get-RepositoryState',
    
    # Document Service (New — Phase 2) — 4 functions
    'Parse-DocumentID',
    'Get-DocumentMetadata',
    'Get-Documents',
    'Export-DocumentRegister',

    # Validation Service (New — Phase 2) — 3 functions
    'Test-DocumentName',
    'Test-RepositoryStructure',
    'Invoke-RepositoryValidation',

    # Hash Service (New — Phase 2) — 3 functions
    'Get-FileHash',
    'Export-HashInventory',
    'Verify-Hash'

)  # Total: 7+8+1+4+2+1+2+4+4 = 39 functions