#region documentation
#endregion

#region scriptheader
#requires -version 3.0

Import-Module ($(Get-Item $PSScriptRoot).Parent.FullName + "\ConfigurationManager\ConfigurationManager.psm1")
$config = Get-Configuration -configurationFile $PSScriptRoot\config\NavToolsConfig.json
Import-Module $config.DynamicsNavModelToolsModulePath -DisableNameChecking -WarningAction Stop

$BackupDir = [IO.PAth]::Combine([System.IO.Path]::GetTempPath(), "NavTools.AppObjectMgt\", (Get-Date -Format yyyyMMddThhmm))
#endregion

#region code
function Export-NavApplicationObjectsAsFob {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $dataSource,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $databaseName,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $exportFile,
        [string]
        $filter
    )

    Export-NAVApplicationObject -databaseserver $dataSource -DatabaseName $databaseName -Path $exportFile -Filter $Filter -Force | Out-Null
}
function Export-NavApplicationObjectsAsTxt {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $dataSource,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $databaseName,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $exportFile,
        [string]
        $filter,
        [string]
        $useLicenceFileLocation
    )
    
    if ($useLicenceFileLocation) {
        Backup-Licence

        Switch-Licence -LicenceFileLocation $useLicenceFileLocation
    }

    try {
        Export-NAVApplicationObject -databaseserver $dataSource -DatabaseName $databaseName -Path $exportFile -Filter $Filter -Force -ExportTxtSkipUnlicensed | Out-Null
    }
    finally {
        if ($useLicenceFileLocation) {
            Restore-Licence
        }
    }
}
function Split-NavApplicationObjectsTxt {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $sourceFile,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $destinationDirectory
    )
    Split-NAVApplicationObjectFile -Source $sourceFile -Destination $destinationDirectory -Force -PreserveFormatting 
}

function Backup-Licence {
    $PathToDevEnv = Split-Path -Path $config.DynamicsNavToolsModulePath
    if (Test-Path -Path (Join-Path $PathToDevEnv fin.flf)) {
        if (Test-Path -Path $BackupDir) {
            Remove-Item -Path $BackupDir -Recurse -Force
        }
        New-Item -ItemType Directory -Path $BackupDir | Out-Null

        Move-Item -Path (Join-Path $PathToDevEnv "fin.flf") -Destination (Join-Path $BackupDir "fin.flf")
    }
}

function Restore-Licence {
    $PathToDevEnv = Split-Path -Path $config.DynamicsNavToolsModulePath

    if (Test-Path -Path (Join-Path $BackupDir "fin.flf")) {
        Move-Item -Path (Join-Path $BackupDir "fin.flf") -Destination (Join-Path $PathToDevEnv "fin.flf") -Force 

    }
    if (Test-Path -Path ((Get-Item $BackupDir).Parent.FullName)) {
        Remove-Item -Path ((Get-Item $BackupDir).Parent.FullName) -Recurse -Force
    }

}

function Switch-Licence {
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $LicenceFileLocation
    )
    $PathToDevEnv = Split-Path -Path $config.DynamicsNavToolsModulePath

    Copy-Item -Path $LicenceFileLocation -Destination (Join-Path $PathToDevEnv "fin.flf") -Force
}

#endregion