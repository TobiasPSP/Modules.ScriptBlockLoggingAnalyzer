# About

**PowerShell** can log *all executed source code*. This helps companies establish security workflows that identifies the **PowerShell** code that runs in their environments, plus identify *who* ran the code.

It can also be used to raise awareness of how vulnerable sensitive data stored inside scripts is (i.e. clear-text passwords). Blue teamers can use the techniques to expose **PowerShell** source code that is running inside of applications.

By default, **PowerShell** logs only selected (suspicious) scripts. With the help of this module, you can easily turn on full scriptblock logging and log all **PowerShell** code executing *anywhere* on the machine.

The source code is logged to the eventlog system, and when scripts are large, the source code is separated into many chunks of eventlog data. The module comes with `Get-SBLEvent` which reads the logged source code and recomposes the full script source code.

This module is just a proof-of-concept in the current version. There are some areas of improvement, and you are cordially invited to help improve the module by issuing pull requests:

- **Windows PowerShell**: currently the module is tailored towards *Windows PowerShell*. *PowerShell 7* logs the data in a different eventlog. It should be fairly easy though to add these eventlog queries as well.
- **Performance**: `Get-SBLEvent` does a simple eventlog query based on`Get-WinEvent`. It won't expose advanced filtering (yet) so you can only dump *all* logged source codes and then filter the results client-side with `Where-Object`. A much faster approach would be to expose a `-Filter` parameter that uses the native *XPath* filters found in `Get-WinEvent` to quickly search for i.e. *.exe*-files that contain **PowerShell** code or do specific queries for suspicious commands.
- **Clean-Up**: scriptblock logging logs any **PowerShell** code including custom *prompt* functions etc. It would be nice to have the option to exclude such data from the results provided by `Get-SBLEvent`.


## Install

To install the module from the *PowerShell Gallery*, run this:

```powershell
Install-Module -Name ScriptBlockLoggingAnalyzer -Scope CurrentUser
```

## Enable ScriptBlock Logging

To enable scriptblock logging to the eventlog, with *Administrator* privileges, run this:

```powershell
Enable-SBL
```

Note: it may take up to a few minutes until scriptblock logging is fully enabled.

### Hardening

When enabled, all scriptblocks anywhere (manually executed **PowerShell** code, running scripts, or **PowerShell** code executing inside an application) will be logged. The logged source code is readable for all users so in production environments, you want to restrict read access to the log and make sure only *Administrators* can view the logged source code.

The script below hardens the read access by applying the same read permissions to the log that is applied to the *Security* eventlog:

```powershell
$Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\winevt\Channels\Microsoft-Windows-PowerShell/Operational"
$sddlSecurity = ((wevtutil gl security) -like 'channelAccess*').Split(' ')[-1]
Set-ItemProperty -Path $Path -Name ChannelAccess -Value $sddlSecurity
Restart-Service -Name EventLog -Force
```

### Log Size

By default, the eventlog logging the source code is limited to 15MB. To log more source code, you may want to adjust the eventlog (requires *Administrator* privileges). This expands the maximum eventlog size to 100MB:

```powershell
Set-SBLLogSize -MaxSizeMB 100
```


### Known Limitations

Currently, only code executed by *Windows PowerShell* will be logged and retrieved. *PowerShell 7* saves the logged scriptblock code to a different eventlog. You are welcome to adapt this code to *PowerShell 7*. If you do, please let me know or issue a pull request.

Due to a long-standing bug in all versions of **PowerShell** (including *PowerShell 7*), when scriptblock logging is enabled, pipeline operations are slowed down. This can affect scripts that process a large number of objects. More details and workarounds can be found here: https://powershell.one/tricks/performance/pipeline

## Reading Logged Source Code

To read the logged source code, use `Get-SBLEvent`.  By default, reading the logged source code is not restricted. If you hardened the access to the eventlog with the example above, *Administrator* privileges are required. In this case, non-Admins always receive the warning: *No events found.*.

This reads the newest 100 **PowerShell** source codes captured:

```
PS> Get-SBLEvent | Select-Object -First 100

TimeCreated  : 15.01.2021 10:33:31
Name         : [from memory]
Code         : cls
Path         : [from memory]
UserName     : DELL7390\tobia
ComputerName : DELL7390
ProcessId    : 10000
ThreadId     : 8536
Sid          : S-1-5-21-2770831484-2260150476-2133527644-1001
TotalParts   : 1
CodeId       : 27f07d4d-ed9d-410c-b6eb-a569f8ddac6c

TimeCreated  : 15.01.2021 10:33:25
Name         : Get-SBLEvent.ps1
Code         : {
                           $eventData = $_
                           $path = $eventData.Properties[4].Value
                           if ($path.Trim().Length -eq 0) { $Path = "[from memory]" }
                           $part = $eventData.Properties[0].Value
                           $parts = $eventData.Properties[1].Value
                           $id = $eventData.Properties[3].Value
                           $code = $eventData.Properties[2].Value
(...)
```

*Name* returns the name of the logged script. Interactive commands show *\[from memory\]* instead.

The source code is returned in *Code*.

### Identifying Suspicious Activity

You can automate scanning logged source code and for example routinely search for suspicious commands. 

You could also check to see which file types have been executed in the past, and for example identify whether unknown *.exe*-Applications executed **PowerShell** code. If so, you can even see and examine the **PowerShell** code that executed inside such an application. 

#### Identifying Suspicious Applications

This example reads all logged scripts and returns the file extensions found that executed **PowerShell** code:

```
PS> Get-SBLEvent | 
  Foreach-Object { [System.IO.Path]::GetExtension($_.Name) } | 
  Group-Object -NoElement

Count Name
----- ----
41227
  885 .ps1
  496 .psm1
  734 .psd1
    5 .exe
```
Note: based on the number of logged scripts, this can take a long time to run.
Blank file extensions represent interactively entered **PowerShell** code.

#### Exposing PowerShell Code Inside Applications

The next example would search for *.exe*-Applications and return file path and **PowerShell** source code content:

```powershell
Get-SBLEvent | Where-Object { $_.Name -like '*.exe' } | Select-Object -Property Path, Code
```

Obviously, this script yields nothing if there was no *.exe* application on your system that ran **PowerShell** code.

### Conclusions

The previous examples prove that it is *unacceptable* to ever save sensitive data such as passwords in **PowerShell** scripts, no matter how you wrap them into applications. 

As you see, even of you launched a script with sensitive passwords *only once*, it *will* end up in the log and compromises all secrets hard-coded inside of it.

Obviously this is not a *limitation* of **PowerShell** but a huge benefit: scriptblock logging just exposes to you what attackers would do with other means. You can use the examples here to raise sensitivity to this issue among your co-workers.

### Default Logging

Note: Even if scriptblock logging is not enabled, **PowerShell** will log selected code based on hard-coded trigger words.

