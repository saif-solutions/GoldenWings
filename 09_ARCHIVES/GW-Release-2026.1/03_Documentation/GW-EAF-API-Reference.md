# GW-EAF API Reference

## Overview

The Golden Wings Enterprise Automation Framework (GW-EAF) provides **55** exported functions organized into **10 services**.

## Service Index

| Service | Functions | Description |
|---------|-----------|-------------|
| Configuration | 7 | Repository configuration |
| Logging | 8 | Structured logging |
| Orchestration | 1 | Build orchestration |
| Utilities | 4 | File/path utilities |
| Timing | 2 | Build timing |
| Statistics | 1 | Repository statistics |
| Release | 2 | Release helpers |
| Repository | 4 | Repository discovery |
| Document | 4 | Document metadata |
| Validation | 3 | Validation framework |
| Hash | 3 | Hash generation |
| Manifest | 3 | Manifest generation |
| Evidence | 3 | Evidence management |
| Report | 3 | Report generation |
| Git | 7 | Git operations |
| **Total** | **55** | |

---

## Function Reference

### Export-DocumentRegister

**Category:** Repository.Common

**Syntax:**
`powershell

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
    
### Export-Evidence

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [PSCustomObject]$Evidence,
            
            [Parameter(Mandatory)]
            [string]$OutputPath
        )
        
        # Ensure directory exists
        $Directory = Split-Path $OutputPath -Parent
        if ($Directory -and -not (Test-Path $Directory)) {
            New-Item -ItemType Directory -Force -Path $Directory | Out-Null
        }
        
        $Evidence | ConvertTo-Json -Depth 4 | Out-File -FilePath $OutputPath -Encoding UTF8
        Write-Success "Evidence exported to: $OutputPath"
    
### Export-HashInventory

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [string]$OutputPath,
            
            [ValidateSet('MD5', 'SHA1', 'SHA256', 'SHA384', 'SHA512')]
            [string]$Algorithm = 'SHA256'
        )
        
        $Root = Get-RepositoryRoot
        $Config = Get-RepositoryConfiguration
        
        # Ensure output directory exists
        $OutputDir = Split-Path $OutputPath -Parent
        if ($OutputDir -and -not (Test-Path $OutputDir)) {
            New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
        }
        
        # Get the output filename for exclusion
        $OutputFileName = Split-Path $OutputPath -Leaf
        
        # Build exclusion patterns - using simple string matching (NOT regex)
        $ExcludePatterns = @(
            "\09_ARCHIVES\",
            "\08_EVIDENCE\Hashes\",
            $OutputFileName
        )
        
        $Files = Get-ChildItem $Root -Recurse -File -Include *.docx,*.md,*.csv,*.ps1,*.json |
            Where-Object {
                $Include = $true
                $FullPath = $_.FullName
                foreach ($Pattern in $ExcludePatterns) {
                    # Use -like with wildcards instead of -match (regex)
                    if ($FullPath -like "*$Pattern*") {
                        $Include = $false
                        break
                    }
                }
                $Include
            }
        
        $Inventory = foreach ($File in $Files) {
            try {
                $Hash = Get-RepositoryFileHash -Path $File.FullName -Algorithm $Algorithm
                
                [PSCustomObject]@{
                    Repository_Path = Get-RelativePath -FullPath $File.FullName
                    Hash = $Hash
                    Algorithm = $Algorithm
                    FileName = $File.Name
                    LastModified = $File.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
                }
            }
            catch {
                Write-WarningMessage "Failed to hash: $($File.FullName)"
            }
        }
        
        $Inventory | Sort-Object Repository_Path | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8
        
        return $Inventory
    
### Export-Manifest

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [string]$Content,
            
            [Parameter(Mandatory)]
            [string]$OutputPath
        )
        
        $Content | Set-Content -Path $OutputPath -Encoding UTF8
        Write-Success "Manifest exported to: $OutputPath"
    
### Export-Report

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [PSCustomObject]$Report,
            
            [Parameter(Mandatory)]
            [string]$OutputPath,
            
            [ValidateSet('JSON','Markdown')]
            [string]$Format = 'JSON'
        )
        
        # Ensure directory exists
        $Directory = Split-Path $OutputPath -Parent
        if ($Directory -and -not (Test-Path $Directory)) {
            New-Item -ItemType Directory -Force -Path $Directory | Out-Null
        }
        
        if ($Format -eq 'JSON') {
            $Report | ConvertTo-Json -Depth 4 | Out-File -FilePath $OutputPath -Encoding UTF8
        } else {
            # Markdown format
            $Content = @"
    # Repository Health Report
    
    ## Summary
    | Property | Value |
    |----------|-------|
    | Report Type | $($Report.ReportType) |
    | Timestamp | $($Report.Timestamp) |
    | Repository | $($Report.Repository) |
    | Version | $($Report.Version) |
    | Baseline | $($Report.Baseline) |
    | Status | $($Report.Status) |
    
    ## Health
    | Metric | Value |
    |--------|-------|
    | Documents | $($Report.Health.DocumentCount) |
    | Scripts | $($Report.Health.ScriptCount) |
    | Folders | $($Report.Health.FolderCount) |
    | Last Modified | $($Report.Health.LastModified) |
    
    ## Statistics
    | Metric | Value |
    |--------|-------|
    | Documents (.docx) | $($Report.Statistics.Documents) |
    | Scripts (.ps1) | $($Report.Statistics.Scripts) |
    | Markdown (.md) | $($Report.Statistics.Markdown) |
    | CSV Files | $($Report.Statistics.CSV) |
    | JSON Files | $($Report.Statistics.JSON) |
    | Folders | $($Report.Statistics.Folders) |
    
    ## Evidence Status
    | Property | Value |
    |----------|-------|
    | Exists | $($Report.Evidence.Exists) |
    | Total Files | $($Report.Evidence.TotalFiles) |
    | Last Evidence | $($Report.Evidence.LastEvidence) |
    
    ---
    Generated by GW-EAF Report Service
    "@
            $Content | Set-Content -Path $OutputPath -Encoding UTF8
        }
        
        Write-Success "Report exported to: $OutputPath"
    
### Get-BaselineFolder

**Category:** Repository.Common

**Syntax:**
`powershell

        $Config = Get-RepositoryConfiguration
        return $Config.BaselineFolder
    
