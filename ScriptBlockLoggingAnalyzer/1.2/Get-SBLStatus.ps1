function Get-SBLStatus
{
    <#
            .SYNOPSIS
            Returns the current status for script block logging.

            .DESCRIPTION
            Examines the registry keys that control script block logging and reports whether the keys exist, and what their state is.

            .EXAMPLE
            Get-SBLStatus
            Returns whether script block logging is explicitly turned on or off via registry keys.
    #>


    $path = "Registry::HKLM\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
    $settings = Get-ItemProperty -Path $path -ErrorAction SilentlyContinue
    $keyExists = Test-Path -Path $path
    [PSCustomObject]@{
        EnableScriptBlockLogging = $settings.EnableScriptBlockLogging -eq 1
        EnableScriptBlockInvocationLogging = $settings.EnableScriptBlockInvocationLogging -eq 1
        SettingsKeyExists = $keyExists
        ScriptBlockLoggingActive = !$keyExists -or $settings.EnableScriptBlockLogging -eq 1
    }
}