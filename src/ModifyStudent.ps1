function ModifyStudent {
  param(
    # [Parameter(ParameterSetName = 'ModifyUser')]
    [String] $UserName,

    # [Parameter(ParameterSetName = 'NewUser')]
    [switch] $NewUser
  )

  Add-Type -AssemblyName System.Windows.Forms
  Import-Module ActiveDirectory

  . "$($PSScriptRoot)\GuiFunctions.ps1"
  . "$($PSScriptRoot)\ADFunctions.ps1"

  $textInfo = (Get-Culture).TextInfo

  $LabelData = @{
    'LastName'       = "Last Name:"
    'FirstName'      = "First Name:"
    'NickName'       = "Nickname:"
    'UserName'       = "Student ID:"
    'Grade'          = "Grade:"
    'Building'       = "Building:"
    'HeaderLeft'     = "Current Student Data"
    'HeaderRight'    = "Modified Student Data"
    'CheckBoxHeader' = "Account Permissions"
  }
  #Importing Data From data files
  [String[]]$Grade = Get-Content -Path "$($PSScriptRoot)\..\data\GradesList.txt"
  [String[]]$Building = Get-Content -Path "$($PSScriptRoot)\..\data\SchoolsList.txt"

  $Form_ModifyStudent = New-Object System.Windows.Forms.Form
  $Form_ModifyStudent.Text = "User Accounts Tool"
  $Form_ModifyStudent.Size = New-Object System.Drawing.Size (610, 450)
  $Form_ModifyStudent.TopMost = $true
  $Form_ModifyStudent.MaximizeBox = $false
  $Form_ModifyStudent.MinimizeBox = $false
  $Form_ModifyStudent.FormBorderStyle = "FixedDialog"
  $Form_ModifyStudent.StartPosition = "CenterScreen"
  $Form_ModifyStudent.Font = New-Object System.Drawing.Font("Verdana", 10)

  #region Left Column
  $X = 10
  $Y = 40
  $XSpacer = 110
  $YSpacer = 25
  $labelSize = New-Object System.Drawing.Size(100, 20)
  $labelFontSize = New-Object System.Drawing.Font ("Veranda", 10.5)
  $textBoxSize = New-Object System.Drawing.Size(147, 20)
  $checkBoxSize = New-Object System.Drawing.Size(240, 20)

  $headerLeft_TextFields = New-Object System.Windows.Forms.Label;
  $headerLeft_TextFields.Location = New-Object System.Drawing.Size(0, 10)
  $headerLeft_TextFields.Size = New-Object System.Drawing.Size(300, 25)
  $headerLeft_TextFields.Font = New-Object System.Drawing.Font("Verdana", 14)
  $headerLeft_TextFields.TextAlign = "MiddleCenter"
  $headerLeft_TextFields.Text = $LabelData.HeaderLeft
  $Form_ModifyStudent.Controls.Add($headerLeft_TextFields)

  $label_CurrentFirstName = New-Object System.Windows.Forms.Label
  $label_CurrentFirstName.Location = New-Object System.Drawing.Size($X, $Y)
  $label_CurrentFirstName.Size = $labelSize
  $label_CurrentFirstName.Font = $labelFontSize
  $label_CurrentFirstName.TextAlign = "MiddleRight"
  $label_CurrentFirstName.Text = $LabelData.FirstName
  $Form_ModifyStudent.Controls.Add($label_CurrentFirstName)

  $Y += $YSpacer
  $label_CurrentLastName = New-Object System.Windows.Forms.Label
  $label_CurrentLastName.Location = New-Object System.Drawing.Size($X, $Y)
  $label_CurrentLastName.Size = $labelSize
  $label_CurrentLastName.Font = $labelFontSize
  $label_CurrentLastName.TextAlign = "MiddleRight"
  $label_CurrentLastName.Text = $LabelData.LastName
  $Form_ModifyStudent.Controls.Add($label_CurrentLastName)

  $Y += $YSpacer
  $label_CurrentUserName = New-Object System.Windows.Forms.Label
  $label_CurrentUserName.Location = New-Object System.Drawing.Size($X, $Y)
  $label_CurrentUserName.Size = $labelSize
  $label_CurrentUserName.Font = $labelFontSize
  $label_CurrentUserName.TextAlign = "MiddleRight"
  $label_CurrentUserName.Text = $LabelData.UserName
  $Form_ModifyStudent.Controls.Add($label_CurrentUserName)

  $Y += $YSpacer
  $label_Grade = New-Object System.Windows.Forms.Label
  $label_Grade.Location = New-Object System.Drawing.Size($X, $Y)
  $label_Grade.Size = $labelSize
  $label_Grade.Font = $labelFontSize
  $label_Grade.TextAlign = "MiddleRight"
  $label_Grade.Text = $LabelData.Grade
  $Form_ModifyStudent.Controls.Add($label_Grade)


  $Y += $YSpacer
  $label_CurrentPrimaryBuilding = New-Object System.Windows.Forms.Label
  $label_CurrentPrimaryBuilding.Location = New-Object System.Drawing.Size($X, $Y)
  $label_CurrentPrimaryBuilding.Size = $labelSize
  $label_CurrentPrimaryBuilding.Font = $labelFontSize
  $label_CurrentPrimaryBuilding.TextAlign = "MiddleRight"
  $label_CurrentPrimaryBuilding.Text = $LabelData.Building
  $Form_ModifyStudent.Controls.Add($label_CurrentPrimaryBuilding)

  #Resetting Data for New Column
  $Y = 40
  $X += $XSpacer

  $textBox_CurrentFirstName = New-Object System.Windows.Forms.TextBox
  $textBox_CurrentFirstName.Location = New-Object System.Drawing.Size($X, $Y)
  $textBox_CurrentFirstName.Size = $textBoxSize
  $textBox_CurrentFirstName.Enabled = $false
  $Form_ModifyStudent.Controls.Add($textBox_CurrentFirstName)

  $Y += $YSpacer
  $textBox_CurrentLastName = New-Object System.Windows.Forms.TextBox
  $textBox_CurrentLastName.Location = New-Object System.Drawing.Size($X, $Y)
  $textBox_CurrentLastName.Size = $textBoxSize
  $textBox_CurrentLastName.Enabled = $false
  $Form_ModifyStudent.Controls.Add($textBox_CurrentLastName)

  $Y += $YSpacer
  $textBox_CurrentUsername = New-Object System.Windows.Forms.TextBox
  $textBox_CurrentUsername.Location = New-Object System.Drawing.Size($X, $Y)
  $textBox_CurrentUsername.Size = $textBoxSize
  $textBox_CurrentUsername.Enabled = $false
  $Form_ModifyStudent.Controls.Add($textBox_CurrentUsername)

  $Y += $YSpacer
  $TextBox_Grade = New-Object System.Windows.Forms.TextBox
  $TextBox_Grade.Location = New-Object System.Drawing.Size($X, $Y)
  $TextBox_Grade.Size = $textBoxSize
  $TextBox_Grade.Enabled = $false
  $Form_ModifyStudent.Controls.Add($TextBox_Grade)

  $Y += $YSpacer
  $textBox_CurrentBuilding = New-Object System.Windows.Forms.TextBox
  $textBox_CurrentBuilding.Location = New-Object System.Drawing.Size($X, $Y)
  $textBox_CurrentBuilding.Size = $textBoxSize
  $textBox_CurrentBuilding.Enabled = $false
  $Form_ModifyStudent.Controls.Add($textBox_CurrentBuilding)

  $checkBoxTitle1 = New-Object System.Windows.Forms.Label;
  $checkBoxTitle1.Size = New-Object System.Drawing.Size(300, 30)
  $checkBoxTitle1.Location = New-Object System.Drawing.Size(0, ($Y + 25))
  $checkBoxTitle1.TextAlign = "MiddleCenter";
  $checkBoxTitle1.Font = New-Object System.Drawing.Font("Verdana", 12);
  $checkBoxTitle1.Text = $LabelData.CheckBoxHeader;
  $Form_ModifyStudent.Controls.Add($checkBoxTitle1)

  $col1 = 40
  $YSpacer = 30

  $Y = 200
  $checkBox_Advanced = New-Object System.Windows.Forms.CheckBox
  $checkBox_Advanced.Location = New-Object System.Drawing.Size($col1, $Y)
  $checkBox_Advanced.Text = "Advanced Account"
  $checkBox_Advanced.Size = $checkBoxSize
  $checkBox_Advanced.Enabled = $false
  $Form_ModifyStudent.Controls.Add($checkBox_Advanced)

  $Y += $YSpacer
  $checkBox_Skype = New-Object System.Windows.Forms.CheckBox
  $checkBox_Skype.Location = New-Object System.Drawing.Size($col1, $Y)
  $checkBox_Skype.Text = "Skype"
  $checkBox_Skype.Size = $checkBoxSize
  $checkBox_Skype.Enabled = $false
  $Form_ModifyStudent.Controls.Add($checkBox_Skype)

  $Y += $YSpacer
  $checkBox_Email = New-Object System.Windows.Forms.CheckBox
  $checkBox_Email.Location = New-Object System.Drawing.Size($col1, $Y)
  $checkBox_Email.Text = "E-Mail"
  $checkBox_Email.Size = $checkBoxSize
  $checkBox_Email.Enabled = $false
  $Form_ModifyStudent.Controls.Add($checkBox_Email)

  $Y += $YSpacer
  $checkBox_Violation = New-Object System.Windows.Forms.CheckBox
  $checkBox_Violation.Location = New-Object System.Drawing.Size($col1, $Y)
  $checkBox_Violation.Text = "Violation"
  $checkBox_Violation.Size = $checkBoxSize
  $checkBox_Violation.Enabled = $false
  $Form_ModifyStudent.Controls.Add($checkBox_Violation)
  #endregion

  #region Right Column
  $X = 310
  $Y = 40
  $XSpacer = 110
  $YSpacer = 25
  $labelSize = New-Object System.Drawing.Size(100, 20)
  $labelFontSize = New-Object System.Drawing.Font ("Veranda", 10.5)
  $textBoxSize = New-Object System.Drawing.Size(147, 20)
  $checkBoxSize = New-Object System.Drawing.Size(240, 20)

  $headerRight_TextFields = New-Object System.Windows.Forms.Label;
  $headerRight_TextFields.Location = New-Object System.Drawing.Size(($X - 10), 10)
  $headerRight_TextFields.Size = New-Object System.Drawing.Size(300, 25)
  $headerRight_TextFields.Font = New-Object System.Drawing.Font("Verdana", 14)
  $headerRight_TextFields.TextAlign = "MiddleCenter"
  $headerRight_TextFields.Text = $LabelData.HeaderRight
  $Form_ModifyStudent.Controls.Add($headerRight_TextFields)

  $label_CurrentFirstName = New-Object System.Windows.Forms.Label
  $label_CurrentFirstName.Location = New-Object System.Drawing.Size($X, $Y)
  $label_CurrentFirstName.Size = $labelSize
  $label_CurrentFirstName.Font = $labelFontSize
  $label_CurrentFirstName.TextAlign = "MiddleRight"
  $label_CurrentFirstName.Text = $LabelData.FirstName
  $Form_ModifyStudent.Controls.Add($label_CurrentFirstName)

  $Y += $YSpacer
  $label_CurrentLastName = New-Object System.Windows.Forms.Label
  $label_CurrentLastName.Location = New-Object System.Drawing.Size($X, $Y)
  $label_CurrentLastName.Size = $labelSize
  $label_CurrentLastName.Font = $labelFontSize
  $label_CurrentLastName.TextAlign = "MiddleRight"
  $label_CurrentLastName.Text = $LabelData.LastName
  $Form_ModifyStudent.Controls.Add($label_CurrentLastName)

  $Y += $YSpacer
  $label_CurrentUserName = New-Object System.Windows.Forms.Label
  $label_CurrentUserName.Location = New-Object System.Drawing.Size($X, $Y)
  $label_CurrentUserName.Size = $labelSize
  $label_CurrentUserName.Font = $labelFontSize
  $label_CurrentUserName.TextAlign = "MiddleRight"
  $label_CurrentUserName.Text = $LabelData.UserName
  $Form_ModifyStudent.Controls.Add($label_CurrentUserName)

  $Y += $YSpacer
  $label_Grade = New-Object System.Windows.Forms.Label
  $label_Grade.Location = New-Object System.Drawing.Size($X, $Y)
  $label_Grade.Size = $labelSize
  $label_Grade.Font = $labelFontSize
  $label_Grade.TextAlign = "MiddleRight"
  $label_Grade.Text = $LabelData.Grade
  $Form_ModifyStudent.Controls.Add($label_Grade)


  $Y += $YSpacer
  $label_CurrentPrimaryBuilding = New-Object System.Windows.Forms.Label
  $label_CurrentPrimaryBuilding.Location = New-Object System.Drawing.Size($X, $Y)
  $label_CurrentPrimaryBuilding.Size = $labelSize
  $label_CurrentPrimaryBuilding.Font = $labelFontSize
  $label_CurrentPrimaryBuilding.TextAlign = "MiddleRight"
  $label_CurrentPrimaryBuilding.Text = $LabelData.Building
  $Form_ModifyStudent.Controls.Add($label_CurrentPrimaryBuilding)

  #Resetting Data for New Column
  $Y = 40
  $X += $XSpacer

  $textBox_ModifiedFirstName = New-Object System.Windows.Forms.TextBox
  $textBox_ModifiedFirstName.Location = New-Object System.Drawing.Size($X, $Y)
  $textBox_ModifiedFirstName.Size = $textBoxSize
  $textBox_ModifiedFirstName.TabIndex = 0
  $textBox_ModifiedFirstName.Enabled = $True
  $textBox_ModifiedFirstName.add_TextChanged( {
      $textBox_ModifiedFirstName.Text = $textInfo.ToTitleCase($textBox_ModifiedFirstName.Text) 
      $textBox_ModifiedFirstName.SelectionStart = $textBox_ModifiedFirstName.Text.Length
      $textBox_ModifiedFirstName.SelectionLength = 0   
    })
  $Form_ModifyStudent.Controls.Add($textBox_ModifiedFirstName)

  $Y += $YSpacer
  $textBox_ModifiedLastName = New-Object System.Windows.Forms.TextBox
  $textBox_ModifiedLastName.Location = New-Object System.Drawing.Size($X, $Y)
  $textBox_ModifiedLastName.Size = $textBoxSize
  $textBox_ModifiedLastName.TabIndex = 1
  $textBox_ModifiedLastName.Enabled = $True
  $textBox_ModifiedLastName.add_TextChanged( {
      $textBox_ModifiedLastName.Text = $textInfo.ToTitleCase($textBox_ModifiedLastName.Text) 
      $textBox_ModifiedLastName.SelectionStart = $textBox_ModifiedLastName.Text.Length
      $textBox_ModifiedLastName.SelectionLength = 0   
    })
  $Form_ModifyStudent.Controls.Add($textBox_ModifiedLastName)

  $Y += $YSpacer
  $textBox_ModifiedUsername = New-Object System.Windows.Forms.TextBox
  $textBox_ModifiedUsername.Location = New-Object System.Drawing.Size($X, $Y)
  $textBox_ModifiedUsername.Size = $textBoxSize
  $textBox_ModifiedUsername.Enabled = $false
  $Form_ModifyStudent.Controls.Add($textBox_ModifiedUsername)

  $Y += $YSpacer
  $DropDown_Grade = New-Object System.Windows.Forms.ComboBox
  $DropDown_Grade.DropDownStyle = 'DropDownList'
  $DropDown_Grade.Location = New-Object System.Drawing.Size($X, $Y)
  $DropDown_Grade.Size = $textBoxSize
  $DropDown_Grade.TabIndex = 2
  $DropDown_Grade.Enabled = $True
  foreach ($item in $Grade) {
    [void]$DropDown_Grade.Items.add($item)
  }
  $Form_ModifyStudent.Controls.Add($DropDown_Grade)
  $DDGrade_SelectedIndexChanged = {
    
    if ($DropDown_Grade.Text -eq 'Grade 1' -or `
        $DropDown_Grade.Text -eq 'Grade 2' -or `
        $DropDown_Grade.Text -eq 'Grade 3' -or `
        $DropDown_Grade.Text -eq 'Grade 4') {

      $checkBoxSet_Advanced.Checked = $false
      $checkBoxSet_Advanced.Enabled = $false
      $checkBoxSet_Skype.Checked = $false
      $checkBoxSet_Skype.Enabled = $false
      $checkBoxSet_Email.Checked = $false
      $checkBoxSet_Email.Enabled = $false
    } else {
      $checkBoxSet_Advanced.Checked = $checkBox_Advanced.Checked
      $checkBoxSet_Advanced.Enabled = $true
      $checkBoxSet_Skype.Checked = $checkBox_Skype.Checked
      $checkBoxSet_Skype.Enabled = $true
      $checkBoxSet_Email.Checked = $checkBox_Email.Checked
      $checkBoxSet_Email.Enabled = $true
    }
  }
  $DropDown_Grade.add_SelectedIndexChanged($DDGrade_SelectedIndexChanged)

  $Y += $YSpacer
  $DropDown_Building = New-Object System.Windows.Forms.ComboBox
  $DropDown_Building.DropDownStyle = 'DropDownList'
  $DropDown_Building.Location = New-Object System.Drawing.Size($X, $Y)
  $DropDown_Building.Size = $textBoxSize
  $DropDown_Building.TabIndex = 3
  $DropDown_Building.Enabled = $True
  foreach ($item in $Building) {
    [void]$DropDown_Building.Items.add($item)
  }
  $Form_ModifyStudent.Controls.Add($DropDown_Building)

  $checkBoxTitle2 = New-Object System.Windows.Forms.Label;
  $checkBoxTitle2.Size = New-Object System.Drawing.Size(300, 30)
  $checkBoxTitle2.Location = New-Object System.Drawing.Size(300, ($Y + 25))
  $checkBoxTitle2.TextAlign = "MiddleCenter";
  $checkBoxTitle2.Font = New-Object System.Drawing.Font("Verdana", 12);
  $checkBoxTitle2.Text = $LabelData.CheckBoxHeader;
  $Form_ModifyStudent.Controls.Add($checkBoxTitle2)


  $col1 = 340
  $YSpacer = 30

  $Y = 200
  $checkBoxSet_Advanced = New-Object System.Windows.Forms.CheckBox
  $checkBoxSet_Advanced.Location = New-Object System.Drawing.Size($col1, $Y)
  $checkBoxSet_Advanced.Text = "Advanced Account"
  $checkBoxSet_Advanced.Size = $checkBoxSize
  $checkBoxSet_Advanced.Enabled = $True
  $Form_ModifyStudent.Controls.Add($checkBoxSet_Advanced)

  $Y += $YSpacer
  $checkBoxSet_Skype = New-Object System.Windows.Forms.CheckBox
  $checkBoxSet_Skype.Location = New-Object System.Drawing.Size($col1, $Y)
  $checkBoxSet_Skype.Text = "Skype"
  $checkBoxSet_Skype.Size = $checkBoxSize
  $checkBoxSet_Skype.Enabled = $True
  $Form_ModifyStudent.Controls.Add($checkBoxSet_Skype)

  $Y += $YSpacer
  $checkBoxSet_Email = New-Object System.Windows.Forms.CheckBox
  $checkBoxSet_Email.Location = New-Object System.Drawing.Size($col1, $Y)
  $checkBoxSet_Email.Text = "E-Mail"
  $checkBoxSet_Email.Size = $checkBoxSize
  $checkBoxSet_Email.Enabled = $True
  $Form_ModifyStudent.Controls.Add($checkBoxSet_Email)

  $Y += $YSpacer
  $checkBoxSet_Violation = New-Object System.Windows.Forms.CheckBox
  $checkBoxSet_Violation.Location = New-Object System.Drawing.Size($col1, $Y)
  $checkBoxSet_Violation.Text = "Violation"
  $checkBoxSet_Violation.Size = $checkBoxSize
  $checkBoxSet_Violation.Enabled = $True
  $Form_ModifyStudent.Controls.Add($checkBoxSet_Violation)


  #endregion

  $Checkbox_PwdReset = New-Object System.Windows.Forms.CheckBox
  $Checkbox_PwdReset.Size = $checkBoxSize
  $Checkbox_PwdReset.Text = 'Reset Password'
  $Checkbox_PwdReset.Location = New-Object System.Drawing.Size(220, ($Y + ($YSpacer * 2)))
  $Form_ModifyStudent.Controls.Add($Checkbox_PwdReset)

  $Button_Apply = New-Object System.Windows.Forms.Button
  $Button_Apply.Size = New-Object System.Drawing.Size(150, 20)
  $Button_Apply.TabIndex = 4
  $Button_Apply.Location = New-Object System.Drawing.Size(220, ($Y + ($YSpacer * 3)))
  $Button_Apply.Text = "Apply Changes"
  $Button_Apply.ADD_Click( {
      Set-Student -UserName $textBox_ModifiedUsername.Text -FirstName $textBox_ModifiedFirstName.Text `
        -LastName $textBox_ModifiedLastName.Text -Grade $DropDown_Grade.Text -Building $DropDown_Building.Text `
        -Advanced $checkBoxSet_Advanced.Checked -Skype $checkBoxSet_Skype.Checked -Email $checkBoxSet_Email.Checked `
        -ResetPassword $Checkbox_PwdReset.Checked -Violation $checkBoxSet_Violation.Checked
      
      $Form_ModifyStudent.close();
    } )
  $Form_ModifyStudent.controls.Add($Button_Apply)

  if ($NewUser.IsPresent) {
    PopulateNewStudent
  } else {
    PopulateStudentFields -Username $UserName
  }
  [void] $Form_ModifyStudent.ShowDialog()
}