##############################################################
#
# Golden Wings Enterprise Repository
# Hash Inventory Generator
#
# Description:
#     Orchestrates the generation of SHA256 hash inventory
#     using the Hash Service.
#
# Version : 2.0 (Refactored)
#
##############################################################

$ErrorActionPreference = "Stop"

Import-Module "$PSScriptRoot\Modules\Repository.Common.psm1" -Force

$Root = Get-RepositoryRoot
$OutputFolder = Join-Path $Root "08_EVIDENCE\Hashes"
$OutputFile = Join-Path $OutputFolder "HASHES_2026.1.csv"

# Ensure output folder exists
New-Item -ItemType Directory -Force -Path $OutputFolder | Out-Null

# Generate hash inventory using the service
Export-HashInventory -OutputPath $OutputFile

Write-Host ""
Write-Host "SHA256 Inventory Generated"
Write-Host ""
Write-Host $OutputFile