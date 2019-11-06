function Get-SBLLogSize
{
    <#
        .SYNOPSIS
        Reports the current script block log size.

        .DESCRIPTION
        Returns the current size of the script block log.

        .EXAMPLE
        Get-SBLLogSize
        Returns the current size of the script block log.
    #>


  $Path = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-PowerShell/Operational"
  $Key = Get-ItemProperty -Path $Path
  [PSCustomObject]@{
    Enabled = $key.Enabled -eq 1
    MaxSize = $key.MaxSize
    MaxSizeMB = '{0:n1} MB' -f ($key.MaxSize / 1MB)
  }
}