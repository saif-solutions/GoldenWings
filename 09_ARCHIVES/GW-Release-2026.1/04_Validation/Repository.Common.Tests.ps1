# ============================================
# GW-EAF Pester Tests
# ============================================
# To run: Invoke-Pester -Path .\Tests\Repository.Common.Tests.ps1
# ============================================

Describe "Repository.Common Module" {
    BeforeAll {
        # Import the module
        $ModulePath = Join-Path $PSScriptRoot "..\Modules\Repository.Common.psm1"
        Import-Module $ModulePath -Force
    }

    It "Should import successfully" {
        $Module = Get-Module Repository.Common
        $Module | Should Not Be $null
    }

    It "Should export exactly 58 functions" {
        $Functions = Get-Command -Module Repository.Common
        $Functions.Count | Should Be 58
    }
}

Describe "Configuration Service" {
    BeforeAll {
        $ModulePath = Join-Path $PSScriptRoot "..\Modules\Repository.Common.psm1"
        Import-Module $ModulePath -Force
    }

    It "Get-RepositoryRoot should return a valid path" {
        $Root = Get-RepositoryRoot
        $Root | Should Not Be $null
        Test-Path $Root | Should Be $true
    }

    It "Get-RepositoryVersion should return 2026.1" {
        $Version = Get-RepositoryVersion
        $Version | Should Be "2026.1"
    }

    It "Get-RepositoryConfiguration should return a valid object" {
        $Config = Get-RepositoryConfiguration
        $Config.Root | Should Not Be $null
        $Config.Version | Should Be "2026.1"
    }
}

Describe "Repository Service" {
    BeforeAll {
        $ModulePath = Join-Path $PSScriptRoot "..\Modules\Repository.Common.psm1"
        Import-Module $ModulePath -Force
    }

    It "Get-RepositoryDocuments should return documents" {
        $Docs = Get-RepositoryDocuments
        $Docs | Should Not Be $null
        $Docs.Count | Should BeGreaterThan 0
    }

    It "Get-RepositoryState should return a valid object" {
        $State = Get-RepositoryState
        $State.DocumentCount | Should Not Be $null
        $State.DocumentCount | Should BeGreaterThan 0
    }
}

Describe "Git Service" {
    BeforeAll {
        $ModulePath = Join-Path $PSScriptRoot "..\Modules\Repository.Common.psm1"
        Import-Module $ModulePath -Force
    }

    It "Get-GitStatus should return a valid object" {
        $Status = Get-GitStatus
        $Status.IsGitRepository | Should Be $true
    }

It "Get-GitBranches should return branches" {
    $Branches = Get-GitBranches
    # The function should at least return the current branch
    $Branches | Should Not Be $null
}

}

Describe "Document Service" {
    BeforeAll {
        $ModulePath = Join-Path $PSScriptRoot "..\Modules\Repository.Common.psm1"
        Import-Module $ModulePath -Force
    }

    It "Get-Documents should return documents" {
        $Docs = Get-Documents -ExcludeArchives
        $Docs | Should Not Be $null
        $Docs.Count | Should BeGreaterThan 0
    }
}

Describe "Validation Service" {
    BeforeAll {
        $ModulePath = Join-Path $PSScriptRoot "..\Modules\Repository.Common.psm1"
        Import-Module $ModulePath -Force
    }

    It "Test-RepositoryStructure should pass" {
        $Structure = Test-RepositoryStructure
        $Structure.Success | Should Be $true
    }
}