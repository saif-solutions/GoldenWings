##############################################################
#
# Golden Wings Enterprise Repository
# Report Generator
#
# Description:
#     Orchestrates the generation of repository reports
#     using the Report Service.
#
# Version : 1.0 (New)
#
##############################################################

$ErrorActionPreference = "Stop"

Import-Module "$PSScriptRoot\Modules\Repository.Common.psm1" -Force

Write-Section "Golden Wings Report Generator"

# Generate health report
$Report = New-Report -Type "Health"

# Export as JSON
$JsonOutput = Join-Path (Get-RepositoryRoot) "08_EVIDENCE\Reports\health_report.json"
Export-Report -Report $Report -OutputPath $JsonOutput -Format "JSON"

# Export as Markdown
$MdOutput = Join-Path (Get-RepositoryRoot) "08_EVIDENCE\Reports\health_report.md"
Export-Report -Report $Report -OutputPath $MdOutput -Format "Markdown"

# Display health summary
$Health = Get-RepositoryHealth
Write-Host ""
Write-Host "Health Summary:"
Write-Host "  Status: $($Health.Status)"
Write-Host "  Documents: $($Health.DocumentCount)"
Write-Host "  Scripts: $($Health.ScriptCount)"
Write-Host "  Evidence: $(if ($Health.EvidenceExists) { 'Present' } else { 'Missing' })"

Write-Host ""
Write-Host "Reports Generated Successfully"
Write-Host ""
Write-Host "JSON Report: $JsonOutput"
Write-Host "Markdown Report: $MdOutput"
Write-Host ""