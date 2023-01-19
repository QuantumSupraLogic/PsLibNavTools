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