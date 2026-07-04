Import-Module "$PSScriptRoot\Modules\Repository.Common.psm1" -Force

Clear-Host

Write-Host ""
Write-Host "========================================="
Write-Host "Golden Wings Repository Structure Check"
Write-Host "========================================="
Write-Host ""

# Use Validation Service
$Structure = Test-RepositoryStructure

if ($Structure.Success) {
    Write-Host "[PASS] All required folders exist." -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "[FAIL] Missing folders:" -ForegroundColor Red
    Write-Host ""
    foreach ($Folder in $Structure.MissingFolders) {
        Write-Host "  $Folder" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Validation Complete."