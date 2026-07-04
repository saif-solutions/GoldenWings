Import-Module "$PSScriptRoot\Modules\Repository.Common.psm1" -Force

Clear-Host

$Root = Get-RepositoryRoot

$RequiredFolders = @(

"00_README",
"01_GOVERNANCE",
"02_CONSTITUTIONAL_FRAMEWORK",

"03_ENTERPRISE_ARCHITECTURE",
"03_ENTERPRISE_ARCHITECTURE\03.01_Business_Architecture",
"03_ENTERPRISE_ARCHITECTURE\03.02_Business_Rules",
"03_ENTERPRISE_ARCHITECTURE\03.03_Information_Architecture",
"03_ENTERPRISE_ARCHITECTURE\03.04_User_Experience",
"03_ENTERPRISE_ARCHITECTURE\03.05_Application_Architecture",
"03_ENTERPRISE_ARCHITECTURE\03.06_Technology_Architecture",
"03_ENTERPRISE_ARCHITECTURE\03.07_Delivery_Operations",

"04_ENTERPRISE_ASSURANCE",

"05_ENTERPRISE_BASELINE",
"06_GOVERNANCE_RECORDS",
"07_TEMPLATES",
"08_EVIDENCE",
"09_ARCHIVES",
"10_MACHINE_READABLE",
"11_AUTOMATION",
"99_REFERENCE"

)

Write-Host ""
Write-Host "========================================="
Write-Host "Golden Wings Repository Structure Check"
Write-Host "========================================="
Write-Host ""

$Errors = 0

foreach($Folder in $RequiredFolders)
{

    $Path = Join-Path $Root $Folder

    if(Test-Path $Path)
    {
        Write-Host "[PASS] $Folder"
    }
    else
    {
        Write-Host "[FAIL] $Folder"
        $Errors++
    }

}

Write-Host ""

if($Errors -eq 0)
{
    Write-Host "Repository Structure Validation PASSED"
}
else
{
    Write-Host "$Errors folder(s) missing."
}

Write-Host ""
Write-Host "Validation Complete."