### Get-BaselineName

**Category:** Repository.Common

**Syntax:**
`powershell

        return $script:CONFIG.Baseline
    
### Get-ConfigValue

**Category:** Repository.Common

**Syntax:**
`powershell

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
    
### Get-CurrentDate

**Category:** Repository.Common

**Syntax:**
`powershell

        Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
### Get-DocumentMetadata

**Category:** Repository.Common

**Syntax:**
`powershell

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
    
### Get-Documents

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param(
            [switch]$ExcludeArchives,
            [switch]$ExcludeBaseline
        )
        
        return Get-RepositoryDocuments -ExcludeArchives:$ExcludeArchives -ExcludeBaseline:$ExcludeBaseline
    
### Get-EvidenceStatus

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param()
        
        $Config = Get-RepositoryConfiguration
        $EvidenceFolder = Join-Path $Config.EvidenceFolder "Evidence"
        
        if (-not (Test-Path $EvidenceFolder)) {
            return [PSCustomObject]@{
                Exists = $false
                EvidenceFiles = @()
                TotalFiles = 0
                LastEvidence = $null
            }
        }
        
        $Files = Get-ChildItem $EvidenceFolder -Filter *.json -File | Sort-Object LastWriteTime -Descending
        $LastEvidence = if ($Files.Count -gt 0) { $Files[0].LastWriteTime } else { $null }
        
        [PSCustomObject]@{
            Exists = $true
            EvidenceFiles = $Files.Name
            TotalFiles = $Files.Count
            LastEvidence = $LastEvidence
        }
    
