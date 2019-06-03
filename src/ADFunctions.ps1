Function New-Staff {
  param(
    [String] $FirstName,
    [String] $LastName,
    [String] $NickName,
    [String] $UserName,
    [String] $Position,
    [String] $Department,
    [String] $Building,
    [Bool] $AHS,
    [Bool] $ELL,
    [Bool] $IJH,
    [Bool] $BAN,
    [Bool] $NEV,
    [Bool] $SOU,
    [Bool] $SUM,
    [Bool] $WOO,
    [Bool] $CLC,
    [Bool] $OAK,
    [Bool] $PAE,
    [Bool] $RIV
  )

  # ---=== Set variables for account update. ===---

  $SamAccountName = $UserName.ToLower()
  $UserPrincipalName = "$SamAccountName@austin.k12.mn.us"
  $OU = "OU=$Building,OU=Employee,DC=ISD492,DC=LOCAL"
    
  if ($NickName.Length -gt 1) {
    $DisplayName = "$LastName, $NickName"
    $Name = "$($NickName) $($LastName)"

  } else {
    $DisplayName = "$LastName, $FirstName"
    $Name = "$($FirstName) $($LastName)"
  }
  # ---=== Account created and default password set. ===---
  New-ADUser -Name $Name `
    -AccountPassword (ConvertTo-SecureString "austin.k12.mn.us" -AsPlainText -Force) `
    -SamAccountName $SamAccountName `
    -UserPrincipalName $UserPrincipalName `
    -DisplayName $DisplayName `
    -OtherName $NickName `
    -GivenName $FirstName `
    -Surname $LastName `
    -City $Building `
    -State "APS-Staff" `
    -Department $Department `
    -Title $Position `
    -Description $Position `
    -Company $Position `
    -Path $OU

  Start-Sleep -Seconds 2

  Set-ADUser -Identity $SamAccountName `
    -Enabled $true `
    -ChangePasswordAtLogon $true `
    -EmailAddress "$UserPrincipalName"
  Set-ADUser -Identity $SamAccountName -Replace @{MailNickName = $SamAccountName}
  Set-ADUser -Identity $SamAccountName -Replace @{msExchHideFromAddressLists = $false}
  Set-ADUser -Identity $SamAccountName -Add @{proxyAddresses = "SMTP:$UserPrincipalName"}

  Start-Sleep -Seconds 2

  Group-Staff -UserName $SamAccountName `
    -Position $Position `
    -AHS $AHS `
    -ELL $ELL `
    -IJH $IJH `
    -BAN $BAN `
    -NEV $NEV `
    -SOU $SOU `
    -SUM $SUM `
    -WOO $WOO `
    -CLC $CLC `
    -OAK $OAK `
    -PAE $PAE `
    -RIV $RIV
}

