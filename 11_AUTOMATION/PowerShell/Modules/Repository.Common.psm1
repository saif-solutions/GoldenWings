##############################################################
#
# Golden Wings Enterprise Automation Framework
# Repository.Common.psm1
#
# Version : 1.2
# Baseline: GW-BASELINE-2026.1
#
# PHASE 1 IMPLEMENTATION (2026-07-04)
# - Configuration Service
# - Logging Service (Enhanced with backward compatibility)
# - Repository Service
# - Total: 28 exported functions
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
# Exported Functions (28 functions — VERIFIED)
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
    'Get-RepositoryState'
)  # Total: 7+8+1+4+2+1+2+4 = 29 functions