### Get-GitBranches

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param()
        
        $Root = Get-RepositoryRoot
        
        if (-not (Test-Path (Join-Path $Root ".git"))) {
            Write-WarningMessage "Not a Git repository"
            return @()
        }
        
        try {
            # Use --format to ensure consistent output
            $Branches = & git -C $Root branch --format="%(refname:short)" 2>$null
            
            # If that fails, try the standard branch command
            if (-not $Branches) {
                $Branches = & git -C $Root branch 2>$null
            }
            
            $BranchList = @()
            
            if ($Branches) {
                foreach ($Line in $Branches) {
                    # Handle the case where 'git branch' output has a '*' for current branch
                    $IsCurrent = $Line -match "^\*"
                    $Name = $Line.TrimStart("* ").Trim()
                    
                    # Skip empty lines
                    if ([string]::IsNullOrWhiteSpace($Name)) {
                        continue
                    }
                    
                    $BranchList += [PSCustomObject]@{
                        Name = $Name
                        IsCurrent = $IsCurrent
                    }
                }
            }
            
            # Ensure we return at least an empty array
            return $BranchList
        }
        catch {
            Write-ErrorMessage "Failed to get branches: $($_.Exception.Message)"
            return @()
        }
    
### Get-GitCommitHistory

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param(
            [int]$Count = 10
        )
        
        $Root = Get-RepositoryRoot
        
        if (-not (Test-Path (Join-Path $Root ".git"))) {
            Write-WarningMessage "Not a Git repository"
            return $null
        }
        
        try {
            $Commits = & git -C $Root log --oneline -n $Count 2>$null
            $CommitList = @()
            
            foreach ($Line in $Commits) {
                if ($Line -match "^(\S+) (.+)$") {
                    $CommitList += [PSCustomObject]@{
                        Hash = $Matches[1]
                        Message = $Matches[2]
                    }
                }
            }
            
            return $CommitList
        }
        catch {
            Write-ErrorMessage "Failed to get commit history: $($_.Exception.Message)"
            return $null
        }
    
### Get-GitStatus

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param()
        
        $Root = Get-RepositoryRoot
        
        # Check if we're in a Git repository
        if (-not (Test-Path (Join-Path $Root ".git"))) {
            return [PSCustomObject]@{
                IsGitRepository = $false
                Status = "Not a Git repository"
            }
        }
        
        try {
            # Get current branch
            $Branch = & git -C $Root rev-parse --abbrev-ref HEAD 2>$null
            if (-not $Branch) { $Branch = "(unknown)" }
            
            # Get commit hash
            $Commit = & git -C $Root rev-parse HEAD 2>$null
            if (-not $Commit) { $Commit = "(unknown)" }
            
            # Check if working tree is clean
            $Status = & git -C $Root status --porcelain 2>$null
            $IsClean = -not $Status
            
            # Count changes
            $Changes = @{
                Modified = ($Status | Where-Object { $_ -match "^ M" }).Count
                Added = ($Status | Where-Object { $_ -match "^A " }).Count
                Deleted = ($Status | Where-Object { $_ -match "^D " }).Count
                Untracked = ($Status | Where-Object { $_ -match "^\?\?" }).Count
            }
            
            return [PSCustomObject]@{
                IsGitRepository = $true
                Branch = $Branch
                Commit = $Commit
                IsClean = $IsClean
                Changes = $Changes
                StatusOutput = $Status
                Root = $Root
            }
        }
        catch {
            return [PSCustomObject]@{
                IsGitRepository = $false
                Status = "Error: $($_.Exception.Message)"
            }
        }
    
### Get-ManifestData

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param()
        
        $Config = Get-RepositoryConfiguration
        $Stats = Get-RepositoryStatistics
        $State = Get-RepositoryState
        
        [PSCustomObject]@{
            Repository = "Golden Wings Enterprise Repository"
            BaselineID = $Config.Baseline
            Version = $Config.Version
            Status = "Approved Baseline"
            Date = Get-CurrentDate
            ControlledDocuments = $Stats.Documents
            Root = $Config.Root
            DocumentCount = $State.DocumentCount
            ScriptCount = $State.ScriptCount
            FolderCount = $State.FolderCount
            LastModified = $State.LastModified
        }
    
