function searchADUser {

  $listview_USers.Items.Clear()
  $listview_USers.Columns.Clear()
  try {
    if ($textBox_SearchName -ne "") {
      $Users = @(Get-ADUser -LDAPFilter ("(anr=" + $textBox_SearchName.text + ")") -Properties DisplayName, LockedOut, AccountExpirationDate|
          Where-Object {($_.distinguishedname -notlike "*Users*") -and ($_.distinguishedname -notlike "*Test*") -and ($_.distinguishedname -notlike "*TechDept*")}|
          Select-Object SamAccountName, Name, DisplayName, Enabled, LockedOut, @{n = 'ExpDate'; e = {$_.AccountExpirationDate.ToShortDateString()}}, @{n = 'OU'; e = {$_.DistinguishedName.split(',')[1].split('=')[1]}}|
          Sort-Object DisplayName)
      PopulateListView -Users $Users
    }
  } catch {
    $null
  }
}

function searchStaff {
  $listview_USers.Items.Clear()
  $listview_USers.Columns.Clear()
  try {
    if ($textBox_SearchName -ne "") {
      $Users = @(Get-ADUser -LDAPFilter ("(anr=" + $textBox_SearchName.text + ")") -Properties DisplayName, LockedOut, AccountExpirationDate|
          Where-Object {($_.distinguishedname -notlike "*Users*") -and ($_.distinguishedname -notlike "*Test*") -and ($_.distinguishedname -notlike "*TechDept*") -and ($_.distinguishedname -notlike "*Student*")}|
          Select-Object SamAccountName, Name, DisplayName, Enabled, LockedOut, @{n = 'ExpDate'; e = {$_.AccountExpirationDate.ToShortDateString()}}, @{n = 'OU'; e = {$_.DistinguishedName.split(',')[1].split('=')[1]}}|
          Sort-Object DisplayName)
      PopulateListView -Users $Users
    }
  } catch {
    $null
  }
}

function searchStudent {

  $listview_USers.Items.Clear()
  $listview_USers.Columns.Clear()
  try {
    if ($textBox_SearchName -ne "") {
      $Users = @(Get-ADUser -LDAPFilter ("(anr=" + $textBox_SearchName.text + ")") -Properties DisplayName, LockedOut -SearchBase "OU=STUDENT,DC=ISD492,DC=Local" |
          Select-Object SamAccountName, Name, DisplayName, Enabled, LockedOut, @{n = 'OU'; e = {$_.DistinguishedName.split(',')[1].split('=')[1]}}|
          Sort-Object DisplayName)
      PopulateListView -Users $Users
    }
  } catch {
    $null
  }
}

function PopulateListView {
  param(
    $Users
  )
  $userProperties = $Users[0].psObject.Properties
  $userProperties | ForEach-Object {
    $listview_Users.Columns.Add("$($_.Name)") | Out-Null
  }
  Foreach ($User in $Users) {
    $userListViewItem = New-Object System.Windows.Forms.ListViewItem($user.samaccountname)

    $User.psObject.Properties | Where-Object {$_.Name -ne "samaccountName"} | ForEach-Object {
      $ColumName = $_.Name
      $userListViewItem.SubItems.Add("$($User.$ColumName)") | Out-Null
    }
    $listview_Users.Items.Add($userListViewItem) | Out-Null
  }
  $listview_Users.AutoResizeColumns("HeaderSize")
  if ($users.Count -eq 1) {
    $listview_Users.Items[0].Selected = $true
    $listview_Users.Select()
  }
}

function ResetPassword {
  $U = SelectedUserName
  $user = Get-ADUser -Identity $U -Properties DisplayName, DistinguishedName
  if ($user.DistinguishedName -like '*student*') {
    $Date = Get-Date -Format '%y'
    if ([System.Windows.Forms.MessageBox]::Show("Reset $($user.DisplayName) to Packers$Date ?", "Question", [System.Windows.Forms.MessageBoxButtons]::OKCancel) -eq "OK") {
      Set-ADAccountPassword -Identity $user.samaccountname -Reset -NewPassword (ConvertTo-SecureString "Packers$Date" -AsPlainText -Force) -Verbose
    }
  } else {
    if ([System.Windows.Forms.MessageBox]::Show("Reset $($user.DisplayName) to austin.k12.mn.us ?", "Question", [System.Windows.Forms.MessageBoxButtons]::OKCancel) -eq "OK") {
      Set-ADAccountPassword -Identity $user.samaccountname -Reset -NewPassword (ConvertTo-SecureString "austin.k12.mn.us" -AsPlainText -Force) -Verbose
    }
  }
  Set-ADUser -Identity $user.ObjectGuid -ChangePasswordAtLogon $true
  Unlock-ADAccount -Identity $user.ObjectGuid
}

