function Switch-Licence {
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $LicenceFileLocation
    )
    $PathToDevEnv = Split-Path -Path $config.DynamicsNavToolsModulePath

    Copy-Item -Path $LicenceFileLocation -Destination (Join-Path $PathToDevEnv "fin.flf") -Force
}