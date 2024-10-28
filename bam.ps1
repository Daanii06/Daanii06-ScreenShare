$ErrorActionPreference = "SilentlyContinue"

function Get-Signature {

    [CmdletBinding()]
     param (
        [string[]]$FilePath
    )

    $Existence = Test-Path -PathType "Leaf" -Path $FilePath
    $Authenticode = (Get-AuthenticodeSignature -FilePath $FilePath -ErrorAction SilentlyContinue).Status
    $Signature = "Invalid Signature (UnknownError)"

    if ($Existence) {
        if ($Authenticode -eq "Valid") {
            $Signature = "Valid Signature"
        }
        elseif ($Authenticode -eq "NotSigned") {
            $Signature = "Invalid Signature (NotSigned)"
        }
        elseif ($Authenticode -eq "HashMismatch") {
            $Signature = "Invalid Signature (HashMismatch)"
        }
        elseif ($Authenticode -eq "NotTrusted") {
            $Signature = "Invalid Signature (NotTrusted)"
        }
        elseif ($Authenticode -eq "UnknownError") {
            $Signature = "Invalid Signature (UnknownError)"
        }
        return $Signature
    } else {
        $Signature = "File Was Not Found"
        return $Signature
    }
}

Clear-Host

Write-Host "";
Write-Host "";
Write-Host -ForegroundColor Green " ▓█████▄  ▄▄▄      ▄▄▄      ███▄    █   ██▓  ██▓              ██████   ▄████▄  ██▀███   ▓█████ ▓█████ ███▄    █   ██████   ██░ ██  ▄▄▄      ██▀███   ▓█████";
Write-Host -ForegroundColor Green " ▒██▀ ██▌▒████▄   ▒████▄    ██ ▀█   █ ▒▓██▒▒▓██▒            ▒██    ▒  ▒██▀ ▀█ ▓██ ▒ ██▒ ▓█   ▀ ▓█   ▀ ██ ▀█   █ ▒██    ▒ ▒▓██░ ██ ▒████▄   ▓██ ▒ ██▒ ▓█   ▀";
Write-Host -ForegroundColor Green " ░██   █▌▒██  ▀█▄ ▒██  ▀█▄ ▓██  ▀█ ██▒▒▒██▒▒▒██▒            ░ ▓██▄    ▒▓█    ▄▓██ ░▄█ ▒ ▒███   ▒███  ▓██  ▀█ ██▒░ ▓██▄   ░▒██▀▀██ ▒██  ▀█▄ ▓██ ░▄█ ▒ ▒███  ";
Write-Host -ForegroundColor Green " ▒░▓█▄   ▌░██▄▄▄▄██░██▄▄▄▄██▓██▒  ▐▌██▒░░██░░░██░              ▒   ██▒▒▒▓▓▄ ▄██▒██▀▀█▄   ▒▓█  ▄ ▒▓█  ▄▓██▒  ▐▌██▒  ▒   ██▒ ░▓█ ░██ ░██▄▄▄▄██▒██▀▀█▄   ▒▓█  ▄";
Write-Host -ForegroundColor Green " ░░▒████▓ ▒▓█   ▓██▒▓█   ▓██▒██░   ▓██░░░██░░░██░            ▒██████▒▒░▒ ▓███▀ ░██▓ ▒██▒▒░▒████▒░▒████▒██░   ▓██░▒██████▒▒ ░▓█▒░██▓▒▓█   ▓██░██▓ ▒██▒▒░▒████";
Write-Host -ForegroundColor Green " ░ ▒▒▓  ▒ ░▒▒   ▓▒█░▒▒   ▓▒█░ ▒░   ▒ ▒  ░▓   ░▓              ▒ ▒▓▒ ▒ ░░░ ░▒ ▒  ░ ▒▓ ░▒▓░░░░ ▒░ ░░░ ▒░ ░ ▒░   ▒ ▒ ▒ ▒▓▒ ▒ ░  ▒ ░░▒░▒░▒▒   ▓▒█░ ▒▓ ░▒▓░░░░ ▒░ ";
Write-Host -ForegroundColor Green "  ░ ▒  ▒ ░ ░   ▒▒ ░ ░   ▒▒ ░ ░░   ░ ▒░░ ▒ ░░ ▒ ░            ░ ░▒  ░     ░  ▒    ░▒ ░ ▒ ░ ░ ░  ░ ░ ░  ░ ░░   ░ ▒░░ ░▒  ░    ▒ ░▒░ ░░ ░   ▒▒   ░▒ ░ ▒ ░ ░ ░  ";
Write-Host -ForegroundColor Green " ░ ░  ░   ░   ▒    ░   ▒     ░   ░ ░ ░ ▒ ░░ ▒ ░            ░  ░  ░   ░         ░░   ░     ░      ░     ░   ░ ░ ░  ░  ░    ░  ░░ ░  ░   ▒    ░░   ░     ░  ";
Write-Host -ForegroundColor Green "    ░          ░        ░           ░   ░    ░                    ░   ░ ░        ░     ░   ░  ░   ░           ░       ░    ░  ░  ░      ░     ░     ░   ░  ";