function Unlock {
  $U = SelectedUserName
  $user = Get-ADUser -Identity $U -Properties DisplayName
  Unlock-ADAccount -Identity $user.ObjectGuid
  searchADUser
}

function SelectedUserName {
  $selected = @($listview_Users.SelectedIndices)
  $SamAccountNameColumnIndex = $listview_Users.Columns | Where-Object {$_.text -eq "samaccountName"} | Select-Object -ExpandProperty Index
  $selected | ForEach-Object {
    Write-Output ($listview_Users.Items[$_].SubItems[$SamAccountNameColumnIndex]).Text
  }
}

function PopulateFields {
  param(
    [String] $UserName
  )
  $userdata = Get-ADUser -Identity $UserName -Properties *
  #Left
  $textBox_CurrentFirstName.Text = $userdata.GivenName
  $textBox_CurrentLastName.Text = $userdata.Surname
  $textBox_CurrentNickName.Text = $userdata.OtherName
  $textBox_CurrentUsername.Text = $userdata.SamAccountName
  $textBox_CurrentPosition.Text = $userdata.Title
  $textBox_CurrentDepartment.Text = $userdata.Department
  $textBox_CurrentBuilding.Text = $userdata.City
  $checkBoxSec1_AHS.Checked = ($null -ne $userdata.extensionAttribute1)
  $checkBoxSec1_ELL.Checked = ($null -ne $userdata.extensionAttribute2)
  $checkBoxSec1_IJH.Checked = ($null -ne $userdata.extensionAttribute3)
  $checkBoxSec1_BAN.Checked = ($null -ne $userdata.extensionAttribute4)
  $checkBoxSec1_NEV.Checked = ($null -ne $userdata.extensionAttribute5)
  $checkBoxSec1_SOU.Checked = ($null -ne $userdata.extensionAttribute6)
  $checkBoxSec1_SUM.Checked = ($null -ne $userdata.extensionAttribute7)
  $checkBoxSec1_WOO.Checked = ($null -ne $userdata.extensionAttribute8)
  $checkBoxSec1_CLC.Checked = ($null -ne $userdata.extensionAttribute9)
  $checkBoxSec1_OAK.Checked = ($null -ne $userdata.extensionAttribute10)
  $checkBoxSec1_PAE.Checked = ($null -ne $userdata.extensionAttribute11)
  $checkBoxSec1_RIV.Checked = ($null -ne $userdata.extensionAttribute12)
  #Left

  #right
  $textBox_ModifiedFirstName.Text = $userdata.GivenName
  $textBox_ModifiedLastName.Text = $userdata.Surname
  $textBox_ModifiedNickName.Text = $userdata.OtherName
  $textBox_ModifiedUsername.Text = $userdata.SamAccountName
  if ($textBox_ModifiedPosition.Items -notcontains $userdata.Title) {
    $textBox_ModifiedPosition.Items.Add($userdata.Title)
  }
  $textBox_ModifiedPosition.Text = $userdata.Title
  $textBox_ModifiedDepartment.Text = $userdata.Department
  $textBox_ModifiedBuilding.Text = $userdata.City
  $checkBoxSec2_AHS.Checked = ($null -ne $userdata.extensionAttribute1)
  $checkBoxSec2_ELL.Checked = ($null -ne $userdata.extensionAttribute2)
  $checkBoxSec2_IJH.Checked = ($null -ne $userdata.extensionAttribute3)
  $checkBoxSec2_BAN.Checked = ($null -ne $userdata.extensionAttribute4)
  $checkBoxSec2_NEV.Checked = ($null -ne $userdata.extensionAttribute5)
  $checkBoxSec2_SOU.Checked = ($null -ne $userdata.extensionAttribute6)
  $checkBoxSec2_SUM.Checked = ($null -ne $userdata.extensionAttribute7)
  $checkBoxSec2_WOO.Checked = ($null -ne $userdata.extensionAttribute8)
  $checkBoxSec2_CLC.Checked = ($null -ne $userdata.extensionAttribute9)
  $checkBoxSec2_OAK.Checked = ($null -ne $userdata.extensionAttribute10)
  $checkBoxSec2_PAE.Checked = ($null -ne $userdata.extensionAttribute11)
  $checkBoxSec2_RIV.Checked = ($null -ne $userdata.extensionAttribute12)
  #right
}

