# ------------------------------------------------------------
# Golden Wings Enterprise Repository
# Document Register Bootstrap Generator
# Version: 1.0
# ------------------------------------------------------------

$RepositoryRoot = "D:\GoldenWings"
$OutputFile = "$RepositoryRoot\00_README\DOCUMENT_REGISTER.csv"

$Header = @(
"Document_ID",
"Document_Title",
"Repository_Path",
"Filename",
"Version",
"Status",
"Owner",
"Classification",
"Baseline",
"Last_Updated"
)

$Rows = @()

Get-ChildItem $RepositoryRoot -Recurse -Filter *.docx |
Where-Object {

    $_.FullName -notmatch "\\09_ARCHIVES\\" `
    -and $_.FullName -notmatch "\\05_ENTERPRISE_BASELINE\\"

} |
Sort-Object FullName |
ForEach-Object {

    $Name = $_.BaseName

    $ID = ""

    if ($Name -match "A-\d+") {
        $ID = $Matches[0]
    }
    elseif ($Name -match "ZA?-?[A-Z0-9\.]*") {
        $ID = $Matches[0]
    }
    elseif ($Name -match "Document ([A-Z0-9\.]+)") {
        $ID = $Matches[1]
    }

    $Rows += [PSCustomObject]@{

        Document_ID      = $ID
        Document_Title   = ""
        Repository_Path  = $_.DirectoryName.Replace($RepositoryRoot + "\", "")
        Filename         = $_.Name
        Version          = ""
        Status           = "Draft"
        Owner            = ""
        Classification   = "Internal"
        Baseline         = ""
        Last_Updated     = $_.LastWriteTime.ToString("yyyy-MM-dd")

    }

}

$Rows |
Export-Csv $OutputFile -NoTypeInformation -Encoding UTF8

Write-Host ""
Write-Host "Document Register Generated Successfully"
Write-Host ""
Write-Host "Output:"
Write-Host $OutputFile
Write-Host ""
Write-Host "Documents Found:" $Rows.Count