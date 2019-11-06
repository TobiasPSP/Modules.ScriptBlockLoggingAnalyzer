function Get-SBLCodeStatistic
{
    <#
        .SYNOPSIS
        Analyzes PowerShell code and returns statistics

        .DESCRIPTION
        Analyzes PowerShell code and returns syntax errors, commands, and member invocations.

        .PARAMETER code
        The PowerShell code to be analyzed.

        .EXAMPLE
        Get-SBLCodeStatistic -code 'Get-Process'
        Analyzes the submitted code.
    #>


  param
  (
    [Parameter(Mandatory,ValueFromPipeline)]
    [AllowEmptyString()]
    [string]
    $code
  )
  
  process
  {
    $token = $errors = @()
    $ast = [System.Management.Automation.Language.Parser]::ParseInput($code, [ref]$token, [ref]$errors)
    $commands = $ast.FindAll( { param($el) $el -is [System.Management.Automation.Language.CommandAst] }, $true ) |
    Foreach-Object {
      if ($_.CommandElements -ne $null -and $_.CommandELements.count -gt 0)  
      { $_.CommandElements[0].Value} 
    }
    $members = $ast.FindAll( { param($el) $el -is [System.Management.Automation.Language.InvokeMemberExpressionAst] }, $true ).Member.Value
    [PSCustomObject]@{
      HasSyntaxError = $errors.Count -gt 0
      Commands = $commands
      MemberInvocation = $members
    }
  }
  
}