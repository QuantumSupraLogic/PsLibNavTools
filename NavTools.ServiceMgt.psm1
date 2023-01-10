#region documentation
#endregion

#region scriptheader
#requires -version 5.0
#requires -RunAsAdministrator
Import-Module ($(Get-Item $PSScriptRoot).Parent.FullName + "\ConfigurationManager\ConfigurationManager.psm1")
$config = Get-Configuration -configurationFile $PSScriptRoot\config\NavToolsConfig.json
Import-Module $config.DynamicsNavAdminToolPath -DisableNameChecking -WarningAction Stop
#endregion

#region code
function Restart-NavService {
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $navServiceName,
        [switch]
        $startIfNotRunning
    )
    $serviceName = "MicrosoftDynamicsNavServer$" + $navServiceName
    $navService = Get-NavServerInstance | Where-Object { $_.ServerInstance -eq $serviceName }
    $service = Get-Service -Name $serviceName

    if ($navService) {
        if ($service.Status -eq "Running" -or $startIfNotRunning) {
            Restart-Service $serviceName
        }
    }
    else {
        Write-Error "No Microsoft Dynamics NAV Server Instance $navServiceName found."
    }
}

function Get-NAVServerConfiguration2 {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [String]$ServerInstance
    )
    BEGIN {
        $ResultObjectArray = @()          
        
    }
    PROCESS {   
        $CurrentServerInstance = Get-NAVServerInstance -ServerInstance $ServerInstance
        $CurrentConfig = $CurrentServerInstance | Get-NAVServerConfiguration -AsXml
        
        foreach ($Setting in $CurrentConfig.configuration.appSettings.add) {
            $ResultObject = New-Object System.Object
            $ResultObject | Add-Member -type NoteProperty -name ServiceInstance -value $CurrentServerInstance.ServerInstance
            $ResultObject | Add-Member -type NoteProperty -name Key -value $Setting.Key
            $ResultObject | Add-Member -Type NoteProperty -Name Value -Value $Setting.Value
            $ResultObjectArray += $ResultObject
        }

    }
    END {
        $ResultObjectArray
    }
}

#endregion