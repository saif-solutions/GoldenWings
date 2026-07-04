##############################################################
#
# Golden Wings Enterprise Repository
# Manifest Generator
#
# Description:
#     Orchestrates the generation of MANIFEST.md
#     using the Manifest Service.
#
# Version : 2.0 (Refactored)
#
##############################################################

$ErrorActionPreference = "Stop"

Import-Module "$PSScriptRoot\Modules\Repository.Common.psm1" -Force

Clear-Host

Write-Section "Golden Wings Manifest Generator"

# Get baseline folder using Configuration Service
$BaselineFolder = Get-BaselineFolder
$OutputFile = Join-Path $BaselineFolder "MANIFEST.md"

# Generate manifest using Manifest Service
$ManifestContent = New-Manifest

# Export manifest using Manifest Service
Export-Manifest -Content $ManifestContent -OutputPath $OutputFile

Write-Host ""
Write-Host "Manifest Generated Successfully"
Write-Host ""
Write-Host "Output File: $OutputFile"
Write-Host ""