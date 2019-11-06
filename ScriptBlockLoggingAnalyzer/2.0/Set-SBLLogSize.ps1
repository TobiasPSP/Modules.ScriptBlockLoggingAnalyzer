function Set-SBLLogSize
{
    <#
            .SYNOPSIS
            Sets a new size for the script block logging log. Administrator privileges required.

            .DESCRIPTION
            By default, the script block log has a maximum size of 15MB which may be too small to capture and log PowerShell activity over a given period of time. With this command, you can assign more memory to the log.

            .PARAMETER MaxSizeMB
            New log size in Megabyte

            .EXAMPLE
            Set-SBLLogSize -MaxSizeMB 100
            Sets the maximum log size to 100MB. Administrator privileges required.
    #>


    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(15,3000)]
        [int]
        $MaxSizeMB
    )
  
    $Path = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-PowerShell/Operational"
    try
    {
        $ErrorActionPreference = 'Stop'
        Set-ItemProperty -Path $Path -Name MaxSize -Value ($MaxSizeMB * 1MB)  
    }
    catch
    {
        Write-Warning "Administrator privileges required. Run this command from an elevated PowerShell."
    }
}