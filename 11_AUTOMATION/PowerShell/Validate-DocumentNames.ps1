Import-Module "$PSScriptRoot\Modules\Repository.Common.psm1" -Force

Clear-Host

Write-Host ""
Write-Host "======================================="
Write-Host "Golden Wings Document Name Validator"
Write-Host "======================================="
Write-Host ""

# Use Validation Service
$Results = Invoke-RepositoryValidation

if ($Results.Success) {
    Write-Host "[PASS] All document names comply." -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "[FAIL] Invalid filenames:" -ForegroundColor Red
    Write-Host ""
    foreach ($Error in $Results.Errors) {
        Write-Host "  $Error" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Validation Complete."