function ChangedFieldsOutput {
  param(
    $GUID
  )
  if ($textBox_ModifiedNickName.TextLength -gt 1) {
    $nickname = $textBox_ModifiedNickName.text
  } else {
    $nickname = $null
  }
  $props = @{
    'GUID'       = $GUID
    'FirstName'  = $textBox_ModifiedFirstName.Text
    'LastName'   = $textBox_ModifiedLastName.Text
    'NickName'   = $nickname
    'Username'   = $textBox_ModifiedUsername.Text
    'Position'   = $textBox_ModifiedPosition.Text
    'Department' = $textBox_ModifiedDepartment.Text
    'Building'   = $textBox_ModifiedBuilding.Text
    'PWDReset'   = $checkBoxPwdRst.checked
    'AHS'        = $checkBoxSec2_AHS.Checked
    'ELL'        = $checkBoxSec2_ELL.Checked
    'IJH'        = $checkBoxSec2_IJH.Checked
    'BAN'        = $checkBoxSec2_BAN.Checked
    'NEV'        = $checkBoxSec2_NEV.Checked
    'SOU'        = $checkBoxSec2_SOU.Checked
    'SUM'        = $checkBoxSec2_SUM.Checked
    'WOO'        = $checkBoxSec2_WOO.Checked
    'CLC'        = $checkBoxSec2_CLC.Checked
    'OAK'        = $checkBoxSec2_OAK.Checked
    'PAE'        = $checkBoxSec2_PAE.Checked
    'RIV'        = $checkBoxSec2_RIV.Checked
  }
  $obj = New-Object -TypeName psobject -Property $props
  Write-Output $obj
}

function PopulateStudentFields {
  param(
    [String] $UserName
  )
  $userdata = Get-ADUser -Identity $UserName -Properties *
  #Left
  $textBox_CurrentFirstName.Text = $userdata.GivenName
  $textBox_CurrentLastName.Text = $userdata.Surname
  $textBox_CurrentUsername.Text = $userdata.SamAccountName
  $textBox_CurrentBuilding.Text = $userdata.City
  $textbox_Grade.Text = $userdata.Department
  $checkBox_Advanced.Checked = ($null -ne $userdata.extensionAttribute1)
  $checkBox_Skype.Checked = ($null -ne $userdata.extensionAttribute2 )
  $checkBox_Email.Checked = ($null -ne $userdata.extensionAttribute3)
  #Left

  #right
  $textBox_ModifiedFirstName.Text = $userdata.GivenName
  $textBox_ModifiedLastName.Text = $userdata.Surname
  $textBox_ModifiedUsername.Text = $userdata.SamAccountName
  $DropDown_Grade.Text = $userdata.Department
  $DropDown_Building.Text = $userdata.City
  $checkBoxSet_Advanced.Checked = ($null -ne $userdata.extensionAttribute1 )
  $checkBoxSet_Skype.Checked = ($null -ne $userdata.extensionAttribute2 )
  $checkBoxSet_Email.Checked = ($null -ne $userdata.extensionAttribute3 )
  #right
}

function PopulateNewStudent {
  #Left
  $textBox_CurrentFirstName.Text = ''
  $textBox_CurrentLastName.Text = ''
  $textBox_CurrentUsername.Text = ''
  $textBox_CurrentBuilding.Text = ''
  $textbox_Grade.Text = ''
  $checkBox_Advanced.Checked = $false
  $checkBox_Skype.Checked = $false
  $checkBox_Email.Checked = $false
  #Left

  #right
  $textBox_ModifiedFirstName.Text = ''
  $textBox_ModifiedLastName.Text = ''
  $textBox_ModifiedUsername.Text = ''
  $DropDown_Grade.Text = ''
  $DropDown_Building.Text = ''
  $checkBoxSet_Advanced.Checked = $true
  $checkBoxSet_Skype.Checked = $true
  $checkBoxSet_Email.Checked = $true
  #right
  $textBox_ModifiedUsername.Enabled = $true
  $textBox_ModifiedUsername.TabIndex = 2
  $DropDown_Grade.TabIndex = 3
  $DropDown_Building.TabIndex = 4
  $Button_Apply.TabIndex = 5
}

function CapitalizeName {
  param (
    $Name
  )
  if ($Name.Length -gt 0) {
    $upper = $Name.ToUpper()
    $upper = $upper.toChararray()
    $Name = $Name.ToCharArray()
    $name[0] = $upper[0]
    $name = -join $name
  }
  Write-Output $Name
}

function ModifyStaffEnableApplyButton {
  $Button_Apply.Enabled = $true
  if ($textBox_ModifiedPosition.Text.Length -lt 1 -or $textBox_ModifiedDepartment.Text.Length -lt 1 -or $textBox_ModifiedBuilding.Text.Length -lt 1) {
    $Button_Apply.Enabled = $false
  } 
}

function NewStaffEnableOkButton {
  $okbutton.Enabled = $true
  if ($DropDown1_Position.Text.Length -lt 1 -or $DropDown2_Department.Text.Length -lt 1 -or $DropDown3_Building.Text.Length -lt 1 -or $TextBox_FirstName.Text.Length -lt 1 -or $TextBox_LastName.Text.Length -lt 1 -or $TextBox_UserName.Text.Length -lt 1) {
    $okbutton.Enabled = $false
  } 
}
