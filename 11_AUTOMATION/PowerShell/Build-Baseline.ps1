##############################################################
#
# Golden Wings Enterprise Baseline Builder
#
# Description:
#     Master orchestration script for building a complete
#     Golden Wings Enterprise Repository baseline.
#
# Version : 2.0
# Baseline: GW-BASELINE-2026.1
#
##############################################################

$ErrorActionPreference = "Stop"

Import-Module "$PSScriptRoot\Modules\Repository.Common.psm1" -Force

Clear-Host

Start-BuildTimer

Write-Section "Golden Wings Enterprise Baseline Builder"

#-------------------------------------------------------------
# Build Pipeline
#-------------------------------------------------------------

$BuildSteps = @(

    @{
        Name   = "Generating Repository Manifest"
        Script = "Generate-Manifest.ps1"
    },

    @{
        Name   = "Building Document Register"
        Script = "Build-DocumentRegister.ps1"
    },

    @{
        Name   = "Building SHA256 Inventory"
        Script = "Build-Hashes.ps1"
    },

    @{
        Name   = "Validating Document Names"
        Script = "Validate-DocumentNames.ps1"
    },

    @{
        Name   = "Validating Repository Structure"
        Script = "Validate-RepositoryStructure.ps1"
    },

    @{
        Name   = "Verifying Repository"
        Script = "Verify-Repository.ps1"
    },

    @{
        Name   = "Building Repository Release"
        Script = "Release-Repository.ps1"
    }

)

#-------------------------------------------------------------
# Execute Build Pipeline
#-------------------------------------------------------------

$StepNumber = 1
$TotalSteps = $BuildSteps.Count

foreach ($Step in $BuildSteps) {

    Invoke-Step "Step $StepNumber of $TotalSteps - $($Step.Name)" {

        & (Join-Path $PSScriptRoot $Step.Script)

    }

    $StepNumber++

}

#-------------------------------------------------------------
# Repository Summary
#-------------------------------------------------------------

Write-Section "Repository Summary"

$Statistics = Get-RepositoryStatistics

Write-Host ("Repository Root : {0}" -f (Get-RepositoryRoot))
Write-Host ("Repository Version : {0}" -f (Get-RepositoryVersion))
Write-Host ("Baseline : {0}" -f (Get-BaselineName))
Write-Host ("Release : {0}" -f (Get-ReleaseName))
Write-Host ("Generated : {0}" -f (Get-CurrentDate))

Write-Host ""

Write-Host ("Documents : {0}" -f $Statistics.Documents)
Write-Host ("PowerShell Scripts : {0}" -f $Statistics.Scripts)
Write-Host ("Markdown Files : {0}" -f $Statistics.Markdown)
Write-Host ("CSV Files : {0}" -f $Statistics.CSV)
Write-Host ("JSON Files : {0}" -f $Statistics.JSON)
Write-Host ("Folders : {0}" -f $Statistics.Folders)

Stop-BuildTimer

Write-Host ""

Write-Success "Golden Wings Enterprise Baseline Build Completed Successfully."

Write-Host ""