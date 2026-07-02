Clear-Host

$Root = "D:\GoldenWings"

$Manifest =
"$Root\05_ENTERPRISE_BASELINE\GW-BASELINE-2026.1\MANIFEST.md"

$DocumentCount =
(Get-ChildItem $Root -Recurse -Filter *.docx -File |
Where-Object {
    $_.FullName -notmatch "\\09_ARCHIVES\\"
}).Count

$Today = Get-Date -Format "yyyy-MM-dd"

@"
# Golden Wings Enterprise Repository Baseline

## Baseline Information

| Property | Value |
|----------|-------|
| Repository | Golden Wings Enterprise Repository |
| Baseline ID | GW-BASELINE-2026.1 |
| Version | 1.0 |
| Status | Approved Baseline |
| Date | $Today |
| Controlled Documents | $DocumentCount |

---

## Repository Structure

00_README

01_GOVERNANCE

02_CONSTITUTIONAL_FRAMEWORK

03_ENTERPRISE_ARCHITECTURE

04_ENTERPRISE_ASSURANCE

05_ENTERPRISE_BASELINE

06_GOVERNANCE_RECORDS

07_TEMPLATES

08_EVIDENCE

09_ARCHIVES

10_MACHINE_READABLE

11_AUTOMATION

99_REFERENCE

---

## Controlled Document Register

00_README/DOCUMENT_REGISTER.csv

---

## Repository Hash Inventory

08_EVIDENCE/Hashes/HASHES_2026.1.csv

---

Generated Automatically

"@ | Set-Content $Manifest -Encoding UTF8

Write-Host ""
Write-Host "Manifest Generated Successfully"
Write-Host ""
Write-Host $Manifest