Function Set-Staff {
  param(
    [System.GUID] $GUID,
    [String] $FirstName,
    [String] $LastName,
    [String] $NickName,
    [String] $UserName,
    [String] $Position, # Fields Below This point check for null input
    [String] $Department,
    [String] $Building,
    [Bool] $AHS,
    [Bool] $ELL,
    [Bool] $IJH,
    [Bool] $BAN,
    [Bool] $NEV,
    [Bool] $SOU,
    [Bool] $SUM,
    [Bool] $WOO,
    [Bool] $CLC,
    [Bool] $OAK,
    [Bool] $PAE,
    [Bool] $RIV,
    [Bool] $ResetPassword
  )
  # ---=== Set variables for account update. ===---

  $SamAccountName = $UserName.ToLower()
  $UserPrincipalName = "$SamAccountName@austin.k12.mn.us"
  $OU = "OU=$Building,OU=Employee,DC=ISD492,DC=LOCAL"
    
  if ($NickName.Length -gt 1) {
    $DisplayName = "$LastName, $NickName"
    $Name = "$($NickName) $($LastName)"

  } else {
    $DisplayName = "$LastName, $FirstName"
    $Name = "$($FirstName) $($LastName)"
  }

  $user = Get-ADUser -Identity $GUID
  Start-Sleep -Seconds 2
  $user | Set-ADUser -UserPrincipalName $UserPrincipalName 
  $user | Set-ADUser -DisplayName $DisplayName
  $user | Set-ADUser -SamAccountName $SamAccountName
  $user | Set-ADUser -GivenName $FirstName
  $user | Set-ADUser -Surname $LastName
  $user | Set-ADUser -City $Building
  $user | Set-ADUser -State 'APS-Staff'
  $user | Set-ADUser -Department $Department
  $user | Set-ADUser -Title $Position
  $user | Set-ADUser -Description $Position
  $user | Set-ADUser -Company $Position
  $user | Set-ADUser -EmailAddress $UserPrincipalName
  $user | Set-ADUser -AccountExpirationDate $null

  if ($NickName.Length -gt 1) {
    Set-ADUser -Identity $user -OtherName $NickName
  } else {
    Set-ADUser -Identity $user -OtherName $null
  }
  # ---=== Account enabled, updated, and moved. Password reset conditional. ===---

  Rename-ADObject -Identity $GUID -NewName $Name
    
  Set-ADUser -Identity $GUID -Replace @{MailNickName = $SamAccountName}
  Set-ADUser -Identity $GUID -Replace @{msExchHideFromAddressLists = $false}
  Set-ADUser -Identity $GUID -Add @{proxyAddresses = "SMTP:$UserPrincipalName"}
  Set-ADUser -Identity $GUID -Enabled $true
  Clear-ADAccountExpiration -Identity $GUID
    
  if ($ResetPassword -eq $true) {
    Set-ADAccountPassword -Identity $SamAccountName `
      -Reset -NewPassword (ConvertTo-SecureString "austin.k12.mn.us" -AsPlainText -Force)
    Set-ADUser -Identity $SamAccountName `
      -ChangePasswordAtLogon $true

  }

  $DN = Get-ADUser -Identity $SamAccountName | Select-Object -ExpandProperty DistinguishedName
  Move-ADObject -Identity $DN -TargetPath $OU

  Start-Sleep -Seconds 2

  Group-Staff -UserName $SamAccountName `
    -Position $Position `
    -AHS $AHS `
    -ELL $ELL `
    -IJH $IJH `
    -BAN $BAN `
    -NEV $NEV `
    -SOU $SOU `
    -SUM $SUM `
    -WOO $WOO `
    -CLC $CLC `
    -OAK $OAK `
    -PAE $PAE `
    -RIV $RIV
}

Function Set-Student {
  param(
    [String] $FirstName,
    [String] $LastName,
    [String] $UserName,
    [String] $Building,
    [String] $Grade,
    [Bool] $Advanced,
    [Bool] $Skype,
    [Bool] $Email,
    [Bool] $Violation,
    [Bool] $ResetPassword    
  )

  $ConfirmPreference = 'None'
  
  $Date = Get-Date -Format "%y"
  # $FullDate = Get-Date -Format "yyyy-MM-dd"
  # $DateTime = Get-Date

  $ID = $UserName
  $Surname = $LastName
  $GivenName = $FirstName
  $GradeLevel = [int]$Grade.Split(' ')[1]
  $DisplayName = "$GivenName $Surname - $Grade"
  $SamAccountName = $ID
  $UserPrincipalName = "$ID@austin.k12.mn.us"
  $OU = "OU=$Grade,OU=Student,DC=ISD492,DC=LOCAL"


  Try {
    $Account = Get-ADUser $SamAccountName
    $Exist = $true
  }

  Catch {
    $Exist = $false
  }

  if ($Exist -eq $true) {
    Set-ADUser -Identity $SamAccountName `
      -DisplayName $DisplayName `
      -GivenName $GivenName `
      -Surname $Surname `
      -Description "$Building - $Grade" `
      -Department "$Grade" `
      -Title "Student" `
      -State "APS-Student" `
      -City $Building `
      -EmailAddress "$SamAccountName@austin.k12.mn.us"
    Set-ADUser -Identity $SamAccountName -AccountExpirationDate $null
    Set-ADUser -Identity $SamAccountName -Replace @{MailNickName = $SamAccountName}
    Set-ADUser -Identity $SamAccountName -Replace @{msExchHideFromAddressLists = $false}
    Set-ADUser -Identity $SamAccountName -Add @{proxyAddresses = "SMTP:$SamAccountName@austin.k12.mn.us"}
    $DN = Get-ADUser -Identity $SamAccountName | Select-Object DistinguishedName
    $DNOnly = $DN.DistinguishedName
    Move-ADObject -Identity "$DNOnly" -TargetPath $OU
    Start-Sleep -Seconds 2

    Add-ADGroupMember "DistrictStudents" $SamAccountName
    Add-ADGroupMember "Student-PSO" $SamAccountName
    Add-ADGroupMember "Office 365 - Student Basic" $SamAccountName

    $user = Get-ADUser -Identity $SamAccountName

    if ($Advanced -eq $true) {
      Add-ADGroupMember "Office 365 - Student Advanced" $SamAccountName
      Set-ADObject -Identity $user -Replace @{extensionAttribute1 = 'Advanced'}
    } else {
      Remove-ADGroupMember "Office 365 - Student Advanced" $SamAccountName
      Set-ADObject -Identity $user -Clear extensionAttribute1
    }

    if ($Skype -eq $true) {
      Add-ADGroupMember "Office 365 - Skype" $SamAccountName
      Set-ADObject -Identity $user -Replace @{extensionAttribute2 = 'Skype'}
    } else {
      Remove-ADGroupMember "Office 365 - Skype" $SamAccountName
      Set-ADObject -Identity $user -Clear extensionAttribute2
    }

    if ($Email -eq $true) {
      Add-ADGroupMember "Office 365 - Email" $SamAccountName
      Set-ADObject -Identity $user -Replace @{extensionAttribute3 = 'EMail'}
    } else {
      Remove-ADGroupMember "Office 365 - Email" $SamAccountName
      Set-ADObject -Identity $user -Clear extensionAttribute3
    }

    if ($Violation -eq $true) {
      Set-ADObject -Identity $user -Replace @{extensionAttribute15 = 'Violation'}
    } else {
      Set-ADObject -Identity $user -Clear extensionAttribute15
    }


    if ($ResetPassword -eq $true -or $Account.Enabled -eq $false) {
      Set-ADAccountPassword -Identity $SamAccountName -Reset -NewPassword (ConvertTo-SecureString "Packers$Date" -AsPlainText -Force)
      Set-ADUser -Identity $SamAccountName -ChangePasswordAtLogon $true
    }
  }

  if ($Exist -eq $false) {
    New-ADUser -Name $ID `
      -DisplayName $DisplayName `
      -GivenName $GivenName `
      -Surname $Surname `
      -SamAccountName $SamAccountName `
      -Path $OU `
      -UserPrincipalName $UserPrincipalName `
      -AccountPassword (ConvertTo-SecureString "Packers$Date" -AsPlainText -Force)

    Set-ADUser -Identity $SamAccountName `
      -Enabled $true `
      -ChangePasswordAtLogon $true `
      -Description "$Building - $Grade" `
      -Department "$Grade" `
      -Title "Student" `
      -State "APS-Student" `
      -City $Building `
      -EmailAddress "$SamAccountName@austin.k12.mn.us"
    Set-ADUser -Identity $SamAccountName -Replace @{MailNickName = $SamAccountName}
    Set-ADUser -Identity $SamAccountName -Replace @{msExchHideFromAddressLists = $false}
    Set-ADUser -Identity $SamAccountName -Add @{proxyAddresses = "SMTP:$SamAccountName@austin.k12.mn.us"}

    $user = Get-ADUser -Identity $SamAccountName

    Add-ADGroupMember "DistrictStudents" $SamAccountName
    Add-ADGroupMember "Student-PSO" $SamAccountName
    Add-ADGroupMember "Office 365 - Student Basic" $SamAccountName

    if ($GradeLevel -ge 5) {
      Add-ADGroupMember "Office 365 - Student Advanced" $SamAccountName
      Set-ADObject -Identity $user -Replace @{extensionAttribute1 = '365 Advanced'}

      Add-ADGroupMember "Office 365 - Skype" $SamAccountName
      Set-ADObject -Identity $user -Replace @{extensionAttribute2 = 'Skype'}

      Add-ADGroupMember "Office 365 - Email" $SamAccountName
      Set-ADObject -Identity $user -Replace @{extensionAttribute3 = 'EMail'}
    }
  }

  $ConfirmPreference = 'High'
}


Function Group-Staff {
  param(
    [String] $UserName,
    [String] $Position,
    [Bool] $AHS,
    [Bool] $ELL,
    [Bool] $IJH,
    [Bool] $BAN,
    [Bool] $NEV,
    [Bool] $SOU,
    [Bool] $SUM,
    [Bool] $WOO,
    [Bool] $CLC,
    [Bool] $OAK,
    [Bool] $PAE,
    [Bool] $RIV
  )
  Start-Sleep -Seconds 2
  $ConfirmPreference = 'None'

  # ---=== Set variables for Group Membership ===---
  $user = Get-ADUser -Identity $UserName.ToLower()
  
  # ---=== Default Group Memberships ===---
  Add-ADGroupMember -Identity "DistrictStaff" -Members $user 
  Add-ADGroupMember -Identity "Office 365 - Staff" -Members $user 
  Add-ADGroupMember -Identity "Office 365 - Azure Basic" -Members $user 

  
  # ---=== Position Based Group Assignments ===---
  
  if ($Position -ne "School Board") {
    Add-ADGroupMember -Identity "Employee-PSO" -Members $user   
    Remove-ADGroupMember -Identity "Student-PSO" -Members $user 
    Remove-ADGroupMember -Identity "LowSecurity-PSO" -Members $user 
    Remove-ADGroupMember -Identity "Service-PSO" -Members $user 
  } else {
    Add-ADGroupMember -Identity "LowSecurity-PSO" -Members $user 
    Remove-ADGroupMember -Identity "Employee-PSO" -Members $user 
    Remove-ADGroupMember -Identity "Student-PSO" -Members $user 
    Remove-ADGroupMember -Identity "Service-PSO" -Members $user 
  }
  
  if ($Position -eq "Teacher" -or `
      $Position -eq "Sub Teacher") {
    Add-ADGroupMember -Identity "Teachers" -Members $user 
  } else {
    Remove-ADGroupMember -Identity "Teachers" -Members $user 
  }

  if ($Position.Startswith("Sub") -or `
      $Position -eq "Paraprofessional" -or `
      $Position -eq "Cafeteria" -or `
      $Position -eq "Custodian" -or `
      $Position -eq "School Board") {
    Add-ADGroupMember -Identity "Track-IT_Users" -Members $user 
    Remove-ADGroupMember -Identity "Track-IT_Staff" -Members $user 
  } else {
    Add-ADGroupMember -Identity "Track-IT_Staff" -Members $user 
    Remove-ADGroupMember -Identity "Track-IT_Users" -Members $user 
  }

  # ---=== Building Based Group Assignments ===---
  
  if ($AHS -eq $true) {
    Set-ADObject -Identity $user -Replace @{extensionAttribute1 = "AHS"} 
    Add-ADGroupMember -Identity "Printing - AHS" -Members $user 
  } else {
    Set-ADObject -Identity $user -Clear extensionAttribute1 
    Remove-ADGroupMember -Identity "Printing - AHS" -Members $user 
  }

  if ($ELL -eq $true) {
    Set-ADObject -Identity $user -Replace @{extensionAttribute2 = "ELL"} 
    Add-ADGroupMember -Identity "Printing - Ellis" -Members $user 
  } else {
    Set-ADObject -Identity $user -Clear extensionAttribute2 
    Remove-ADGroupMember -Identity "Printing - Ellis" -Members $user 
  }

  if ($IJH -eq $true) {
    Set-ADObject -Identity $user -Replace @{extensionAttribute3 = "IJH"} 
    Add-ADGroupMember -Identity "Printing - Holton" -Members $user 
  } else {
    Set-ADObject -Identity $user -Clear extensionAttribute3 
    Remove-ADGroupMember -Identity "Printing - Holton" -Members $user 
  }

  if ($BAN -eq $true) {
    Set-ADObject -Identity $user -Replace @{extensionAttribute4 = "BAN"} 
    Add-ADGroupMember -Identity "Printing - Banfield" -Members $user 
  } else {
    Set-ADObject -Identity $user -Clear extensionAttribute4 
    Remove-ADGroupMember -Identity "Printing - Banfield" -Members $user 
  }

  if ($NEV -eq $true) {
    Set-ADObject -Identity $user -Replace @{extensionAttribute5 = "NEV"} 
    Add-ADGroupMember -Identity "Printing - Neveln" -Members $user 
  } else {
    Set-ADObject -Identity $user -Clear extensionAttribute5 
    Remove-ADGroupMember -Identity "Printing - Neveln" -Members $user 
  }

  if ($SOU -eq $true) {
    Set-ADObject -Identity $user -Replace @{extensionAttribute6 = "SOU"} 
    Add-ADGroupMember -Identity "Printing - Southgate" -Members $user 
  } else {
    Set-ADObject -Identity $user -Clear extensionAttribute6 
    Remove-ADGroupMember -Identity "Printing - Southgate" -Members $user 
  }

  if ($SUM -eq $true) {
    Set-ADObject -Identity $user -Replace @{extensionAttribute7 = "SUM"} 
    Add-ADGroupMember -Identity "Printing - Sumner" -Members $user 
  } else {
    Set-ADObject -Identity $user -Clear extensionAttribute7 
    Remove-ADGroupMember -Identity "Printing - Sumner" -Members $user
  }

  if ($WOO -eq $true) {
    Set-ADObject -Identity $user -Replace @{extensionAttribute8 = "WOO"} 
    Add-ADGroupMember -Identity "Printing - Woodson" -Members $user
  } else {
    Set-ADObject -Identity $user -Clear extensionAttribute8 
    Remove-ADGroupMember -Identity "Printing - Woodson" -Members $user 
  }

  if ($CLC -eq $true) {
    Set-ADObject -Identity $user -Replace @{extensionAttribute9 = "CLC"} 
    Add-ADGroupMember -Identity "Printing - CLC" -Members $user 
  } else {
    Set-ADObject -Identity $user -Clear extensionAttribute9 
    Remove-ADGroupMember -Identity "Printing - CLC" -Members $user 
  }
    
  if ($OAK -eq $true) {
    Set-ADObject -Identity $user -Replace @{extensionAttribute10 = "OEC"} 
    Add-ADGroupMember -Identity "Printing - OEC" -Members $user 
  } else {
    Set-ADObject -Identity $user -Clear extensionAttribute10 
    Remove-ADGroupMember -Identity "Printing - OEC" -Members $user 
  }

  if ($PAE -eq $true) {
    Set-ADObject -Identity $user -Replace @{extensionAttribute11 = "PAE"} 
    Add-ADGroupMember -Identity "Printing - PAES" -Members $user 
  } else {
    Set-ADObject -Identity $user -Clear extensionAttribute11 
    Remove-ADGroupMember -Identity "Printing - PAES" -Members $user 
  }

  if ($RIV -eq $true) {
    Set-ADObject -Identity $user -Replace @{extensionAttribute12 = "RIV"} 
    Add-ADGroupMember -Identity "Printing - Riverland" -Members $user 
  } else {
    Set-ADObject -Identity $user -Clear extensionAttribute12 
    Remove-ADGroupMember -Identity "Printing - Riverland" -Members $user 
  }

  $ConfirmPreference = 'High'
}

