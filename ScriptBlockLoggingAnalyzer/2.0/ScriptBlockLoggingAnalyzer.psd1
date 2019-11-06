@{
RootModule = 'loader.psm1'
ModuleVersion = '2.0'
GUID = 'e9677f71-31b6-4167-923e-f2a6d96330e9'
Author = 'Dr. Tobias Weltner'
CompanyName = 'powershell.one'
Copyright = '2020 Dr. Tobias Weltner (MIT-License)'
Description = 'tools to manage scriptblock logging'
PowerShellVersion = '5.0'
FunctionsToExport = 'Clear-SBLLog', 'Convert-SidToUser', 'Disable-SBL', 'Enable-SBL', 
               'Get-SBLCodeStatistics', 'Get-SBLEvent', 'Get-SBLLogSize', 
               'Get-SBLStatus', 'Set-SBLLogSize'
CmdletsToExport = '*'
VariablesToExport = '*'
AliasesToExport = '*'
PrivateData = @{
    PSData = @{
        Tags = 'Security', 'ScriptBlockLogging', 'Logging'
        LicenseUri = 'https://en.wikipedia.org/wiki/MIT_License'
        ProjectUri = 'https://github.com/TobiasPSP/Modules.ScriptBlockLoggingAnalyzer'
        ReleaseNotes = 'cleaned up the module'
    } 
} 
}
