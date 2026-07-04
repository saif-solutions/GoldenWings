##############################################################
#
# Golden Wings Enterprise Repository
# Hash Inventory Generator
#
# Description:
#     Generates SHA256 hash inventory using direct approach
#
# Version : 2.3 (Stable)
#
##############################################################

$ErrorActionPreference = "Stop"

Import-Module "$PSScriptRoot\Modules\Repository.Common.psm1" -Force

$Root = Get-RepositoryRoot
$OutputFolder = Join-Path $Root "08_EVIDENCE\Hashes"
$OutputFile = Join-Path $OutputFolder "HASHES_2026.1.csv"

# Ensure output folder exists
if (-not (Test-Path $OutputFolder)) {
    New-Item -ItemType Directory -Force -Path $OutputFolder | Out-Null
}

# Get files, excluding archives and the hash folder itself
$Files = Get-ChildItem $Root -Recurse -File -Include *.docx,*.md,*.csv,*.ps1,*.json |
    Where-Object {
        $_.FullName -notmatch "\\09_ARCHIVES\\" -and
        $_.FullName -notmatch "\\08_EVIDENCE\\Hashes\\"
    }

$HashData = foreach ($File in $Files) {
    try {
        # Use PowerShell's built-in Get-FileHash directly (not the framework version)
        $Hash = (Get-FileHash $File.FullName -Algorithm SHA256).Hash
        [PSCustomObject]@{
            Repository_Path = $File.FullName.Replace("$Root\", "")
            Hash = $Hash
        }
    }
    catch {
        Write-WarningMessage "Failed to hash: $($File.FullName)"
    }
}

$HashData | Sort-Object Repository_Path | Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8

Write-Host ""
Write-Host "SHA256 Inventory Generated"
Write-Host ""
Write-Host "Output: $OutputFile"
Write-Host "Files Hashed: $($HashData.Count)"
Write-Host ""