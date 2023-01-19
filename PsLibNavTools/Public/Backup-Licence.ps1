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