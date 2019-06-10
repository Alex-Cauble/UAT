#Rename AD User
#Version 1.0
#Alex Cauble


# Load required assembies
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

#Importing used modules
try {
  $s = New-PSSession -ComputerName 'sccm' -ErrorAction Stop
  Import-Module -PSSession $s -Name ActiveDirectory -ErrorAction Stop
} catch {
  Import-Module ActiveDirectory -ErrorAction Stop
}

. "$($PSScriptRoot)\GuiFunctions.ps1"
. "$($PSScriptRoot)\NewStaff.ps1"
. "$($PSScriptRoot)\ModifyStaff.ps1"
. "$($PSScriptRoot)\ModifyStudent.ps1"
. "$($PSScriptRoot)\Classes.ps1"
. "$($PSScriptRoot)\DisableUser.ps1"

#Drawing form and controls
$Form_LookUp = New-Object System.Windows.Forms.Form
$Form_LookUp.Text = "User Accounts Tool"
$Form_LookUp.Size = New-Object System.Drawing.Size(858, 40)
$Form_LookUp.MinimumSize = New-Object System.Drawing.Size(858, 480)
$Form_LookUp.Font = New-Object System.Drawing.Font("Verdana", 10)
$Form_LookUp.TopMost = $true
$Form_LookUp.FormBorderStyle = "Sizable"
$Form_LookUp.StartPosition = "CenterScreen"
$Form_LookUp.Font = "Segoe UI"

# adding a label to my List View
$label_SelectUserList = New-Object System.Windows.Forms.Label
$label_SelectUserList.Location = New-Object System.Drawing.Size(8, 8)
$label_SelectUserList.Size = New-Object System.Drawing.Size(240, 32)
$label_SelectUserList.font = New-Object System.Drawing.Font("Verdana", 10)
$label_SelectUserList.TextAlign = "MiddleLeft"
$label_SelectUserList.Text = "User List"
$Form_LookUp.Controls.Add($label_SelectUserList)

# add a list view
$listview_Users = New-Object System.Windows.Forms.ListView
$listview_Users.Location = New-Object System.Drawing.Size(8, 40)
$listview_Users.Size = New-Object System.Drawing.Size(680, 310)
$listview_Users.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor
[System.Windows.Forms.AnchorStyles]::Left -bor
[System.Windows.Forms.AnchorStyles]::Right -bor
[System.Windows.Forms.AnchorStyles]::Top
$listview_Users.View = "Details"
$listview_Users.MultiSelect = $false
$listview_Users.FullRowSelect = $true
$listview_Users.AllowColumnReorder = $true
$listview_Users.GridLines = $true
$Form_LookUp.Controls.Add($listview_Users)

# adding search label
$label_Search = New-Object System.Windows.Forms.Label
$label_Search.Location = New-Object System.Drawing.Size(15, 355)
$label_Search.Size = New-Object System.Drawing.Size(65, 32)
$label_Search.Font = New-Object System.Drawing.Font("Verdana", 9)
$label_Search.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor
[System.Windows.Forms.AnchorStyles]::Left
$label_Search.TextAlign = "MiddleLeft"
$label_Search.Text = "Search"
$Form_LookUp.Controls.Add($label_Search)


# adding a text field search name
$textBox_SearchName = New-Object System.Windows.Forms.TextBox
$textBox_SearchName.Size = New-Object System.Drawing.Size(608, 20)
$textBox_SearchName.Location = New-Object System.Drawing.Size(80, 360)
$textBox_SearchName.TabIndex = 0
$textBox_SearchName.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor
[System.Windows.Forms.AnchorStyles]::Left -bor
[System.Windows.Forms.AnchorStyles]::Right
$textBox_SearchName.add_KeyDown( {
    if ($_.KeyCode -eq "Enter") {searchADUser}
  })
$Form_LookUp.Controls.Add($textBox_SearchName)

$X = 15;
$XSpacer = 125;
$Y = 395
$buttonSize = New-Object System.Drawing.Size(120, 28)
$buttonFont = New-Object System.Drawing.Font("Verdana", 9)

