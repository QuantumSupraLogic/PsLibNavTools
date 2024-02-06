Set-StrictMode -Version 3.0

function Restore-Licence {
    Import-Module PsLibConfigurationManager

    $config = Get-Configuration -configurationFile "$PSScriptRoot\config\PsLibNavToolsConfig.json"
    $PathToDevEnv = Split-Path -Path $config.DynamicsNavToolsModulePath

    if (Test-Path -Path (Join-Path $BackupDir "fin.flf")) {
        Move-Item -Path (Join-Path $BackupDir "fin.flf") -Destination (Join-Path $PathToDevEnv "fin.flf") -Force 

    }
    if (Test-Path -Path ((Get-Item $BackupDir).Parent.FullName)) {
        Remove-Item -Path ((Get-Item $BackupDir).Parent.FullName) -Recurse -Force
    }

}