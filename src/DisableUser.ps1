Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

. "$($PSScriptRoot)\GuiFunctions.ps1"
. "$($PSScriptRoot)\Classes.ps1"
. "$($PSScriptRoot)\ADFunctions.ps1"
function DisableUserWindow {
  param(
    [String] $UserName
  )
  $Form_Disable = New-Object System.Windows.Forms.Form
  $Form_Disable.Size = New-Object System.Drawing.Size(253, 235)
  $Form_Disable.TopMost = $true
  $Form_Disable.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen;
  $Form_Disable.FormBorderStyle = "FixedDialog"
  $Form_Disable.Text = 'Disable User'
  $Form_Disable.MinimizeBox = $false
  $Form_Disable.MaximizeBox = $false

  $Button_DisableNow = New-Object System.Windows.Forms.Button
  $Button_DisableNow.Size = New-Object System.Drawing.Size(100, 20)
  $Button_DisableNow.Location = New-Object System.Drawing.Size(5, 170)
  $Button_DisableNow.Font = New-Object System.Drawing.Font("Verdana", 9)
  $Button_DisableNow.Text = 'Disable Now'
  $Button_DisableNow.Add_Click( {
      $date = Get-Date
      Disable-User -Date $date -Username $UserName
      Disable-UserNow -SamAccountName $UserName
      [void]$Form_Disable.Close()
    })
  $Form_Disable.Controls.Add($Button_DisableNow)

  $Button_SetDisableDate = New-Object System.Windows.Forms.Button
  $Button_SetDisableDate.Size = New-Object System.Drawing.Size(80, 20)
  $Button_SetDisableDate.Location = New-Object System.Drawing.Size(115, 170)
  $Button_SetDisableDate.Font = New-Object System.Drawing.Font("Verdana", 9)
  $Button_SetDisableDate.Text = 'Set Date'
  $Button_SetDisableDate.Add_Click( {
      $date = $calendar.SelectionStart
      Disable-User -Date $date -Username $UserName
      [void]$Form_Disable.Close()
    })
  $Form_Disable.Controls.Add($Button_SetDisableDate)

  $calendar = New-Object System.Windows.Forms.MonthCalendar
  $calendar.ShowTodayCircle = $false
  $calendar.MaxSelectionCount = 1
  $calendar.Location = New-Object System.Drawing.Size(10, 5)
  $Form_Disable.Controls.Add($calendar)

  [void] $Form_Disable.ShowDialog()
}