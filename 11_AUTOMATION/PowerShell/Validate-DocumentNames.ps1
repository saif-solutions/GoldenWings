Clear-Host

$Root = "D:\GoldenWings"

Write-Host ""
Write-Host "======================================="
Write-Host "Golden Wings Document Name Validator"
Write-Host "======================================="
Write-Host ""

$Invalid = @()

Get-ChildItem $Root -Recurse -File -Filter *.docx |

Where-Object {

    $_.FullName -notmatch "\\09_ARCHIVES\\" -and
    $_.FullName -notmatch "\\05_ENTERPRISE_BASELINE\\"-and
    $_.FullName -notmatch "\\99_REFERENCE\\"


} |

ForEach-Object {

    $Name = $_.BaseName

    if (

        $Name -notmatch '^Document [A-Z]' -and
        $Name -notmatch '^DOCUMENT [A-Z]' -and
        $Name -notmatch '^GEN ' -and
        $Name -notmatch '^Gen ' -and
        $Name -notmatch '^GOLDEN WINGS'

    )
    {
        $Invalid += $_
    }

}

if($Invalid.Count -eq 0)
{
    Write-Host "[PASS] All document names comply."
}
else
{
    Write-Host ""
    Write-Host "[FAIL] Invalid filenames:"
    Write-Host ""

    $Invalid |
    Select-Object FullName |
    Format-Table -AutoSize
}

Write-Host ""
Write-Host "Validation Complete."