#region Buttons
$button_SearchStudent = New-Object System.Windows.Forms.Button
$button_SearchStudent.Location = New-Object System.Drawing.Size($X, $Y)
$button_SearchStudent.Size = $buttonSize
$button_SearchStudent.Font = $buttonFont
$button_SearchStudent.TabIndex = 3
$button_SearchStudent.TextAlign = "MiddleCenter"
$button_SearchStudent.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor
[System.Windows.Forms.AnchorStyles]::Left
$button_SearchStudent.text = "Search Students"
$button_SearchStudent.Add_Click( {
    searchStudent
  })
$Form_LookUp.Controls.Add($button_SearchStudent)

$X += $XSpacer

$button_SearchStaff = New-Object System.Windows.Forms.Button
$button_SearchStaff.Location = New-Object System.Drawing.Size($X, $Y)
$button_SearchStaff.Size = $buttonSize
$button_SearchStaff.Font = $buttonFont
$button_SearchStaff.TabIndex = 4
$button_SearchStaff.TextAlign = "MiddleCenter"
$button_SearchStaff.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor
[System.Windows.Forms.AnchorStyles]::Left
$button_SearchStaff.text = "Search Staff"
$button_SearchStaff.Add_Click( {
    searchStaff
  })
$Form_LookUp.Controls.Add($button_SearchStaff)

$X += $XSpacer

$button_NewStudent = New-Object System.Windows.Forms.Button
$button_NewStudent.Location = New-Object System.Drawing.Size($X, $Y)
$button_NewStudent.Size = $buttonSize
$button_NewStudent.Font = $buttonFont
$button_NewStudent.TabIndex = 5
$button_NewStudent.TextAlign = "MiddleCenter"
$button_NewStudent.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor
[System.Windows.Forms.AnchorStyles]::Left
$button_NewStudent.text = "New Student"
$button_NewStudent.Add_Click( {
    ModifyStudent -NewUser

    searchADUser
  })
$Form_LookUp.Controls.Add($button_NewStudent)

$X += $XSpacer

$button_NewUser = New-Object System.Windows.Forms.Button
$button_NewUser.Location = New-Object System.Drawing.Size($X, $Y)
$button_NewUser.Size = $buttonSize
$button_NewUser.Font = $buttonFont
$button_NewUser.TabIndex = 6
$button_NewUser.TextAlign = "MiddleCenter"
$button_NewUser.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor
[System.Windows.Forms.AnchorStyles]::Left
$button_NewUser.text = "New Staff"
$button_NewUser.Add_Click( {
    $userdat = CreateInfo
    if ($userdat.Givenname -ne $null -and $userdat.Surname -ne $null -and $userdat.SamAccountName -ne $null -and $userdat.Building -ne $null`
        -and $userdat.Position -ne $null -and $userdat.Department -ne $null) {
      New-Staff -FirstName $userdat.Givenname -LastName $userdat.Surname -Nickname $userdat.nickname -UserName $userdat.SamAccountName -Position $userdat.Position`
        -Department $userdat.Department -Building $userdat.Building -AHS $userdat.AHS -ELL $userdat.ELL -IJH $userdat.IJH -BAN $userdat.BAN -NEV $userdat.NEV`
        -SOU $userdat.SOU -SUM $userdat.SUM -WOO $userdat.WOO -CLC $userdat.CLC -OAK $userdat.OAK -PAE $userdat.PAE -RIV $userdat.RIV
    } else {
      [System.Windows.Forms.MessageBox]::Show("First, Last, Username, Building, Position, Department", `
          "Required Fields", [System.Windows.Forms.MessageBoxButtons]::OK)
    }
    $textBox_SearchName.Text = $userdat.SamAccountName
    searchADUser
  })
$Form_LookUp.Controls.Add($button_NewUser)

$X += $XSpacer

