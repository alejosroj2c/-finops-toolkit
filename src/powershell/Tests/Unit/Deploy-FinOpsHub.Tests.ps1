# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

& "$PSScriptRoot/../Initialize-Tests.ps1"

InModuleScope 'FinOpsToolkit' {
    Describe 'Deploy-FinOpsHub' {
        BeforeAll {
            function Get-AzResourceGroup {}
            function New-AzResourceGroup {}
            function New-AzResourceGroupDeployment {}
            $hubName = 'hub'
            $rgName = 'hubRg'
            $location = 'eastus'
        }

        Context "WhatIf" {
            It 'Should run without error' {
                # Arrange
                # Act
                Deploy-FinOpsHub -WhatIf -Name "ftk-test-Deploy-FinOpsHub" -ResourceGroupName "ftk-test" -Location "westus2"
            
                # Assert
            }
        }

        Context 'Resource groups' {
            BeforeAll {
                Mock -CommandName 'New-Directory'
            }
        
            Context 'Create new resource group' {
                BeforeAll {
                    Mock -CommandName 'Get-AzResourceGroup'
                }

                Context 'Failure' {
                    BeforeAll {
                        Mock -CommandName 'New-AzResourceGroup' -MockWith { throw 'failure' }
                    }

                    It 'Should throw if error creating resource group' {
                        { Deploy-FinOpsHub -Version 'latest' -Name $hubName -ResourceGroup $rgName -Location $location } | Should -Throw
                        Assert-MockCalled -CommandName 'Get-AzResourceGroup' -Times 1
                        Assert-MockCalled -CommandName 'New-AzResourceGroup' -Times 1
                        Assert-MockCalled -CommandName 'New-Directory' -Times 0
                    }
                }
            }

            Context 'Use existing resource group' {
                BeforeAll {
                    Mock -CommandName 'Get-AzResourceGroup' -MockWith { return @{ ResourceGroupName = $rgName } }
                    Mock -CommandName 'New-AzResourceGroup'
                    Mock -CommandName 'Save-FinOpsHubTemplate'
                }

                Context 'Failures' {
                    BeforeAll {
                        Mock -CommandName 'Get-ChildItem'
                    }

                    It 'Should throw if template file is not found' {
                        { Deploy-FinOpsHub -Name $hubName -ResourceGroup $rgName -Location $location -Version 'latest' } | Should -Throw
                        Assert-MockCalled -CommandName 'Get-ChildItem' -Times 1
                    }
                }

                Context 'Success' {
                    BeforeAll {
                        $templateFile = Join-Path -Path $env:temp -ChildPath 'FinOps\finops-hub-v1.0.0\main.bicep'
                        Mock -CommandName 'Get-ChildItem' -MockWith { return @{ FullName = $templateFile } }
                        Mock -CommandName 'New-AzResourceGroupDeployment'
                    }

                    It 'Should deploy the template without throwing' {
                        { Deploy-FinOpsHub -Name $hubName -ResourceGroup $rgName -Location $location -Version 'latest' } | Should -Not -Throw
                        Assert-MockCalled -CommandName 'Get-ChildItem' -Times 1
                        Assert-MockCalled -CommandName 'New-AzResourceGroupDeployment' -ParameterFilter { @{ TemplateFile = $templateFile } } -Times 1
                    }

                    It 'Should deploy the template with tags' {
                        { Deploy-FinOpsHub -Name $hubName -ResourceGroup $rgName -Location $location -Tags @{ Test = 'Tag' } -Version 'latest' } | Should -Not -Throw
                        Assert-MockCalled -CommandName 'Get-ChildItem' -Times 1
                        Assert-MockCalled -CommandName 'New-AzResourceGroupDeployment' -ParameterFilter {
                            @{
                                TemplateParameterObject = @{
                                    tags = @{
                                        Test = 'Tag'
                                    }
                                }
                            }
                        } -Times 1
                    }

                    It 'Should deploy the template with StorageSku' {
                        $storageSku = 'Premium_ZRS'
                        { Deploy-FinOpsHub -Name $hubName -ResourceGroup $rgName -Location $location -StorageSku $storageSku -Version 'latest' } | Should -Not -Throw
                        Assert-MockCalled -CommandName 'Get-ChildItem' -Times 1
                        Assert-MockCalled -CommandName 'New-AzResourceGroupDeployment' -ParameterFilter {
                            @{
                                TemplateParameterObject = @{
                                    storageSku = $storageSku
                                }
                            }
                        } -Times 1
                    }
                }
            }
        }
    }
}
