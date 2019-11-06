function Enable-SBL
{
    <#
            .SYNOPSIS
            Enables script block logging. Requires Administrator privileges.

            .DESCRIPTION
            Turns script block logging on. Any code that is sent to PowerShell will be logged.

            .EXAMPLE
            Enable-SBL
            Enables script block logging. Administrator privileges required.
    #>


    $path = "Registry::HKLM\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
    $exists = Test-Path -Path $path
    try
    {
        $ErrorActionPreference = 'Stop'
        if (!$exists) { $null = New-Item -Path $path -Force }
  
        Set-ItemProperty -Path $path -Name EnableScriptBlockLogging -Type DWord -Value 1
        Set-ItemProperty -Path $path -Name EnableScriptBlockInvocationLogging -Type DWord -Value 1
    }
    catch
    {
        Write-Warning "Administrator privileges required. Run this command from an elevated PowerShell."
    }
}