$button_ModifyUser = New-Object System.Windows.Forms.Button
$button_ModifyUser.Location = New-Object System.Drawing.Size($X, $Y)
$button_ModifyUser.Size = $buttonSize
$button_ModifyUser.TabIndex = 7
$button_ModifyUser.Font = $buttonFont
$button_ModifyUser.TextAlign = "MiddleCenter"
$button_ModifyUser.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor
[System.Windows.Forms.AnchorStyles]::Left
$button_ModifyUser.text = "Modify User"
$button_ModifyUser.Add_Click( {
    try {
      $userdata = SelectedUserName
      if ((Get-ADUser $userdata).DistinguishedName -like "*Student*") {
        ModifyStudent -UserName $userdata
      } else {
        ModifyStaff -UserName $userdata
      }
    } catch {
      [System.Windows.Forms.MessageBox]::Show("Select a user to modify.", "Selected User Required", [System.Windows.Forms.MessageBoxButtons]::OK)
    }
    $textBox_SearchName.text = $userdata
    searchADUser
  })
$Form_LookUp.Controls.Add($button_ModifyUser)

$X += $XSpacer

$button_DisableUser = New-Object System.Windows.Forms.Button
$button_DisableUser.Location = New-Object System.Drawing.Size($X, $Y)
$button_DisableUser.Size = $buttonSize
$button_DisableUser.TabIndex = 8
$button_DisableUser.Font = $buttonFont
$button_DisableUser.TextAlign = "MiddleCenter"
$button_DisableUser.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor
[System.Windows.Forms.AnchorStyles]::Left
$button_DisableUser.text = "Disable Account"
$button_DisableUser.Add_Click( {
    try {
      $userdata = SelectedUserName
      DisableUserWindow -UserName $userdata
    } catch {
      [System.Windows.Forms.MessageBox]::Show("Select a user to Disable.", "Selected User Required", [System.Windows.Forms.MessageBoxButtons]::OK)
    }
    $textBox_SearchName.text = $userdata
    searchADUser
  })
$Form_LookUp.Controls.Add($button_DisableUser)

$button_PWReset = New-Object System.Windows.Forms.Button
$button_PWReset.Location = New-Object System.Drawing.Size(700, 40)
$button_PWReset.Size = New-Object System.Drawing.Size(130, 150)
$button_PWReset.TabIndex = 1
$button_PWReset.Font = New-Object System.Drawing.Font("Verdana", 12)
$button_PWReset.TextAlign = "MiddleCenter"
$button_PWReset.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor
[System.Windows.Forms.AnchorStyles]::Right
$button_PWReset.text = "Password Reset"
$button_PWReset.Add_Click( {
    Try {
      ResetPassword
      searchADUser
    } Catch {
      [System.Windows.Forms.MessageBox]::Show("Select a user to Disable.", "Selected User Required", [System.Windows.Forms.MessageBoxButtons]::OK)
    }
  })
$Form_LookUp.Controls.Add($button_PWReset)

$button_Unlock = New-Object System.Windows.Forms.Button
$button_Unlock.Location = New-Object System.Drawing.Size(700, 200)
$button_Unlock.Size = New-Object System.Drawing.Size(130, 150)
$button_Unlock.Font = New-Object System.Drawing.Font("Verdana", 12)
$button_Unlock.TabIndex = 2
$button_Unlock.TextAlign = "MiddleCenter"
$button_Unlock.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor
[System.Windows.Forms.AnchorStyles]::Right
$button_Unlock.text = "Unlock"
$button_Unlock.Add_Click( {
    try {
      Unlock
      searchADUser
    } Catch {
      [System.Windows.Forms.MessageBox]::Show("Select a user to Disable.", "Selected User Required", [System.Windows.Forms.MessageBoxButtons]::OK)
    }
  })
$Form_LookUp.Controls.Add($button_Unlock)
#endregion

# show form
$Form_LookUp.add_Shown( {
    $Form_LookUp.Activate();
    $textBox_SearchName.Focus();
  })

[void] $Form_LookUp.ShowDialog()