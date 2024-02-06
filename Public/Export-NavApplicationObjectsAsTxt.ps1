Set-StrictMode -Version 3.0

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
    Initialize-NavModeltools

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