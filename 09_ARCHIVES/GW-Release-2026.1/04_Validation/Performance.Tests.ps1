# ============================================
# GW-EAF Performance Tests
# ============================================
# To run: Invoke-Pester -Path .\Tests\Performance.Tests.ps1
# ============================================

Describe "Performance Tests" {
    BeforeAll {
        $ModulePath = Join-Path $PSScriptRoot "..\Modules\Repository.Common.psm1"
        Import-Module $ModulePath -Force
    }

    It "Get-RepositoryDocuments should execute within 3 seconds" {
        $Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
        $Docs = Get-RepositoryDocuments
        $Stopwatch.Stop()
        $Stopwatch.ElapsedMilliseconds | Should BeLessThan 3000
    }

    It "Get-RepositoryState should execute within 3 seconds" {
        $Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
        $State = Get-RepositoryState
        $Stopwatch.Stop()
        $Stopwatch.ElapsedMilliseconds | Should BeLessThan 3000
    }

    It "Export-HashInventory should execute within 5 seconds" {
        $Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
        $HashFile = "D:\GoldenWings\test_perf_hash.csv"
        Export-HashInventory -OutputPath $HashFile
        $Stopwatch.Stop()
        $Stopwatch.ElapsedMilliseconds | Should BeLessThan 5000
        Remove-Item $HashFile -ErrorAction SilentlyContinue
    }

    It "Get-GitStatus should execute within 1 second" {
        $Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
        $Status = Get-GitStatus
        $Stopwatch.Stop()
        $Stopwatch.ElapsedMilliseconds | Should BeLessThan 1000
    }
}