Function Disable-User {
  param(
    [String]$UserName,
    [System.DateTime]$Date #Both of these will always be filled in disable now will fill in yesterdays date
  )

  Set-ADUser -Identity $UserName `
    -AccountExpirationDate $Date

}

function Disable-UserNow {
  param(
    [String] $SamAccountName
  )
  $user = Get-ADUser -Identity $SamAccountName

  if ($user.DistinguishedName -notlike '*Student*') {
    $OU = "OU=Account Disabled,OU=Employee,DC=ISD492,DC=LOCAL"
    $log = "\\aps-sftp\Logs\ADDisabled\StaffDisabled.csv"
  } else {
    $OU = "OU=Account Disabled,OU=Student,DC=ISD492,DC=LOCAL"
    $log = $null
  }


  $user | Set-ADUser -State "Account Disabled" `
    -EmailAddress "$($user.SamAccountName)@austin.k12.mn.us" `
    -Enabled $false
        
  $user | Set-ADUser -Replace @{MailNickName = $user.SamAccountName}
  $user | Set-ADUser -Replace @{msExchHideFromAddressLists = $true}
  $user | Set-ADUser -Add @{proxyAddresses = "SMTP:$($user.SamAccountName)@austin.k12.mn.us"}

  Move-ADObject -Identity $user.DistinguishedName -TargetPath $OU


  if ($null -ne $log) {
    Start-Sleep -Seconds 2

    Get-ADUser $SamAccountName `
      -Properties `
      SamAccountName,
    Name,
    GivenName,
    Surname,
    DisplayName,
    Description,
    Title,
    Department,
    Company,
    l,
    Mail,
    mailNickname,
    proxyAddresses,
    msExchHideFromAddressLists,
    extensionAttribute1,
    extensionAttribute2,
    extensionAttribute3,
    extensionAttribute4,
    extensionAttribute5,
    extensionAttribute6,
    extensionAttribute7,
    extensionAttribute8,
    extensionAttribute9,
    extensionAttribute10,
    extensionAttribute11,
    extensionAttribute12,
    extensionAttribute13,
    extensionAttribute14,
    extensionAttribute15,
    AccountExpirationDate,
    Modified `
      | `
      Export-Csv -Append -Force -Path $log
  }
}