Write-Host "";
Write-Host -ForegroundColor Magenta " ScreenShareKing";
Write-Host "";

function Test-Admin {;$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent());$currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator);}
if (!(Test-Admin)) {
    Write-Warning "Are u a fucking pig? You have to run it as an administrator -_-"
    Start-Sleep 10
    Exit
}

$sw = [Diagnostics.Stopwatch]::StartNew()

if (!(Get-PSDrive -Name HKLM -PSProvider Registry)){
    Try{New-PSDrive -Name HKLM -PSProvider Registry -Root HKEY_LOCAL_MACHINE}
    Catch{Write-Warning "Error Mounting HKEY_Local_Machine"}
}
$bv = ("bam", "bam\State")
Try{$Users = foreach($ii in $bv){Get-ChildItem -Path "HKLM:\SYSTEM\CurrentControlSet\Services\$($ii)\UserSettings\" | Select-Object -ExpandProperty PSChildName}}
Catch{
    Write-Warning "Error Parsing BAM Key. Likely unsupported Windows Version"
    Exit
}
$rpath = @("HKLM:\SYSTEM\CurrentControlSet\Services\bam\","HKLM:\SYSTEM\CurrentControlSet\Services\bam\state\")

$UserTime = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation").TimeZoneKeyName
$UserBias = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation").ActiveTimeBias
$UserDay = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation").DaylightBias

$Bam = Foreach ($Sid in $Users){$u++
            
        foreach($rp in $rpath){
           $BamItems = Get-Item -Path "$($rp)UserSettings\$Sid" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Property
           Write-Host -ForegroundColor White "Extracting " -NoNewLine
           Write-Host -ForegroundColor magenta "$($rp)UserSettings\$SID"
           $bi = 0 

            Try{
            $objSID = New-Object System.Security.Principal.SecurityIdentifier($Sid)
            $User = $objSID.Translate( [System.Security.Principal.NTAccount]) 
            $User = $User.Value
            }
            Catch{$User=""}
            $i=0
            ForEach ($Item in $BamItems){$i++
    $Key = Get-ItemProperty -Path "$($rp)UserSettings\$Sid" -ErrorAction SilentlyContinue| Select-Object -ExpandProperty $Item

            If($key.length -eq 24){
                $Hex=[System.BitConverter]::ToString($key[7..0]) -replace "-",""
                $TimeLocal = Get-Date ([DateTime]::FromFileTime([Convert]::ToInt64($Hex, 16))) -Format "yyyy-MM-dd HH:mm:ss"
    $TimeUTC = Get-Date ([DateTime]::FromFileTimeUtc([Convert]::ToInt64($Hex, 16))) -Format "yyyy-MM-dd HH:mm:ss"
... (33 righe a disposizione)
