function Convert-SIDToUser
{
    <#
        .SYNOPSIS
        Converts SID to user name

        .DESCRIPTION
        Converts a security identifier (SID) to a real user name

        .PARAMETER SID
        The security identifier to convert

        .EXAMPLE
        "S-1-5-32-544" | Convert-SIDToUser
        Converts the sid to a user name

        .EXAMPLE
        Convert-SIDToUser -SID "S-1-5-32-544"
        Converts the sid to a user name
    #>


  param
  (
    [string]
    [Parameter(Mandatory,ValueFromPipeline)]
    $SID
  )
  process
  {
    (New-Object System.Security.Principal.SecurityIdentifier($SID)).Translate( [System.Security.Principal.NTAccount]).Value
  }
}