Import-Module "$PSScriptRoot\Modules\Repository.Common.psm1" -Force

Clear-Host

$Stats = Get-RepositoryStatistics

Write-Host ""
Write-Host "======================================="
Write-Host "Golden Wings Repository Statistics"
Write-Host "======================================="
Write-Host ""

Write-Host ("Documents (.docx)....... {0}" -f $Stats.Documents)
Write-Host ("PowerShell Scripts...... {0}" -f $Stats.Scripts)
Write-Host ("Markdown (.md).......... {0}" -f $Stats.Markdown)
Write-Host ("CSV Files............... {0}" -f $Stats.CSV)
Write-Host ("JSON Files.............. {0}" -f $Stats.JSON)
Write-Host ("Folders................ {0}" -f $Stats.Folders)

# Additional stats from framework
$State = Get-RepositoryState
Write-Host ("Repository Size......... Calculated on demand")
Write-Host ("Last Modified........... {0}" -f $State.LastModified)

Write-Host ""
Write-Host "Statistics Complete."