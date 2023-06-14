function Initialize-NavAdminTool {
    Import-Module PsLibConfigurationManager

    $config = Get-Configuration -configurationFile "$PSScriptRoot\..\config\PsLibNavToolsConfig.json"

    Import-Module $config.DynamicsNavAdminToolPath
}