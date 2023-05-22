
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