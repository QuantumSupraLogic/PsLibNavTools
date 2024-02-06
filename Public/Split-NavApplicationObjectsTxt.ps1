Set-StrictMode -Version 3.0

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
    Initialize-NavModeltools
    
    Split-NAVApplicationObjectFile -Source $sourceFile -Destination $destinationDirectory -Force -PreserveFormatting 
}