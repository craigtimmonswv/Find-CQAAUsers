Clear-Host

try { $null = Get-CsTenant } catch { Connect-MicrosoftTeams }
$username = Read-Host "Enter Username to find"
Try {$User = Get-CsOnlineUser -Identity $username  -erroraction Stop }
catch {Write-Host $username "not found. "
Write-Host ""
write-host "Correct username and try again"}

if ($User)
    {
        Write-Host ""
        write-host "User" $username "Found. Continuing..."
        Write-Host ""
        $cqs=Get-CsCallQueue -WarningAction SilentlyContinue | Where-Object {$_.agents.ObjectId -like $User.Identity}
        if ($cqs)
        {
            write-host "Call Queues with" $username
            foreach ($cq in $cqs)
            {
                if ($cq.Agents.ObjectId -eq $user.Identity )
                {
                    $cq.Name
                }
            }
            Clear-Variable cqs
        }
        Else 
        {Write-Host "No call queues with" $username}
        $aas = get-csautoAttendant | Where-Object {$_.operator.type -eq "User" -and $_.Operator.ID -eq $user.Identity}
        if ($aas)
        {
            Write-Host ""
            Write-Host "Auto Attendants with " $username

            foreach ($aa in $aas)
                {
                    $aa.Name
                }
            Write-Host
        }
        else 
            {
                write-host ""
                Write-Host "No Auto Attendants with" $username
            }
        Clear-Variable aas
    }
    try {
        Clear-Variable User -ErrorAction Stop
        Clear-Variable username -ErrorAction Stop    
    }
    catch {}