function Disable-SBL
{
    <#
            .SYNOPSIS
            Disables script block logging. Requires Administrator privileges.

            .DESCRIPTION
            Turns off script block logging.

            .EXAMPLE
            Disable-SBL
            Turns off script block logging.
    #>


    $path = "Registry::HKLM\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
    $exists = Test-Path -Path $path
    if (!$exists) { 
        Write-Warning 'Script block logging was not enabled. No action taken.'
        return 
    }
  
    try
    {
        $ErrorActionPreference = 'Stop'
        Remove-ItemProperty -Path $path -Name EnableScriptBlockLogging  -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $path -Name EnableScriptBlockInvocationLogging  -ErrorAction SilentlyContinue
  
        $key = Get-Item -Path $path
        $remainingValues = $key.GetValueNames().Count
        $remainingKeys = @(Get-ChildItem -Path $path).Count 
        if ($remainingValues -eq 0 -and $remainingKeys -eq 0) { Remove-Item -Path $path }
    }
    catch
    {
        Write-Warning "Administrator privileges required. Run this command from an elevated PowerShell."
    }
}