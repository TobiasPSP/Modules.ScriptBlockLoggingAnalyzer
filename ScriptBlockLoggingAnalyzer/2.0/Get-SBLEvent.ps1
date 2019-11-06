function Get-SBLEvent
{
    <#
            .SYNOPSIS
            Dumps the content of the script block logging log.

            .DESCRIPTION
            Returns any logged PowerShell code. The function combines multiple code parts. It returns one object per executed code.

            .EXAMPLE
            Get-SBLEvent
            Dumps all logged PowerShell code.
    #>


    $hash = @{}
  
    try
    {
        $ErrorActionPreference = 'Stop'
        Get-WinEvent -FilterHashtable @{ ProviderName="Microsoft-Windows-PowerShell"; Id = 4104 } |
        ForEach-Object {
            $eventData = $_
            $path = $eventData.Properties[4].Value
            if ($path.Trim().Length -eq 0) { $Path = "[from memory]" }
            $part = $eventData.Properties[0].Value
            $parts = $eventData.Properties[1].Value
            $id = $eventData.Properties[3].Value
            $code = $eventData.Properties[2].Value
      
            $hasHashKey = $hash.ContainsKey($id)
      
            # if this is not a part 1 event, collect the part and use it later
            if ($part -ne 1)
            {
                if (!$hasHashkey)
                {
                    $hash[$id] = ,'' * ($parts)
                }
                $hash[$id][$part-1] = $code
            }
            else
            {
                if ($hasHashKey)
                {
                    $hash[$id][0] = $code
                    $code = $hash[$id] -join "`r`n"
                    $null = $hash.Remove($id)
                }
        
                
                [PSCustomObject]@{
                    TimeCreated = $eventData.TimeCreated
                    Name = Split-Path $Path -Leaf
                    Code = $code
                    Path = $Path
                    UserName = $eventData.UserId | Convert-SIDToUser
                    ComputerName = $eventData.MachineName
                    ProcessId = $eventData.ProcessId
                    ThreadId = $eventData.ThreadId
                    Sid = $eventData.UserId
                    TotalParts = $parts
                    CodeId = $id
                }
            }    
        }
    }
    catch
    {
        Write-Warning "No events found."
    }
}