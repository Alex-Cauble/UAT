Add-Type -AssemblyName System.Windows.Forms

function ModifyStaff {
  param(
    [String] $UserName
  )
  . "$($PSScriptRoot)\GuiFunctions.ps1"
  . "$($PSScriptRoot)\ADFunctions.ps1"
  . "$($PSScriptRoot)\Classes.ps1"

  # Variable Set UP
  [bool] $Global:useNickname = $false
  $ComboBoxFont = New-Object System.Drawing.Font("Verdana", 9)

  $LabelData = @{
    'Title'          = "Update Staff Account"
    'Header'         = "Current Staff Data"
    'LastName'       = "Last Name:"
    'FirstName'      = "First Name:"
    'NickName'       = "Nickname:"
    'UserName'       = "Username:"
    'Position'       = "Position:"
    'Department'     = "Department:"
    'Building'       = "Building:"
    'CheckBoxHeader' = "All Locations Worked"
  }
  $textInfo = (Get-Culture).TextInfo
  #region ComboBox Data
  [String[]]$Position = Get-Content -Path "$($PSScriptRoot)\..\data\PositionList.txt"
  
  [String[]]$Department = Get-Content -Path "$($PSScriptRoot)\..\data\DepartmentList.txt"
  
  [String[]]$Building = Get-Content -Path "$($PSScriptRoot)\..\data\BuildingsList.txt"
  #endregion

  $Form_Modify = New-Object System.Windows.Forms.Form
  $Form_Modify.Text = "User Accounts Tool"
  $Form_Modify.Size = New-Object System.Drawing.Size (610, 600)
  $Form_Modify.TopMost = $true
  $Form_Modify.MaximizeBox = $false
  $Form_Modify.MinimizeBox = $false
  $Form_Modify.FormBorderStyle = "FixedDialog"
  $Form_Modify.StartPosition = "CenterScreen"
  $Form_Modify.Font = New-Object System.Drawing.Font("Verdana", 10)

  #region Left Column
  $X = 10
  $Y = 40
  $XSpacer = 110
  $YSpacer = 25
  $labelSize = New-Object System.Drawing.Size(100, 20)
  $labelFontSize = New-Object System.Drawing.Font ("Veranda", 10)
  $textBoxSize = New-Object System.Drawing.Size(147, 20)

  $header_TextFields = New-Object System.Windows.Forms.Label;
  $header_TextFields.Location = New-Object System.Drawing.Size(0, 10)
  $header_TextFields.Size = New-Object System.Drawing.Size(300, 25)
  $header_TextFields.Font = New-Object System.Drawing.Font("Verdana", 14)
  $header_TextFields.TextAlign = "MiddleCenter"
  $header_TextFields.Text = $LabelData.Header
  $Form_Modify.Controls.Add($header_TextFields)

  $label_CurrentFirstName = New-Object System.Windows.Forms.Label
  $label_CurrentFirstName.Location = New-Object System.Drawing.Size($X, $Y)
  $label_CurrentFirstName.Size = $labelSize
  $label_CurrentFirstName.Font = $labelFontSize
  $label_CurrentFirstName.TextAlign = "MiddleRight"
  $label_CurrentFirstName.Text = $LabelData.FirstName
  $Form_Modify.Controls.Add($label_CurrentFirstName)

  $Y += $YSpacer
  $label_CurrentLastName = New-Object System.Windows.Forms.Label
  $label_CurrentLastName.Location = New-Object System.Drawing.Size($X, $Y)
  $label_CurrentLastName.Size = $labelSize
  $label_CurrentLastName.Font = $labelFontSize
  $label_CurrentLastName.TextAlign = "MiddleRight"
  $label_CurrentLastName.Text = $LabelData.LastName
  $Form_Modify.Controls.Add($label_CurrentLastName)

  $Y += $YSpacer
  $label_CurrentNickName = New-Object System.Windows.Forms.Label
  $label_CurrentNickName.Location = New-Object System.Drawing.Size($X, $Y)
  $label_CurrentNickName.Size = $labelSize
  $label_CurrentNickName.Font = $labelFontSize
  $label_CurrentNickName.TextAlign = "MiddleRight"
  $label_CurrentNickName.Text = $LabelData.NickName
  $Form_Modify.Controls.Add($label_CurrentNickName)

  $Y += $YSpacer
  $label_CurrentUserName = New-Object System.Windows.Forms.Label
  $label_CurrentUserName.Location = New-Object System.Drawing.Size($X, $Y)
  $label_CurrentUserName.Size = $labelSize
  $label_CurrentUserName.Font = $labelFontSize
  $label_CurrentUserName.TextAlign = "MiddleRight"
  $label_CurrentUserName.Text = $LabelData.UserName
  $Form_Modify.Controls.Add($label_CurrentUserName)

  $Y += $YSpacer
  $label_CurrentPosition = New-Object System.Windows.Forms.Label
  $label_CurrentPosition.Location = New-Object System.Drawing.Size($X, $Y)
  $label_CurrentPosition.Size = $labelSize
  $label_CurrentPosition.Font = $labelFontSize
  $label_CurrentPosition.TextAlign = "MiddleRight"
  $label_CurrentPosition.Text = $LabelData.Position
  $Form_Modify.Controls.Add($label_CurrentPosition)

  $Y += $YSpacer
  $label_CurrentDepartment = New-Object System.Windows.Forms.Label
  $label_CurrentDepartment.Location = New-Object System.Drawing.Size($X, $Y)
  $label_CurrentDepartment.Size = $labelSize
  $label_CurrentDepartment.Font = $labelFontSize
  $label_CurrentDepartment.TextAlign = "MiddleRight"
  $label_CurrentDepartment.Text = $LabelData.Department
  $Form_Modify.Controls.Add($label_CurrentDepartment)

  $Y += $YSpacer
  $label_CurrentPrimaryBuilding = New-Object System.Windows.Forms.Label
  $label_CurrentPrimaryBuilding.Location = New-Object System.Drawing.Size($X, $Y)
  $label_CurrentPrimaryBuilding.Size = $labelSize
  $label_CurrentPrimaryBuilding.Font = $labelFontSize
  $label_CurrentPrimaryBuilding.TextAlign = "MiddleRight"
  $label_CurrentPrimaryBuilding.Text = $LabelData.Building
  $Form_Modify.Controls.Add($label_CurrentPrimaryBuilding)

  #Resetting Data for New Column
  $Y = 40
  $X += $XSpacer

  $textBox_CurrentFirstName = New-Object System.Windows.Forms.TextBox
  $textBox_CurrentFirstName.Location = New-Object System.Drawing.Size($X, $Y)
  $textBox_CurrentFirstName.Size = $textBoxSize
  $textBox_CurrentFirstName.Enabled = $false
  $Form_Modify.Controls.Add($textBox_CurrentFirstName)

  $Y += $YSpacer
  $textBox_CurrentLastName = New-Object System.Windows.Forms.TextBox
  $textBox_CurrentLastName.Location = New-Object System.Drawing.Size($X, $Y)
  $textBox_CurrentLastName.Size = $textBoxSize
  $textBox_CurrentLastName.Enabled = $false
  $Form_Modify.Controls.Add($textBox_CurrentLastName)

  $Y += $YSpacer
  $textBox_CurrentNickName = New-Object System.Windows.Forms.TextBox
  $textBox_CurrentNickName.Location = New-Object System.Drawing.Size($X, $Y)
  $textBox_CurrentNickName.Size = $textBoxSize
  $textBox_CurrentNickName.Enabled = $false
  $Form_Modify.Controls.Add($textBox_CurrentNickName)

  $Y += $YSpacer
  $textBox_CurrentUsername = New-Object System.Windows.Forms.TextBox
  $textBox_CurrentUsername.Location = New-Object System.Drawing.Size($X, $Y)
  $textBox_CurrentUsername.Size = $textBoxSize
  $textBox_CurrentUsername.Enabled = $false
  $Form_Modify.Controls.Add($textBox_CurrentUsername)

  $Y += $YSpacer
  $textBox_CurrentPosition = New-Object System.Windows.Forms.TextBox
  $textBox_CurrentPosition.Location = New-Object System.Drawing.Size($X, $Y)
  $textBox_CurrentPosition.Size = $textBoxSize
  $textBox_CurrentPosition.Enabled = $false
  $Form_Modify.Controls.Add($textBox_CurrentPosition)

  $Y += $YSpacer
  $textBox_CurrentDepartment = New-Object System.Windows.Forms.TextBox
  $textBox_CurrentDepartment.Location = New-Object System.Drawing.Size($X, $Y)
  $textBox_CurrentDepartment.Size = $textBoxSize
  $textBox_CurrentDepartment.Enabled = $false
  $Form_Modify.Controls.Add($textBox_CurrentDepartment)

  $Y += $YSpacer
  $textBox_CurrentBuilding = New-Object System.Windows.Forms.TextBox
  $textBox_CurrentBuilding.Location = New-Object System.Drawing.Size($X, $Y)
  $textBox_CurrentBuilding.Size = $textBoxSize
  $textBox_CurrentBuilding.Enabled = $false
  $Form_Modify.Controls.Add($textBox_CurrentBuilding)


  $checkBoxTitle1 = New-Object System.Windows.Forms.Label;
  $checkBoxTitle1.Size = New-Object System.Drawing.Size(300, 30)
  $checkBoxTitle1.Location = New-Object System.Drawing.Size(0, ($Y + 25))
  $checkBoxTitle1.TextAlign = "MiddleCenter";
  $checkBoxTitle1.Font = New-Object System.Drawing.Font("Verdana", 12);
  $checkBoxTitle1.Text = $LabelData.CheckBoxHeader;
  $Form_Modify.Controls.Add($checkBoxTitle1)

  $col1 = 40
  $col2 = 160
  $YSpacer = 30

  $Y = 250
  $checkBoxSec1_AHS = New-Object System.Windows.Forms.CheckBox
  $checkBoxSec1_AHS.Location = New-Object System.Drawing.Size($col1, $Y)
  $checkBoxSec1_AHS.Text = "AHS"
  $checkBoxSec1_AHS.Enabled = $false
  $Form_Modify.Controls.Add($checkBoxSec1_AHS)

  $checkBoxSec1_ELL = New-Object System.Windows.Forms.CheckBox
  $checkBoxSec1_ELL.Location = New-Object System.Drawing.Size($col2, $Y)
  $checkBoxSec1_ELL.Text = "Ellis"
  $checkBoxSec1_ELL.Enabled = $false
  $Form_Modify.Controls.Add($checkBoxSec1_ELL)

  $Y += $YSpacer
  $checkBoxSec1_IJH = New-Object System.Windows.Forms.CheckBox
  $checkBoxSec1_IJH.Location = New-Object System.Drawing.Size($col1, $Y)
  $checkBoxSec1_IJH.Text = "IJH"
  $checkBoxSec1_IJH.Enabled = $false
  $Form_Modify.Controls.Add($checkBoxSec1_IJH)

  $checkBoxSec1_BAN = New-Object System.Windows.Forms.CheckBox
  $checkBoxSec1_BAN.Location = New-Object System.Drawing.Size($col2, $Y)
  $checkBoxSec1_BAN.Text = "Banfield"
  $checkBoxSec1_BAN.Enabled = $false
  $Form_Modify.Controls.Add($checkBoxSec1_BAN)

  $Y += $YSpacer
  $checkBoxSec1_NEV = New-Object System.Windows.Forms.CheckBox
  $checkBoxSec1_NEV.Location = New-Object System.Drawing.Size($col1, $Y)
  $checkBoxSec1_NEV.Text = "Neveln"
  $checkBoxSec1_NEV.Enabled = $false
  $Form_Modify.Controls.Add($checkBoxSec1_NEV)

  $checkBoxSec1_SOU = New-Object System.Windows.Forms.CheckBox
  $checkBoxSec1_SOU.Location = New-Object System.Drawing.Size($col2, $Y)
  $checkBoxSec1_SOU.Text = "Southgate"
  $checkBoxSec1_SOU.Enabled = $false
  $Form_Modify.Controls.Add($checkBoxSec1_SOU)

  $Y += $YSpacer
  $checkBoxSec1_SUM = New-Object System.Windows.Forms.CheckBox
  $checkBoxSec1_SUM.Location = New-Object System.Drawing.Size($col1, $Y)
  $checkBoxSec1_SUM.Text = "Sumner"
  $checkBoxSec1_SUM.Enabled = $false
  $Form_Modify.Controls.Add($checkBoxSec1_SUM)

  $checkBoxSec1_WOO = New-Object System.Windows.Forms.CheckBox
  $checkBoxSec1_WOO.Location = New-Object System.Drawing.Size($col2, $Y)
  $checkBoxSec1_WOO.Text = "Woodson"
  $checkBoxSec1_WOO.Enabled = $false
  $Form_Modify.Controls.Add($checkBoxSec1_WOO)

  $Y += $YSpacer
  $checkBoxSec1_CLC = New-Object System.Windows.Forms.CheckBox
  $checkBoxSec1_CLC.Location = New-Object System.Drawing.Size($col1, $Y)
  $checkBoxSec1_CLC.Text = "CLC"
  $checkBoxSec1_CLC.Enabled = $false
  $Form_Modify.Controls.Add($checkBoxSec1_CLC)

  $checkBoxSec1_OAK = New-Object System.Windows.Forms.CheckBox
  $checkBoxSec1_OAK.Location = New-Object System.Drawing.Size($col2, $Y)
  $checkBoxSec1_OAK.Text = "Oakland"
  $checkBoxSec1_OAK.Enabled = $false
  $Form_Modify.Controls.Add($checkBoxSec1_OAK)

  $Y += $YSpacer
  $checkBoxSec1_PAE = New-Object System.Windows.Forms.CheckBox
  $checkBoxSec1_PAE.Location = New-Object System.Drawing.Size($col1, $Y)
  $checkBoxSec1_PAE.Text = "PAES"
  $checkBoxSec1_PAE.Enabled = $false
  $Form_Modify.Controls.Add($checkBoxSec1_PAE)

  $checkBoxSec1_RIV = New-Object System.Windows.Forms.CheckBox
  $checkBoxSec1_RIV.Location = New-Object System.Drawing.Size($col2, $Y)
  $checkBoxSec1_RIV.Text = "Riverland"
  $checkBoxSec1_RIV.Enabled = $false
  $Form_Modify.Controls.Add($checkBoxSec1_RIV)
  #endregion

  #region Right Column
  $X = 310
  $Y = 40
  $XSpacer = 110
  $YSpacer = 25
  $labelSize = New-Object System.Drawing.Size(100, 20)
  $labelFontSize = New-Object System.Drawing.Font ("Veranda", 11)
  $textBoxSize = New-Object System.Drawing.Size(147, 20)

  $header2_TextFields = New-Object System.Windows.Forms.Label;
  $header2_TextFields.Location = New-Object System.Drawing.Size(300, 10)
  $header2_TextFields.Size = New-Object System.Drawing.Size(300, 25)
  $header2_TextFields.Font = New-Object System.Drawing.Font("Verdana", 14)
  $header2_TextFields.TextAlign = "MiddleCenter"
  $header2_TextFields.Text = 'Modified Staff Data'
  $Form_Modify.Controls.Add($header2_TextFields)

  $label_ModifiedFirstName = New-Object System.Windows.Forms.Label
  $label_ModifiedFirstName.Location = New-Object System.Drawing.Size($X, $Y)
  $label_ModifiedFirstName.Size = $labelSize
  $label_ModifiedFirstName.Font = $labelFontSize
  $label_ModifiedFirstName.TextAlign = "MiddleRight"
  $label_ModifiedFirstName.Text = $LabelData.FirstName
  $Form_Modify.Controls.Add($label_ModifiedFirstName)

  $Y += $YSpacer
  $label_ModifiedLastName = New-Object System.Windows.Forms.Label
  $label_ModifiedLastName.Location = New-Object System.Drawing.Size($X, $Y)
  $label_ModifiedLastName.Size = $labelSize
  $label_ModifiedLastName.Font = $labelFontSize
  $label_ModifiedLastName.TextAlign = "MiddleRight"
  $label_ModifiedLastName.Text = $LabelData.LastName
  $Form_Modify.Controls.Add($label_ModifiedLastName)

  $Y += $YSpacer
  $label_ModifiedNickName = New-Object System.Windows.Forms.Label
  $label_ModifiedNickName.Location = New-Object System.Drawing.Size($X, $Y)
  $label_ModifiedNickName.Size = $labelSize
  $label_ModifiedNickName.Font = $labelFontSize
  $label_ModifiedNickName.TextAlign = "MiddleRight"
  $label_ModifiedNickName.Text = $LabelData.NickName
  $Form_Modify.Controls.Add($label_ModifiedNickName)

  $Y += $YSpacer
  $label_ModifiedUserName = New-Object System.Windows.Forms.Label
  $label_ModifiedUserName.Location = New-Object System.Drawing.Size($X, $Y)
  $label_ModifiedUserName.Size = $labelSize
  $label_ModifiedUserName.Font = $labelFontSize
  $label_ModifiedUserName.TextAlign = "MiddleRight"
  $label_ModifiedUserName.Text = $LabelData.UserName
  $Form_Modify.Controls.Add($label_ModifiedUserName)

  $Y += $YSpacer
  $label_ModifiedPosition = New-Object System.Windows.Forms.Label
  $label_ModifiedPosition.Location = New-Object System.Drawing.Size($X, $Y)
  $label_ModifiedPosition.Size = $labelSize
  $label_ModifiedPosition.Font = $labelFontSize
  $label_ModifiedPosition.TextAlign = "MiddleRight"
  $label_ModifiedPosition.Text = $LabelData.Position
  $Form_Modify.Controls.Add($label_ModifiedPosition)

  $Y += $YSpacer
  $label_ModifiedDepartment = New-Object System.Windows.Forms.Label
  $label_ModifiedDepartment.Location = New-Object System.Drawing.Size($X, $Y)
  $label_ModifiedDepartment.Size = $labelSize
  $label_ModifiedDepartment.Font = $labelFontSize
  $label_ModifiedDepartment.TextAlign = "MiddleRight"
  $label_ModifiedDepartment.Text = $LabelData.Department
  $Form_Modify.Controls.Add($label_ModifiedDepartment)

  $Y += $YSpacer
  $label_ModifiedPrimaryBuilding = New-Object System.Windows.Forms.Label
  $label_ModifiedPrimaryBuilding.Location = New-Object System.Drawing.Size($X, $Y)
  $label_ModifiedPrimaryBuilding.Size = $labelSize
  $label_ModifiedPrimaryBuilding.Font = $labelFontSize
  $label_ModifiedPrimaryBuilding.TextAlign = "MiddleRight"
  $label_ModifiedPrimaryBuilding.Text = $LabelData.Building
  $Form_Modify.Controls.Add($label_ModifiedPrimaryBuilding)

  #Resetting Data for New Column
  $Y = 40
  $X += $XSpacer

  $textBox_ModifiedFirstName = New-Object System.Windows.Forms.TextBox
  $textBox_ModifiedFirstName.Location = New-Object System.Drawing.Size($X, $Y)
  $textBox_ModifiedFirstName.TabIndex = 0
  $textBox_ModifiedFirstName.Size = $textBoxSize
  $textBox_ModifiedFirstName.add_TextChanged( {
      $textBox_ModifiedFirstName.Text = $textinfo.ToTitleCase($textBox_ModifiedFirstName.Text)
      $textBox_ModifiedFirstName.SelectionStart = $textBox_ModifiedFirstName.Text.Length
      $textBox_ModifiedFirstName.SelectionLength = 0
    })
  $Form_Modify.Controls.Add($textBox_ModifiedFirstName)

  $Y += $YSpacer
  $textBox_ModifiedLastName = New-Object System.Windows.Forms.TextBox
  $textBox_ModifiedLastName.Location = New-Object System.Drawing.Size($X, $Y)
  $textBox_ModifiedLastName.TabIndex = 1
  $textBox_ModifiedLastName.Size = $textBoxSize
  $textBox_ModifiedLastName.add_TextChanged( {
      $textBox_ModifiedLastName.Text = $textinfo.ToTitleCase($textBox_ModifiedLastName.Text)
      $textBox_ModifiedLastName.SelectionStart = $textBox_ModifiedLastName.Text.Length
      $textBox_ModifiedLastName.SelectionLength = 0
    })
  $Form_Modify.Controls.Add($textBox_ModifiedLastName)

  $Y += $YSpacer
  $textBox_ModifiedNickName = New-Object System.Windows.Forms.TextBox
  $textBox_ModifiedNickName.Location = New-Object System.Drawing.Size($X, $Y)
  $textBox_ModifiedNickName.TabIndex = 2
  $textBox_ModifiedNickName.Size = $textBoxSize
  $textBox_ModifiedNickName.add_TextChanged( {
      $textBox_ModifiedNickName.Text = $textinfo.ToTitleCase($textBox_ModifiedNickName.Text)
      $textBox_ModifiedNickName.SelectionStart = $textBox_ModifiedNickName.Text.Length
      $textBox_ModifiedNickName.SelectionLength = 0
    })
  $Form_Modify.Controls.Add($textBox_ModifiedNickName)

  $Y += $YSpacer
  $textBox_ModifiedUsername = New-Object System.Windows.Forms.TextBox
  $textBox_ModifiedUsername.Location = New-Object System.Drawing.Size($X, $Y)
  $textBox_ModifiedUsername.Size = $textBoxSize
  $textBox_ModifiedUsername.MaxLength = 20
  $textBox_ModifiedUsername.Enabled = $false
  $Form_Modify.Controls.Add($textBox_ModifiedUsername)

  $button_genUsername = New-Object System.Windows.Forms.Button
  $button_genUsername.Location = New-Object System.Drawing.Size(($x - 9), $y)
  $button_genUsername.Size = New-Object System.Drawing.Size (8, 20)
  $button_genUsername.TabIndex = 3
  $button_genUsername.ADD_Click( {
      if ($useNickname) {
        $string = "$($textBox_ModifiedNickName.Text).$($textBox_ModifiedLastName.Text)".ToLower()
        if ($string.Length -gt 20) {
          $string = $string.Substring(0, 20)
        }
        $textBox_ModifiedUsername.Text = $string
        $Global:useNickname = $False
      } else {
        $string = "$($textBox_ModifiedFirstName.Text).$($textBox_ModifiedLastName.Text)".ToLower()
        if ($string.Length -gt 20) {
          $string = $string.Substring(0, 20)
        }
        $textBox_ModifiedUsername.Text = $string
        $Global:useNickname = $True
      }
    })
  $Form_Modify.Controls.Add($button_genUsername) 

  $Y += $YSpacer
  $textBox_ModifiedPosition = New-Object System.Windows.Forms.ComboBox
  $textBox_ModifiedPosition.Location = New-Object System.Drawing.Size($X, $Y)
  $textBox_ModifiedPosition.TabIndex = 4
  $textBox_ModifiedPosition.Font = $ComboBoxFont
  $textBox_ModifiedPosition.Size = $textBoxSize
  $textBox_ModifiedPosition.DropDownStyle = 'DropDownList'
  foreach ($item in $Position) {
    [void]$textBox_ModifiedPosition.Items.add($item)
  }
  $Form_Modify.Controls.Add($textBox_ModifiedPosition)

  $Position_SelectedIndexChanged = {
    if ($textBox_ModifiedPosition.Text -eq 'Other-District [Edit]') {
      $textBox_ModifiedPosition.DropDownStyle = 'DropDown'
    } else {
      $textBox_ModifiedPosition.DropDownStyle = 'DropDownList'
    }
  }
  $textBox_ModifiedPosition.add_SelectedIndexChanged($Position_SelectedIndexChanged)

  $Y += $YSpacer
  $textBox_ModifiedDepartment = New-Object System.Windows.Forms.ComboBox
  $textBox_ModifiedDepartment.Location = New-Object System.Drawing.Size($X, $Y)
  $textBox_ModifiedDepartment.TabIndex = 5
  $textBox_ModifiedDepartment.Font = $ComboBoxFont
  $textBox_ModifiedDepartment.Size = $textBoxSize
  $textBox_ModifiedDepartment.DropDownStyle = 'DropDownList'
  foreach ($item in $Department) {
    [void]$textBox_ModifiedDepartment.Items.add($item)
  }
  $Form_Modify.Controls.Add($textBox_ModifiedDepartment)

  $Y += $YSpacer
  $textBox_ModifiedBuilding = New-Object System.Windows.Forms.ComboBox
  $textBox_ModifiedBuilding.Location = New-Object System.Drawing.Size($X, $Y)
  $textBox_ModifiedBuilding.TabIndex = 6
  $textBox_ModifiedBuilding.Font = $ComboBoxFont
  $textBox_ModifiedBuilding.Size = $textBoxSize
  $textBox_ModifiedBuilding.DropDownStyle = 'DropDownList'
  foreach ($item in $Building) {
    [void]$textBox_ModifiedBuilding.Items.add($item)
  }
  $Form_Modify.Controls.Add($textBox_ModifiedBuilding)

  $checkBoxTitle1 = New-Object System.Windows.Forms.Label;
  $checkBoxTitle1.Size = New-Object System.Drawing.Size(300, 30)
  $checkBoxTitle1.Location = New-Object System.Drawing.Size(300, ($Y + 25))
  $checkBoxTitle1.TextAlign = "MiddleCenter";
  $checkBoxTitle1.Font = New-Object System.Drawing.Font("Verdana", 12);
  $checkBoxTitle1.Text = $LabelData.CheckBoxHeader;
  $Form_Modify.Controls.Add($checkBoxTitle1)

  $col1 = 340
  $col2 = 460
  $YSpacer = 30

  $Y = 250
  $checkBoxSec2_AHS = New-Object System.Windows.Forms.CheckBox
  $checkBoxSec2_AHS.Location = New-Object System.Drawing.Size($col1, $Y)
  $checkBoxSec2_AHS.Text = "AHS"
  $Form_Modify.Controls.Add($checkBoxSec2_AHS)

  $checkBoxSec2_ELL = New-Object System.Windows.Forms.CheckBox
  $checkBoxSec2_ELL.Location = New-Object System.Drawing.Size($col2, $Y)
  $checkBoxSec2_ELL.Text = "Ellis"
  $Form_Modify.Controls.Add($checkBoxSec2_ELL)

  $Y += $YSpacer
  $checkBoxSec2_IJH = New-Object System.Windows.Forms.CheckBox
  $checkBoxSec2_IJH.Location = New-Object System.Drawing.Size($col1, $Y)
  $checkBoxSec2_IJH.Text = "IJH"
  $Form_Modify.Controls.Add($checkBoxSec2_IJH)

  $checkBoxSec2_BAN = New-Object System.Windows.Forms.CheckBox
  $checkBoxSec2_BAN.Location = New-Object System.Drawing.Size($col2, $Y)
  $checkBoxSec2_BAN.Text = "Banfield"
  $Form_Modify.Controls.Add($checkBoxSec2_BAN)

  $Y += $YSpacer
  $checkBoxSec2_NEV = New-Object System.Windows.Forms.CheckBox
  $checkBoxSec2_NEV.Location = New-Object System.Drawing.Size($col1, $Y)
  $checkBoxSec2_NEV.Text = "Neveln"
  $Form_Modify.Controls.Add($checkBoxSec2_NEV)

  $checkBoxSec2_SOU = New-Object System.Windows.Forms.CheckBox
  $checkBoxSec2_SOU.Location = New-Object System.Drawing.Size($col2, $Y)
  $checkBoxSec2_SOU.Text = "Southgate"
  $Form_Modify.Controls.Add($checkBoxSec2_SOU)

  $Y += $YSpacer
  $checkBoxSec2_SUM = New-Object System.Windows.Forms.CheckBox
  $checkBoxSec2_SUM.Location = New-Object System.Drawing.Size($col1, $Y)
  $checkBoxSec2_SUM.Text = "Sumner"
  $Form_Modify.Controls.Add($checkBoxSec2_SUM)

  $checkBoxSec2_WOO = New-Object System.Windows.Forms.CheckBox
  $checkBoxSec2_WOO.Location = New-Object System.Drawing.Size($col2, $Y)
  $checkBoxSec2_WOO.Text = "Woodson"
  $Form_Modify.Controls.Add($checkBoxSec2_WOO)

  $Y += $YSpacer
  $checkBoxSec2_CLC = New-Object System.Windows.Forms.CheckBox
  $checkBoxSec2_CLC.Location = New-Object System.Drawing.Size($col1, $Y)
  $checkBoxSec2_CLC.Text = "CLC"
  $Form_Modify.Controls.Add($checkBoxSec2_CLC)

  $checkBoxSec2_OAK = New-Object System.Windows.Forms.CheckBox
  $checkBoxSec2_OAK.Location = New-Object System.Drawing.Size($col2, $Y)
  $checkBoxSec2_OAK.Text = "Oakland"
  $Form_Modify.Controls.Add($checkBoxSec2_OAK)

  $Y += $YSpacer
  $checkBoxSec2_PAE = New-Object System.Windows.Forms.CheckBox
  $checkBoxSec2_PAE.Location = New-Object System.Drawing.Size($col1, $Y)
  $checkBoxSec2_PAE.Text = "PAES"
  $Form_Modify.Controls.Add($checkBoxSec2_PAE)

  $checkBoxSec2_RIV = New-Object System.Windows.Forms.CheckBox
  $checkBoxSec2_RIV.Location = New-Object System.Drawing.Size($col2, $Y)
  $checkBoxSec2_RIV.Text = "Riverland"
  $Form_Modify.Controls.Add($checkBoxSec2_RIV)
  #endregion

  $checkBoxPwdRst = New-Object System.Windows.Forms.CheckBox
  $checkBoxPwdRst.Size = New-Object System.Drawing.Size(150, 20)
  $checkBoxPwdRst.Location = New-Object System.Drawing.Size(230, ($Y + ($YSpacer * 2)))
  $checkBoxPwdRst.Text = "Reset Password"
  $Form_Modify.Controls.Add($checkBoxPwdRst)

  $Button_Apply = New-Object System.Windows.Forms.Button
  $Button_Apply.Size = New-Object System.Drawing.Size(150, 20)
  $Button_Apply.Location = New-Object System.Drawing.Size(220, ($Y + ($YSpacer * 3)))
  $Button_Apply.Text = "Apply Changes"
  $Button_Apply.ADD_Click( {
      try {
        $userdat = ChangedFieldsOutput -GUID (Get-ADUser $UserName).ObjectGUID
        if ($null -eq $userdat.Building) {
          throw 'building required'
        }
        Set-Staff -GUID $userdat.GUID -FirstName $userdat.FirstName -LastName $userdat.LastName -Nickname $userdat.NickName -UserName $userdat.UserName`
          -Position $userdat.Position -Department $userdat.Department -Building $userdat.Building -AHS $userdat.AHS -ELL $userdat.ELL -IJH $userdat.IJH`
          -BAN $userdat.BAN -NEV $userdat.NEV -SOU $userdat.SOU -SUM $userdat.SUM -WOO $userdat.WOO -CLC $userdat.CLC -OAK $userdat.OAK -PAE $userdat.PAE`
          -RIV $userdat.RIV -ResetPassword $checkBoxPwdRst.Checked
      } catch {
        [System.Windows.Forms.MessageBox]::Show("Username, FristName, LastName, Building are Required", "Username, FristName, LastName, Building are Required", [System.Windows.Forms.MessageBoxButtons]::OK)
      }
      $Form_Modify.close();
    } )
  $Form_Modify.controls.Add($Button_Apply)

  PopulateFields -UserName $UserName

  [void] $Form_Modify.ShowDialog()
}