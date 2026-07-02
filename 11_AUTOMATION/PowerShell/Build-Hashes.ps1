# ==========================================
# Golden Wings Enterprise Repository
# Build-Hashes.ps1
# Generates SHA256 hash inventory
# ==========================================

$RepositoryRoot = Split-Path $PSScriptRoot -Parent | Split-Path -Parent

$OutputFolder = Join-Path $RepositoryRoot `
    "08_EVIDENCE\Hashes"

$OutputFile = Join-Path $OutputFolder `
    "HASHES_2026.1.csv"

# Create output folder if needed
if (!(Test-Path $OutputFolder))
{
    New-Item `
        -ItemType Directory `
        -Path $OutputFolder | Out-Null
}

Get-ChildItem `
    $RepositoryRoot `
    -Recurse `
    -File `
    -Include *.docx,*.md,*.csv |
Where-Object {

    $_.FullName -notmatch "\\09_ARCHIVES\\" -and
    $_.FullName -notmatch "\\08_EVIDENCE\\Hashes\\"

} |
Get-FileHash -Algorithm SHA256 |
Sort-Object Path |
Select-Object @{

    Name='Repository_Path'

    Expression={
        $_.Path.Replace($RepositoryRoot + '\','')
    }

},Hash |
Export-Csv `
    $OutputFile `
    -NoTypeInformation `
    -Encoding UTF8

Write-Host ""
Write-Host "SHA256 Inventory Generated"
Write-Host ""
Write-Host $OutputFile