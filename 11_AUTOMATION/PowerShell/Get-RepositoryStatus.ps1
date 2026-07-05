##############################################################
#
# Golden Wings Enterprise Repository
# Repository Status
#
# Description:
#     Displays repository status including Git information
#
# Version : 1.0 (New)
#
##############################################################

$ErrorActionPreference = "Stop"

Import-Module "$PSScriptRoot\Modules\Repository.Common.psm1" -Force

Write-Section "Golden Wings Repository Status"

# Repository Information
$Config = Get-RepositoryConfiguration
$State = Get-RepositoryState

Write-Host "Repository Information:"
Write-Host "  Root: $($Config.Root)"
Write-Host "  Version: $($Config.Version)"
Write-Host "  Baseline: $($Config.Baseline)"
Write-Host "  Release: $($Config.Release)"
Write-Host ""
Write-Host "Repository State:"
Write-Host "  Documents: $($State.DocumentCount)"
Write-Host "  Scripts: $($State.ScriptCount)"
Write-Host "  Folders: $($State.FolderCount)"
Write-Host "  Last Modified: $($State.LastModified)"
Write-Host ""

# Git Information
$GitStatus = Get-GitStatus

if ($GitStatus.IsGitRepository) {
    Write-Host "Git Status:"
    Write-Host "  Branch: $($GitStatus.Branch)"
    Write-Host "  Commit: $($GitStatus.Commit)"
    Write-Host "  Clean: $(if ($GitStatus.IsClean) { 'Yes' } else { 'No' })"
    
    if (-not $GitStatus.IsClean) {
        Write-Host "  Changes:"
        Write-Host "    Modified: $($GitStatus.Changes.Modified)"
        Write-Host "    Added: $($GitStatus.Changes.Added)"
        Write-Host "    Deleted: $($GitStatus.Changes.Deleted)"
        Write-Host "    Untracked: $($GitStatus.Changes.Untracked)"
    }
    
    Write-Host ""
    Write-Host "Recent Commits:"
    $Commits = Get-GitCommitHistory -Count 5
    foreach ($Commit in $Commits) {
        Write-Host "  $($Commit.Hash) $($Commit.Message)"
    }
} else {
    Write-Host "Git Status: Not a Git repository"
}

Write-Host ""
Write-Host "Repository Status Complete."