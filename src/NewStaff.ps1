function CreateInfo {
  Add-Type -AssemblyName System.Windows.Forms
  . "$($PSScriptRoot)\Classes.ps1"

  # ---=== Define Title & Label Names ===---
  $LabelData = @{
    'Title'          = 'Update Staff Account'
    'Header'         = "Enter Staff Information"
    'FirstName'      = ":First Name"
    'LastName'       = ':Last Name'
    'NickName'       = ':NickName'
    'UserName'       = ":Username"
    'Position'       = ":Position"
    'Department'     = ":Department"
    'Building'       = ":Primary Building"
    'CheckBoxHeader' = "All Building Locations Worked"
  }

  $Global:useNickname = $true
  #Spacing GUI Elements X
  $ll = 0
  $ltb = 150
  $ldd = 150
  $wl = 140
  $wtb = 170
  $wdd = 170
  $lcbA = 50
  $lcbB = 160

  #Spacing GUI Elements Y
  $row1 = 50
  $row2 = 80
  $row3 = 110
  $row4 = 140
  $row5 = 170
  $row6 = 200
  $row7 = 230
  $row8 = 290
  $row9 = 320
  $row10 = 350
  $row11 = 380
  $row12 = 410
  $row13 = 440

  $ImpData = Get-Content -Path "$($PSScriptRoot)\..\data\Data.json" | ConvertFrom-Json

  # ---=== Define Position Dropdown Options ===---
  [String[]]$DD1 = $ImpData.Positions

  # ---=== Define Department Dropdown Options ===---
  [String[]]$DD2 = $ImpData.Departments

  # ---=== Define Primary Building Dropdown Options ===---
  [String[]]$DD3 = $ImpData.Buildings

  $labelFont = New-Object System.Drawing.Font("Verdana", 10.5)
  $checkBoxFont = New-Object System.Drawing.Font("Verdana", 9)

  # ---=== Define Form Size & Placement ===---
  $form = New-Object System.Windows.Forms.Form
  $form.Width = 350;
  $form.Height = 600;
  $form.Text = $title;
  $Form.FormBorderStyle = "FixedDialog"
  $form.MinimizeBox = $false;
  $form.MaximizeBox = $false;
  $form.TopMost = $true;
  $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen;
  $form.MinimumSize = New-Object System.Drawing.size(350, 600)

  # ---=== Define header1 ===---
  $header_TextFields = New-Object System.Windows.Forms.Label;
  $header_TextFields.Left = 0;
  $header_TextFields.Top = 10;
  $header_TextFields.width = 350;
  $header_TextFields.Font = New-Object System.Drawing.Font("Verdana", 14);
  $header_TextFields.TextAlign = "MiddleCenter";
  $header_TextFields.Text = $LabelData.Header

  # ---=== Define textBox1 ===---
  $Label_FirstName = New-Object System.Windows.Forms.Label;
  $Label_FirstName.Left = $ll;
  $Label_FirstName.Top = $row1;
  $Label_FirstName.width = $wl;
  $Label_FirstName.Font = $labelFont;
  $Label_FirstName.RightToLeft = "Yes";
  $Label_FirstName.Text = $LabelData.FirstName;

  $TextBox_FirstName = New-Object System.Windows.Forms.TextBox;
  $TextBox_FirstName.Left = $ltb;
  $TextBox_FirstName.TabIndex = 0;
  $TextBox_FirstName.Top = $row1;
  $TextBox_FirstName.width = $wtb;
  $TextBox_FirstName.add_TextChanged( {
      $TextBox_FirstName.Text = CapitalizeName -Name $TextBox_FirstName.Text
      $TextBox_FirstName.SelectionStart = $TextBox_FirstName.Text.Length
      $TextBox_FirstName.SelectionLength = 0
    })

  # ---=== Define textBox2 ===---
  $Label_LastName = New-Object System.Windows.Forms.Label;
  $Label_LastName.Left = $ll;
  $Label_LastName.Top = $row2;
  $Label_LastName.width = $wl;
  $Label_LastName.Font = $labelFont;
  $Label_LastName.RightToLeft = "Yes";
  $Label_LastName.Text = $LabelData.LastName;

  $TextBox_LastName = New-Object System.Windows.Forms.TextBox;
  $TextBox_LastName.Left = $ltb;
  $TextBox_LastName.TabIndex = 1;
  $TextBox_LastName.Top = $row2;
  $TextBox_LastName.width = $wtb;
  $TextBox_LastName.add_TextChanged( {
      $TextBox_LastName.Text = CapitalizeName -Name $TextBox_LastName.Text
      $TextBox_LastName.SelectionStart = $TextBox_LastName.Text.Length
      $TextBox_LastName.SelectionLength = 0

    })

  # --=== Define textBox3 ===--
  $Label_NickName = New-Object System.Windows.Forms.Label;
  $Label_NickName.Left = $ll;
  $Label_NickName.Top = $row3;
  $Label_NickName.Width = $wl;
  $Label_NickName.Font = $labelFont;
  $Label_NickName.RightToLeft = "Yes";
  $Label_NickName.Text = $LabelData.NickName;

  $TextBox_NickName = New-Object System.Windows.Forms.TextBox;
  $TextBox_NickName.Left = $ltb;
  $TextBox_NickName.TabIndex = 2;
  $TextBox_NickName.Top = $row3;
  $TextBox_NickName.Width = $wtb;
  $TextBox_NickName.add_TextChanged( {
      $TextBox_NickName.Text = CapitalizeName -Name $TextBox_NickName.Text
      $TextBox_NickName.SelectionStart = $TextBox_NickName.Text.Length
      $TextBox_NickName.SelectionLength = 0
    })

  # ---=== Define textBox4 ===---
  $Label_UserName = New-Object System.Windows.Forms.Label;
  $Label_UserName.Left = $ll;
  $Label_UserName.Top = $row4;
  $Label_UserName.width = $wl;
  $Label_UserName.Font = $labelFont;
  $Label_UserName.RightToLeft = "Yes";
  $Label_UserName.Text = $LabelData.UserName;

  $Button_generateUsername = New-Object System.Windows.Forms.Button
  $Button_generateUsername.Top = $row4;
  $Button_generateUsername.TabIndex = 3;
  $Button_generateUsername.Left = ($ltb - 9);
  $Button_generateUsername.size = New-Object System.Drawing.Size (8, 20)
  $Button_generateUsername.Add_Click( {
      if ($useNickname) {
        $TextBox_UserName.Text = "$($TextBox_NickName.Text).$($TextBox_LastName.Text)".ToLower()
        $Global:useNickname = $false
      } else {
        $TextBox_UserName.Text = "$($TextBox_FirstName.Text).$($TextBox_LastName.Text)".ToLower()
        $Global:useNickname = $true
      }
    });

  $TextBox_UserName = New-Object System.Windows.Forms.TextBox;
  $TextBox_UserName.Left = $ltb;
  $TextBox_UserName.Top = $row4;
  $TextBox_UserName.width = $wtb;

  # ---=== Define DropDown1 ===---
  $Label_DD1_Position = New-Object System.Windows.Forms.Label;
  $Label_DD1_Position.Left = $ll;
  $Label_DD1_Position.Top = $row5;
  $Label_DD1_Position.Font = $labelFont;
  $Label_DD1_Position.width = $wl;
  $Label_DD1_Position.RightToLeft = "Yes";
  $Label_DD1_Position.Text = $LabelData.Position;

  $DropDown1_Position = new-object System.Windows.Forms.ComboBox;
  $DropDown1_Position.Left = $ldd;
  $DropDown1_Position.Top = $row5;
  $DropDown1_Position.TabIndex = 4;
  $DropDown1_Position.Font = $checkBoxFont;
  $DropDown1_Position.width = $wdd;
  $DropDown1_Position.DropDownStyle = 'DropDownList'
  ForEach ($Item in $DD1) {
    [void] $DropDown1_Position.Items.Add($Item)
  }
  $DD1_SelectedIndexChanged = {
    if ($DropDown1_Position.Text -eq 'Other-District [Edit]') {
      $DropDown1_Position.DropDownStyle = 'DropDown'
    } else {
      $DropDown1_Position.DropDownStyle = 'DropDownList'
    }
  }
  $DropDown1_Position.add_SelectedIndexChanged($DD1_SelectedIndexChanged)
  # ---=== Define DropDown2 ===---
  $Label_DD2_Department = New-Object System.Windows.Forms.Label;
  $Label_DD2_Department.Left = $ll;
  $Label_DD2_Department.Top = $row6;
  $Label_DD2_Department.Font = $labelFont;
  $Label_DD2_Department.width = $wl;
  $Label_DD2_Department.RightToLeft = "Yes";
  $Label_DD2_Department.Text = $LabelData.Department;

  $DropDown2_Department = new-object System.Windows.Forms.ComboBox;
  $DropDown2_Department.Left = $ldd;
  $DropDown2_Department.Top = $row6;
  $DropDown2_Department.TabIndex = 6;
  $DropDown2_Department.Font = $checkBoxFont;
  $DropDown2_Department.width = $wdd;
  $DropDown2_Department.DropDownStyle = 'DropDownList'

  ForEach ($Item in $DD2) {
    [void] $DropDown2_Department.Items.Add($Item)
  }

  # ---=== Define DropDown3 ===---
  $Label_DD3_Building = New-Object System.Windows.Forms.Label;
  $Label_DD3_Building.Left = $ll;
  $Label_DD3_Building.Top = $row7;
  $Label_DD3_Building.Font = $labelFont;
  $Label_DD3_Building.width = $wl;
  $Label_DD3_Building.RightToLeft = "Yes";
  $Label_DD3_Building.Text = $LabelData.Building;

  $DropDown3_Building = New-Object System.Windows.Forms.ComboBox;
  $DropDown3_Building.Left = $ldd;
  $DropDown3_Building.Top = $row7;
  $DropDown3_Building.TabIndex = 7;
  $DropDown3_Building.Font = $checkBoxFont;
  $DropDown3_Building.width = $wdd;
  $DropDown3_Building.DropDownStyle = 'DropDownList'

  ForEach ($Item in $DD3) {
    [void] $DropDown3_Building.Items.Add($Item)
  }

  # ---=== Define checkbox title1 ===---
  $checkBoxTitle = New-Object System.Windows.Forms.Label;
  $checkBoxTitle.Left = 0;
  $checkBoxTitle.Top = 260;
  $checkBoxTitle.Width = 300;
  $checkBoxTitle.TextAlign = "MiddleCenter";
  $checkBoxTitle.Font = New-Object System.Drawing.Font("Verdana", 12);
  $checkBoxTitle.Text = $LabelData.CheckBoxHeader;

  # ---=== Define checkBox1 ===---
  $checkBox_AHS = New-Object System.Windows.Forms.CheckBox
  $checkBox_AHS.Left = $lcbA;
  $checkBox_AHS.Top = $row8;
  $checkBox_AHS.Text = "AHS"
  $checkBox_AHS.Font = $checkBoxFont;

  # ---=== Define checkBox2 ===---
  $checkBox_ELL = New-Object System.Windows.Forms.CheckBox
  $checkBox_ELL.Left = $lcbB;
  $checkBox_ELL.Top = $row8;
  $checkBox_ELL.Text = "Ellis"
  $checkBox_ELL.Font = $checkBoxFont;

  # ---=== Define checkBox3 ===---
  $checkBox_IJH = New-Object System.Windows.Forms.CheckBox
  $checkBox_IJH.Left = $lcbA;
  $checkBox_IJH.Top = $row9;
  $checkBox_IJH.Text = "IJH"
  $checkBox_IJH.Font = $checkBoxFont;

  # ---=== Define checkBox4 ===---
  $checkBox_BAN = New-Object System.Windows.Forms.CheckBox
  $checkBox_BAN.Left = $lcbB;
  $checkBox_BAN.Top = $row9;
  $checkBox_BAN.Text = "Banfield"
  $checkBox_BAN.Font = $checkBoxFont;

  # ---=== Define checkBox5 ===---
  $checkBox_NEV = New-Object System.Windows.Forms.CheckBox
  $checkBox_NEV.Left = $lcbA;
  $checkBox_NEV.Top = $row10;
  $checkBox_NEV.Text = "Neveln"
  $checkBox_NEV.Font = $checkBoxFont;

  # ---=== Define checkBox6 ===---
  $checkBox_SOU = New-Object System.Windows.Forms.CheckBox
  $checkBox_SOU.Left = $lcbB;
  $checkBox_SOU.Top = $row10;
  $checkBox_SOU.Text = "Southgate"
  $checkBox_SOU.Font = $checkBoxFont;

  # ---=== Define checkBox7 ===---
  $checkBox_SUM = New-Object System.Windows.Forms.CheckBox
  $checkBox_SUM.Left = $lcbA;
  $checkBox_SUM.Top = $row11;
  $checkBox_SUM.Text = "Sumner"
  $checkBox_SUM.Font = $checkBoxFont;

  # ---=== Define checkBox8 ===---
  $checkBox_WOO = New-Object System.Windows.Forms.CheckBox
  $checkBox_WOO.Left = $lcbB;
  $checkBox_WOO.Top = $row11;
  $checkBox_WOO.Text = "Woodson"
  $checkBox_WOO.Font = $checkBoxFont;

  # ---=== Define checkBox9 ===---
  $checkBox_CLC = New-Object System.Windows.Forms.CheckBox
  $checkBox_CLC.Left = $lcbA;
  $checkBox_CLC.Top = $row12;
  $checkBox_CLC.Text = "CLC"
  $checkBox_CLC.Font = $checkBoxFont;

  # ---=== Define checkBox10 ===---
  $checkBox_OEC = New-Object System.Windows.Forms.CheckBox
  $checkBox_OEC.Left = $lcbB;
  $checkBox_OEC.Top = $row12;
  $checkBox_OEC.Text = "Oakland EC"
  $checkBox_OEC.Font = $checkBoxFont;

  # ---=== Define checkBox11 ===---
  $checkBox_PAE = New-Object System.Windows.Forms.CheckBox
  $checkBox_PAE.Left = $lcbA;
  $checkBox_PAE.Top = $row13;
  $checkBox_PAE.Text = "PAES Lab"
  $checkBox_PAE.Font = $checkBoxFont;

  # ---=== Define checkBox12 ===---
  $checkBox_RIV = New-Object System.Windows.Forms.CheckBox
  $checkBox_RIV.Left = $lcbB;
  $checkBox_RIV.Top = $row13;
  $checkBox_RIV.Width = 150;
  $checkBox_RIV.Text = "Riverland ABE"
  $checkBox_RIV.Font = $checkBoxFont;

  # ---=== Define OK button ===---
  $okbutton = New-Object System.Windows.Forms.Button;
  $okbutton.Left = 110;
  $okbutton.Top = 525;
  $okbutton.Width = 100;
  $okbutton.Text = 'Ok';

  $okbutton.Enabled = $false;
  # New User data object
  $obj = [APSAccountData]::new();

  $okbutton.Add_Click( {
      if ($TextBox_UserName.Text.Length -gt 1) {
        $obj.SamAccountName = $TextBox_UserName.Text;
      } if ($TextBox_FirstName.Text.Length -gt 1) {
        $obj.GivenName = $TextBox_FirstName.Text;
      } if ($TextBox_LastName.Text.Length -gt 1) {
        $obj.Surname = $TextBox_LastName.Text;
      } if ($TextBox_NickName.Text.Length -gt 1) {
        $obj.NickName = $TextBox_NickName.Text;
      } if ($DropDown1_Position.Text.Length -gt 1) {
        $obj.Position = $DropDown1_Position.Text;
      } if ($DropDown2_Department.SelectedItem.Length -gt 1) {
        $obj.Department = $DropDown2_Department.SelectedItem;
      } if ($DropDown3_Building.SelectedItem.Length -gt 1) {
        $obj.Building = $DropDown3_Building.SelectedItem;
      }
      $obj.AHS = $checkBox_AHS.Checked
      $obj.Ell = $checkBox_ELL.Checked
      $obj.IJH = $checkBox_IJH.Checked
      $obj.BAN = $checkBox_BAN.Checked
      $obj.NEV = $checkBox_NEV.Checked
      $obj.SOU = $checkBox_SOU.Checked
      $obj.SUM = $checkBox_SUM.Checked
      $obj.WOO = $checkBox_WOO.Checked
      $obj.CLC = $checkBox_CLC.Checked
      $obj.OAK = $checkBox_OEC.Checked
      $obj.PAE = $checkBox_PAE.Checked
      $obj.RIV = $checkBox_RIV.Checked
      [void]$form.Close();
    }) ;

  # ---=== Add controls to all the above objects defined ===---
  $form.Controls.Add($okbutton);
  $form.Controls.Add($header_TextFields);
  $form.Controls.Add($Label_FirstName);
  $form.Controls.Add($Label_LastName);
  $form.Controls.Add($Label_NickName);
  $form.Controls.Add($Label_UserName);
  $form.Controls.Add($Button_generateUsername);
  $form.Controls.Add($Label_DD1_Position);
  $form.Controls.Add($Label_DD2_Department);
  $form.Controls.Add($Label_DD3_Building);
  $form.Controls.Add($TextBox_FirstName);
  $form.Controls.Add($TextBox_LastName);
  $form.Controls.Add($TextBox_NickName);
  $form.Controls.Add($TextBox_UserName);
  $form.Controls.Add($DropDown1_Position);
  $form.Controls.Add($DropDown2_Department);
  $form.Controls.Add($DropDown3_Building);
  $form.Controls.Add($checkBoxTitle);
  $form.Controls.Add($checkBox_AHS);
  $form.Controls.Add($checkBox_ELL);
  $form.Controls.Add($checkBox_IJH);
  $form.Controls.Add($checkBox_BAN);
  $form.Controls.Add($checkBox_NEV);
  $form.Controls.Add($checkBox_SOU);
  $form.Controls.Add($checkBox_SUM);
  $form.Controls.Add($checkBox_WOO);
  $form.Controls.Add($checkBox_CLC);
  $form.Controls.Add($checkBox_OEC);
  $form.Controls.Add($checkBox_PAE);
  $form.Controls.Add($checkBox_RIV);
  $form.add_Shown( {
      $TextBox_FirstName.Focus();
    })
  $form.Controls.Add($checkBox_RIV);
  [void]$form.ShowDialog();
  Write-Output $obj
}
