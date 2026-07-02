Clear-Host

$Root = "D:\GoldenWings"

$Docx = (Get-ChildItem $Root -Recurse -File -Filter *.docx).Count
$Markdown = (Get-ChildItem $Root -Recurse -File -Filter *.md).Count
$CSV = (Get-ChildItem $Root -Recurse -File -Filter *.csv).Count
$PowerShell = (Get-ChildItem $Root -Recurse -File -Filter *.ps1).Count
$JSON = (Get-ChildItem $Root -Recurse -File -Filter *.json).Count

$Folders = (Get-ChildItem $Root -Recurse -Directory).Count

$Size = (Get-ChildItem $Root -Recurse -File |
    Measure-Object Length -Sum).Sum

$SizeMB = "{0:N2}" -f ($Size / 1MB)

$LastModified = (
    Get-ChildItem $Root -Recurse -File |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1
).LastWriteTime

Write-Host ""
Write-Host "======================================="
Write-Host "Golden Wings Repository Statistics"
Write-Host "======================================="
Write-Host ""

Write-Host ("Documents (.docx)....... {0}" -f $Docx)
Write-Host ("Markdown (.md).......... {0}" -f $Markdown)
Write-Host ("CSV Files............... {0}" -f $CSV)
Write-Host ("PowerShell Scripts...... {0}" -f $PowerShell)
Write-Host ("JSON Files.............. {0}" -f $JSON)
Write-Host ("Folders................ {0}" -f $Folders)
Write-Host ("Repository Size......... {0} MB" -f $SizeMB)
Write-Host ("Last Modified........... {0}" -f $LastModified)

Write-Host ""
Write-Host "Statistics Complete."