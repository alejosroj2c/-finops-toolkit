Param(
    [switch] $Stop
)

# Init outputs
$DeploymentScriptOutputs = @{}

# Wait; if we try to start the trigger too soon, it won't start
#Start-Sleep -Seconds 20

# Loop thru triggers
$env:Triggers.Split('|') `
| ForEach-Object {
    $trigger = $_
    if ($Stop) {
        Write-Host "Stopping trigger $trigger..." -NoNewline
        $triggerOutput = Stop-AzDataFactoryV2Trigger `
            -ResourceGroupName $env:DataFactoryResourceGroup `
            -DataFactoryName $env:DataFactoryName `
            -Name $trigger `
            -Force `
            -ErrorAction SilentlyContinue # Ignore errors, since the trigger may not exist
    } else {
        Write-Host "Starting trigger $trigger..." -NoNewline
        $triggerOutput = Start-AzDataFactoryV2Trigger `
            -ResourceGroupName $env:DataFactoryResourceGroup `
            -DataFactoryName $env:DataFactoryName `
            -Name $trigger `
            -Force
    }
    if ($triggerOutput) { 
        Write-Host 'done'
    } else {
        Write-Host 'failed'
    }
    $DeploymentScriptOutputs[$trigger] = $triggerOutput
}

if ($Stop) {
    Start-Sleep -Seconds 5
}
