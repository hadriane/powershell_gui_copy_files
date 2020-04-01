function GenerateForm {	
	# Hide cmd console window
	$t = '[DllImport("user32.dll")] public static extern bool ShowWindow(int handle, int state);'
	add-type -name win -member $t -namespace native
	[native.win]::ShowWindow(([System.Diagnostics.Process]::GetCurrentProcess() | Get-Process).MainWindowHandle, 0)

	[reflection.assembly]::LoadWithPartialName("System.Windows.Forms") |Out-Null
	
	# Initialize array
	[array]$dropDownArray = ".txt", ".xls", ".xlsx", ".doc", ".docx", ".pdf", ".png", ".jpg", ".jpeg"

	
	# Initializing a form
	$basicForm = New-Object System.Windows.Forms.Form
	$basicForm.Size = '450,300'
	$basicForm.StartPosition = 'CenterScreen'
	$basicForm.Text = 'Copy files from source to destination'


	# Defining source folder text box
	$textBoxsourceFolder = New-Object System.Windows.Forms.TextBox
	$textBoxsourceFolder.Text = 'Select the source folder'
	$textBoxsourceFolder.Location = '23,23'
	$textBoxsourceFolder.Size = '300,23'
	
	# Defining source folder select button 
	$buttonSelectsourceFolder = New-Object System.Windows.Forms.Button
	$buttonSelectsourceFolder.Text = 'Select'
	$buttonSelectsourceFolder.Location = '350,23'
	
	# Assigning source folder select button
	$browsesourceFolder = New-Object System.Windows.Forms.FolderBrowserDialog
	$buttonSelectsourceFolder.Add_Click({
		$browsesourceFolder.ShowDialog()
		$textBoxsourceFolder.Text = $browsesourceFolder.SelectedPath
	})
	$textBoxsourceFolder.ReadOnly = $true


	# Defining drop down box
	$boxDropDown = New-Object System.Windows.Forms.ComboBox
	$boxDropDown.Location = '23,69'
	$boxDropDown.Size = '130,30'
	
	# Assigning items to drop down box
	ForEach ($Item in $dropDownArray) {
		$boxDropDown.Items.Add($Item)
	}
	
	
	# Defining destination folder text box
	$textBoxDestinationFolder = New-Object System.Windows.Forms.TextBox
	$textBoxDestinationFolder.Text = 'Select the destination folder'
	$textBoxDestinationFolder.Location = '23,115'
	$textBoxDestinationFolder.Size = '300,23'
	
	
	# Defining destination folder select button 
	$buttonSelectDestinationFolder = New-Object System.Windows.Forms.Button
	$buttonSelectDestinationFolder.Text = 'Select'
	$buttonSelectDestinationFolder.Location = '350,115'
	
	# Assigning destination folder select button
	$browseDestinationFolder = New-Object System.Windows.Forms.FolderBrowserDialog
	$buttonSelectDestinationFolder.Add_Click({
		$browseDestinationFolder.ShowDialog()
		$textBoxDestinationFolder.Text = $browseDestinationFolder.SelectedPath
	})
	$textBoxDestinationFolder.ReadOnly = $true
	
	
	# Defining copy button
	$copyButton = New-Object System.Windows.Forms.Button
	$copyButton.Location = '23,161'
	$copyButton.text = 'Copy'
	
	# Assigning an action to copy button
	$copyButton.Add_Click({
		If($browsesourceFolder.SelectedPath -And $browseDestinationFolder.SelectedPath){
			If(Test-Path $browsesourceFolder.SelectedPath, $browseDestinationFolder.SelectedPath){
				Get-ChildItem -Path $browsesourceFolder.SelectedPath -Include "*$($boxDropDown.SelectedItem)" -Recurse | Copy-Item -Destination $browseDestinationFolder.SelectedPath
			}
		}
	})

	
	# Adding items to the form
	$basicForm.Controls.Add($textBoxsourceFolder)
	$basicForm.Controls.Add($buttonSelectsourceFolder)
	$basicForm.Controls.Add($textBoxDestinationFolder)
	$basicForm.Controls.Add($buttonSelectDestinationFolder)
	$basicForm.Controls.Add($boxDropDown)
	$basicForm.Controls.Add($copyButton)
	
	
	$basicForm.ShowDialog()
	
}

GenerateForm
