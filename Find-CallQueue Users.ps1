cls
try { $null = Get-CsTenant } catch { Connect-MicrosoftTeams }
$username = Read-Host "Enter Username to find"
Try {$userobjectID = (Get-CsOnlineUser -Identity $username  -erroraction Stop| select Identity).identity }
catch {Write-Host $username "not found. Correct username and try again"}
if ($userobjectID)
    {
            Write-Host "User" $username "Found. Continuing..."
            Write-Host
            Write-Host "Checking for call queue membership"
            $CQs= Get-CsCallQueue -WarningAction SilentlyContinue | select name, identity, users |? {$_.users -like $userobjectID }
            Write-Host "Found" ($CQs| Measure-Object).count "call queues."
            Write-Host
            Write-Host "Checking for call Auto attendant membership"
            $AAs= Get-CsAutoAttendant | select name, identity, Operator |? {$_.operator.id -like $userobjectID }
            Write-Host "Found" ($AAs| Measure-Object).count "auto-attendants."
            $details = @()
            Foreach ($cq in $CQs)
                {
                    $displayname=Get-CsOnlineUser -Identity $userobjectID
                    $detail = New-Object PSObject
                    $detail | Add-Member NoteProperty -Name "CQ/AA Name"  -Value $CQ.name
                    $detail | Add-Member NoteProperty -Name "User Identity" -Value $userobjectID
                    $detail | Add-Member NoteProperty -Name "User Display Name" -Value $displayname.DisplayName
                    $detail | Add-Member NoteProperty -Name "User UPN" -Value $displayname.UserPrincipalName
                    $details += $detail
                }
                clv detail, cqs
   
            Foreach ($AA in $AAs)
                {
                    $displayname=Get-CsOnlineUser -Identity $userobjectID
                    $detail = New-Object PSObject
                    $detail | Add-Member NoteProperty -Name "CQ/AA Name" -Value $AA.name
                    $detail | Add-Member NoteProperty -Name "User Identity" -Value $userobjectID
                    $detail | Add-Member NoteProperty -Name "User Display Name" -Value $displayname.DisplayName
                    $detail | Add-Member NoteProperty -Name "User UPN" -Value $displayname.UserPrincipalName
                    $details += $detail
                }
                clv detail, aas
            $details | ft -AutoSize 
        }
        clv userobjectid, username, cqs, aas, details 