### Get-RelativePath

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [string]$FullPath
        )
        
        $Root = Get-RepositoryRoot
        return $FullPath.Replace($Root, "").TrimStart("\")
    
### Get-ReleaseFolder

**Category:** Repository.Common

**Syntax:**
`powershell

        $Config = Get-RepositoryConfiguration
        return $Config.ReleaseFolder
    
### Get-ReleaseName

**Category:** Repository.Common

**Syntax:**
`powershell

        return $script:CONFIG.Release
    
### Get-RepositoryConfiguration

**Category:** Repository.Common

**Syntax:**
`powershell

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
    
### Get-RepositoryDocuments

**Category:** Repository.Common

**Syntax:**
`powershell

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
    
### Get-RepositoryFileHash

**Category:** Repository.Common

**Syntax:**
`powershell

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
        
        return (Get-FileHash -Path $Path -Algorithm $Algorithm).Hash
    
### Get-RepositoryFolders

**Category:** Repository.Common

**Syntax:**
`powershell

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
    
### Get-RepositoryHealth

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param()
        
        $Report = New-Report -Type "Health"
        
        [PSCustomObject]@{
            Status = $Report.Status
            DocumentCount = $Report.Health.DocumentCount
            ScriptCount = $Report.Health.ScriptCount
            LastModified = $Report.Health.LastModified
            EvidenceExists = $Report.Evidence.Exists
            ReportTimestamp = $Report.Timestamp
        }
    
### Get-RepositoryRoot

**Category:** Repository.Common

**Syntax:**
`powershell

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
    
### Get-RepositoryScripts

**Category:** Repository.Common

**Syntax:**
`powershell

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
    
### Get-RepositoryState

**Category:** Repository.Common

**Syntax:**
`powershell

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
    
### Get-RepositoryStatistics

**Category:** Repository.Common

**Syntax:**
`powershell

        $Root = Get-RepositoryRoot
        
        [PSCustomObject]@{
            Documents = (Get-ChildItem $Root -Recurse -Filter *.docx -File).Count
            Scripts = (Get-ChildItem $Root -Recurse -Filter *.ps1 -File).Count
            Markdown = (Get-ChildItem $Root -Recurse -Filter *.md -File).Count
            CSV = (Get-ChildItem $Root -Recurse -Filter *.csv -File).Count
            JSON = (Get-ChildItem $Root -Recurse -Filter *.json -File).Count
            Folders = (Get-ChildItem $Root -Directory -Recurse).Count
        }
    
### Get-RepositoryVersion

**Category:** Repository.Common

**Syntax:**
`powershell

        return $script:CONFIG.Version
    
### Get-SHA256

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [string]$Path
        )
        
        if (-not (Test-Path $Path)) {
            throw "File not found: $Path"
        }
        
        return (Get-FileHash $Path -Algorithm SHA256).Hash
    
### Invoke-GitPull

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param(
            [string]$Remote = "origin",
            [string]$Branch = ""
        )
        
        $Root = Get-RepositoryRoot
        
        if (-not (Test-Path (Join-Path $Root ".git"))) {
            throw "Not a Git repository"
        }
        
        if (-not $Branch) {
            $Branch = & git -C $Root rev-parse --abbrev-ref HEAD 2>$null
            if (-not $Branch) {
                throw "Could not determine current branch"
            }
        }
        
        try {
            & git -C $Root pull $Remote $Branch 2>&1 | Out-Null
            Write-Success "Pulled from $Remote/$Branch"
            return $true
        }
        catch {
            Write-ErrorMessage "Failed to pull: $($_.Exception.Message)"
            return $false
        }
    
### Invoke-GitPush

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param(
            [string]$Remote = "origin",
            [string]$Branch = ""
        )
        
        $Root = Get-RepositoryRoot
        
        if (-not (Test-Path (Join-Path $Root ".git"))) {
            throw "Not a Git repository"
        }
        
        if (-not $Branch) {
            $Branch = & git -C $Root rev-parse --abbrev-ref HEAD 2>$null
            if (-not $Branch) {
                throw "Could not determine current branch"
            }
        }
        
        try {
            & git -C $Root push $Remote $Branch 2>&1 | Out-Null
            Write-Success "Pushed to $Remote/$Branch"
            return $true
        }
        catch {
            Write-ErrorMessage "Failed to push: $($_.Exception.Message)"
            return $false
        }
    
### Invoke-RepositoryValidation

**Category:** Repository.Common

**Syntax:**
`powershell

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
    
### Invoke-Step

**Category:** Repository.Common

**Syntax:**
`powershell

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
    
### New-Evidence

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [string]$Operation,
            
            [ValidateSet('Success','Warning','Error')]
            [string]$Status = 'Success',
            
            [string]$Details = ''
        )
        
        $Config = Get-RepositoryConfiguration
        
        [PSCustomObject]@{
            Operation = $Operation
            Status = $Status
            Timestamp = Get-CurrentDate
            Version = $Config.Version
            Baseline = $Config.Baseline
            Repository = $Config.Root
            Details = $Details
            EvidenceID = [Guid]::NewGuid().ToString()
        }
    
### New-GitCommit

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [string]$Message,
            
            [switch]$StageAll
        )
        
        $Root = Get-RepositoryRoot
        
        if (-not (Test-Path (Join-Path $Root ".git"))) {
            throw "Not a Git repository"
        }
        
        # Check if there are changes to commit
        $Status = & git -C $Root status --porcelain 2>$null
        if (-not $Status) {
            Write-WarningMessage "No changes to commit"
            return $false
        }
        
        try {
            if ($StageAll) {
                & git -C $Root add -A 2>&1 | Out-Null
                Write-Info "Staged all changes"
            }
            
            & git -C $Root commit -m "$Message" 2>&1 | Out-Null
            Write-Success "Commit created: $Message"
            
            $Commit = & git -C $Root rev-parse HEAD 2>$null
            Write-Info "Commit hash: $Commit"
            
            return $true
        }
        catch {
            Write-ErrorMessage "Failed to create commit: $($_.Exception.Message)"
            return $false
        }
    
### New-GitTag

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [string]$TagName,
            
            [string]$Message = ""
        )
        
        $Root = Get-RepositoryRoot
        
        if (-not (Test-Path (Join-Path $Root ".git"))) {
            throw "Not a Git repository"
        }
        
        # Check if tag already exists
        $ExistingTags = & git -C $Root tag -l $TagName 2>$null
        if ($ExistingTags) {
            Write-WarningMessage "Tag '$TagName' already exists"
            return $false
        }
        
        try {
            if ($Message) {
                & git -C $Root tag -a $TagName -m "$Message" 2>&1 | Out-Null
            } else {
                & git -C $Root tag $TagName 2>&1 | Out-Null
            }
            Write-Success "Tag created: $TagName"
            return $true
        }
        catch {
            Write-ErrorMessage "Failed to create tag: $($_.Exception.Message)"
            return $false
        }
    
### New-Manifest

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param()
        
        $Data = Get-ManifestData
        
        $Content = @"
    # Golden Wings Enterprise Repository Baseline
    
    ## Baseline Information
    
    | Property | Value |
    |----------|-------|
    | Repository | $($Data.Repository) |
    | Baseline ID | $($Data.BaselineID) |
    | Version | $($Data.Version) |
    | Status | $($Data.Status) |
    | Date | $($Data.Date) |
    | Controlled Documents | $($Data.ControlledDocuments) |
    
    ---
    
    ## Repository Structure
    
    00_README
    
    01_GOVERNANCE
    
    02_CONSTITUTIONAL_FRAMEWORK
    
    03_ENTERPRISE_ARCHITECTURE
    
    04_ENTERPRISE_ASSURANCE
    
    05_ENTERPRISE_BASELINE
    
    06_GOVERNANCE_RECORDS
    
    07_TEMPLATES
    
    08_EVIDENCE
    
    09_ARCHIVES
    
    10_MACHINE_READABLE
    
    11_AUTOMATION
    
    99_REFERENCE
    
    ---
    
    ## Controlled Document Register
    
    00_README/DOCUMENT_REGISTER.csv
    
    ---
    
    ## Repository Hash Inventory
    
    08_EVIDENCE/Hashes/HASHES_2026.1.csv
    
    ---
    
    Generated Automatically by GW-EAF Manifest Service
    "@
        
        return $Content
    
### New-Report

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param(
            [ValidateSet('Health','Summary','Full')]
            [string]$Type = 'Health'
        )
        
        $Config = Get-RepositoryConfiguration
        $State = Get-RepositoryState
        $Stats = Get-RepositoryStatistics
        $EvidenceStatus = Get-EvidenceStatus
        
        $Report = @{
            ReportType = $Type
            Timestamp = Get-CurrentDate
            Repository = $Config.Root
            Version = $Config.Version
            Baseline = $Config.Baseline
            Health = @{
                DocumentCount = $State.DocumentCount
                ScriptCount = $State.ScriptCount
                FolderCount = $State.FolderCount
                LastModified = $State.LastModified
            }
            Statistics = @{
                Documents = $Stats.Documents
                Scripts = $Stats.Scripts
                Markdown = $Stats.Markdown
                CSV = $Stats.CSV
                JSON = $Stats.JSON
                Folders = $Stats.Folders
            }
            Evidence = @{
                Exists = $EvidenceStatus.Exists
                TotalFiles = $EvidenceStatus.TotalFiles
                LastEvidence = $EvidenceStatus.LastEvidence
            }
            Status = "Healthy"
        }
        
        # Determine health status
        if ($State.DocumentCount -eq 0) {
            $Report.Status = "Warning"
        }
        if (-not $EvidenceStatus.Exists) {
            $Report.Status = "Warning"
        }
        
        return $Report
    
### Parse-DocumentID

**Category:** Repository.Common

**Syntax:**
`powershell

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
    
### Start-BuildTimer

**Category:** Repository.Common

**Syntax:**
`powershell

        $script:BuildStart = Get-Date
    
### Stop-BuildTimer

**Category:** Repository.Common

**Syntax:**
`powershell

        if ($script:BuildStart) {
            $Elapsed = (Get-Date) - $script:BuildStart
            Write-Host ""
            Write-Host "Total Build Time : $($Elapsed.ToString())"
        }
    
### Test-DocumentName

**Category:** Repository.Common

**Syntax:**
`powershell

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
    
### Test-RepositoryFile

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [string]$File
        )
        
        $Path = Join-Path (Get-RepositoryRoot) $File
        return Test-Path $Path
    
### Test-RepositoryFolder

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [string]$Folder
        )
        
        $Path = Join-Path (Get-RepositoryRoot) $Folder
        return Test-Path $Path
    
### Test-RepositoryStructure

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param()
        
        $Root = Get-RepositoryRoot
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
    
### Verify-Hash

**Category:** Repository.Common

**Syntax:**
`powershell

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
            $ComputedHash = Get-RepositoryFileHash -Path $Path -Algorithm $Algorithm
            return ($ComputedHash -eq $ExpectedHash)
        }
        catch {
            Write-ErrorMessage "Failed to verify hash: $($_.Exception.Message)"
            return $false
        }
    
