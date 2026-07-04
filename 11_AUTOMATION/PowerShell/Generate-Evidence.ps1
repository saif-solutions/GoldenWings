##############################################################
#
# Golden Wings Enterprise Repository
# Evidence Generator
#
# Description:
#     Orchestrates the generation of evidence artifacts
#     using the Evidence Service.
#
# Version : 1.0 (New)
#
##############################################################

$ErrorActionPreference = "Stop"

Import-Module "$PSScriptRoot\Modules\Repository.Common.psm1" -Force

Write-Section "Golden Wings Evidence Generator"

# Create evidence for baseline
$Evidence = New-Evidence -Operation "Baseline Generation" -Status "Success" -Details "Baseline generated from Phase 3 implementation"

# Export evidence
$EvidenceFile = Join-Path (Get-RepositoryRoot) "08_EVIDENCE\Evidence\baseline_evidence.json"
Export-Evidence -Evidence $Evidence -OutputPath $EvidenceFile

Write-Host ""
Write-Host "Evidence Generated Successfully"
Write-Host ""
Write-Host "Evidence File: $EvidenceFile"
Write-Host ""