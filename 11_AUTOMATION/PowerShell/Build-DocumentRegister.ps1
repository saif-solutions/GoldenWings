##############################################################
#
# Golden Wings Enterprise Repository
# Document Register Generator
#
# Description:
#     Orchestrates the generation of DOCUMENT_REGISTER.csv
#     using the Document Service.
#
# Version : 2.0 (Refactored)
#
##############################################################

$ErrorActionPreference = "Stop"

Import-Module "$PSScriptRoot\Modules\Repository.Common.psm1" -Force

Start-BuildTimer

Write-Section "Golden Wings Document Register Generator"

$RepositoryRoot = Get-RepositoryRoot
$OutputFile = Join-Path $RepositoryRoot "00_README\DOCUMENT_REGISTER.csv"

# Get documents using the service
$Documents = Get-Documents -ExcludeArchives -ExcludeBaseline

# Export using the service
Export-DocumentRegister -Documents $Documents -OutputPath $OutputFile

Write-Success "Document Register Generated Successfully."

Write-Host ""
Write-Host ("Output File      : {0}" -f $OutputFile)
Write-Host ("Documents        : {0}" -f $Documents.Count)
Write-Host ("Repository Root  : {0}" -f $RepositoryRoot)
Write-Host ("Baseline         : {0}" -f (Get-BaselineName))
Write-Host ("Repository Ver.  : {0}" -f (Get-RepositoryVersion))

Stop-BuildTimer

Write-Host ""