### Write-DebugMessage

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param([string]$Message)
        Write-Log -Message $Message -Level 'Debug'
    
### Write-ErrorMessage

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param([string]$Message)
        Write-Log -Message $Message -Level 'Error'
    
### Write-Info

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param([string]$Message)
        Write-Log -Message $Message -Level 'Info'
    
### Write-Log

**Category:** Repository.Common

**Syntax:**
`powershell

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
    
### Write-Section

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param([string]$Title)
        
        Write-Host ""
        Write-Host "=========================================="
        Write-Host $Title
        Write-Host "=========================================="
        Write-Host ""
    
### Write-SubSection

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param([string]$Title)
        
        Write-Host ""
        Write-Host "------------------------------------------"
        Write-Host $Title
        Write-Host "------------------------------------------"
    
### Write-Success

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param([string]$Message)
        Write-Log -Message $Message -Level 'Success'
    
### Write-WarningMessage

**Category:** Repository.Common

**Syntax:**
`powershell

        [CmdletBinding()]
        param([string]$Message)
        Write-Log -Message $Message -Level 'Warning'
    
---

## Version Information

| Property | Value |
|----------|-------|
| **Version** | 1.9.0 |
| **Baseline** | GW-BASELINE-2026.1 |
| **Git Tag** | Repository.Common-v1.9.0 |
| **Total Functions** | 55 |

---

*Generated by GW-EAF API Documentation Generator*
