function Clear-SBLLog
{
    <#
            .SYNOPSIS
            Ckears the entire PowerShell operational log including script blog logging entries. Administrator privileges required.

            .DESCRIPTION
            Clears the complete content of the log Microsoft-Windows-PowerShell/Operational. This includes all logged script block code.

            .EXAMPLE
            Clear-SBLLog
            Clears the entire log Microsoft-Windows-PowerShell/Operational.
    #>
    [CmdletBinding(ConfirmImpact='High')]
    param()
    
    try
    {
        $ErrorActionPreference = 'Stop'
        wevtutil cl Microsoft-Windows-PowerShell/Operational
    }
    catch
    {
        Write-Warning "Administrator privileges required. Run this command from an elevated PowerShell."
    }
}