function Restart-NavService {
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $navServiceName,
        [switch]
        $startIfNotRunning
    )
    Initialize-NavAdminTool
    
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