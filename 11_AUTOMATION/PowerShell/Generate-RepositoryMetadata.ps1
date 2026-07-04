##############################################################
#
# Golden Wings Enterprise Repository
# Repository Metadata Generator
#
# Description:
#     Orchestrates the generation of repository metadata
#     using the Document Service.
#
# Version : 2.0 (Refactored)
#
##############################################################

$ErrorActionPreference = "Stop"

Import-Module "$PSScriptRoot\Modules\Repository.Common.psm1" -Force

Clear-Host

Write-Host ""
Write-Host "======================================="
Write-Host "Golden Wings Metadata Generator"
Write-Host "======================================="
Write-Host ""

$Root = Get-RepositoryRoot

$MetadataFolder = Join-Path $Root "10_MACHINE_READABLE\Metadata"
$JsonFolder     = Join-Path $Root "10_MACHINE_READABLE\JSON"

New-Item -ItemType Directory -Force -Path $MetadataFolder | Out-Null
New-Item -ItemType Directory -Force -Path $JsonFolder | Out-Null

# Get all files using the repository service
$Files = Get-ChildItem $Root -Recurse -File | Where-Object { $_.FullName -notmatch "\\.git\\" }

$Inventory = foreach($File in $Files) {
    $Hash = Get-SHA256 -Path $File.FullName
    
    [PSCustomObject]@{
        DocumentName = $File.Name
        Extension = $File.Extension
        RepositoryPath = Get-RelativePath -FullPath $File.FullName
        Folder = Split-Path $File.DirectoryName -Leaf
        SizeKB = [Math]::Round($File.Length/1KB,2)
        LastModified = $File.LastWriteTime
        SHA256 = $Hash
        Version = Get-RepositoryVersion
        Status = "Controlled"
        Owner = "Golden Wings"
    }
}

$CsvOutput = Join-Path $MetadataFolder "repository-metadata.csv"
$Inventory | Sort-Object RepositoryPath | Export-Csv $CsvOutput -NoTypeInformation

$JsonOutput = Join-Path $JsonFolder "repository.json"
$Inventory | Sort-Object RepositoryPath | ConvertTo-Json -Depth 4 | Out-File $JsonOutput -Encoding UTF8

Write-Host ""
Write-Host "Metadata Generated Successfully"
Write-Host ""
Write-Host $CsvOutput
Write-Host $JsonOutput
Write-Host ""
Write-Host "Documents Processed:" $Inventory.Count
Write-Host ""