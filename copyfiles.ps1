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
	$basicForm.Size = '450,315'
	$basicForm.StartPosition = 'CenterScreen'
	$basicForm.Text = 'Copy files from source to destination'

	
	# Labeling source folder text box
	$labelSourceFolder = New-Object System.Windows.Forms.Label
	$labelSourceFolder.Location = '23,23'
	$labelSourceFolder.Size = '300,23'
	$labelSourceFolder.Text = 'Source folder'
	
	# Defining source folder text box
	$textBoxSourceFolder = New-Object System.Windows.Forms.TextBox
	$textBoxSourceFolder.Location = '23,46'
	$textBoxSourceFolder.Size = '300,23'
	$textBoxSourceFolder.Text = 'Select the source folder'
	
	# Defining source folder select button 
	$buttonSelectSourceFolder = New-Object System.Windows.Forms.Button
	$buttonSelectSourceFolder.Location = '350,46'
	$buttonSelectSourceFolder.Text = 'Source'
	
	# Assigning source folder select button
	$browsesourceFolder = New-Object System.Windows.Forms.FolderBrowserDialog
	$buttonSelectSourceFolder.Add_Click({
		$browsesourceFolder.ShowDialog()
		$textBoxSourceFolder.Text = $browsesourceFolder.SelectedPath
	})
	$textBoxSourceFolder.ReadOnly = $true


	# Labeling source folder text box
	$labelDropDown = New-Object System.Windows.Forms.Label
	$labelDropDown.Location = '23,92'
	$labelDropDown.Size = '300,23'
	$labelDropDown.Text = 'File Extension'
	
	# Defining drop down box
	$boxDropDown = New-Object System.Windows.Forms.ComboBox
	$boxDropDown.Location = '23,115'
	$boxDropDown.Size = '130,65'
	$boxDropDown.Text = 'Select file extension'
	
	# Assigning items to drop down box
	ForEach ($Item in $dropDownArray) {
		$boxDropDown.Items.Add($Item)
	}
	
	
	# Labeling destination folder text box
	$labelDestinationFolder = New-Object System.Windows.Forms.Label
	$labelDestinationFolder.Location = '23,161'
	$labelDestinationFolder.Size = '300,23'
	$labelDestinationFolder.Text = 'Destination folder'
	
	# Defining destination folder text box
	$textBoxDestinationFolder = New-Object System.Windows.Forms.TextBox
	$textBoxDestinationFolder.Location = '23,184'
	$textBoxDestinationFolder.Size = '300,23'
	$textBoxDestinationFolder.Text = 'Select destination folder'
	
	
	# Defining destination folder select button 
	$buttonSelectDestinationFolder = New-Object System.Windows.Forms.Button
	$buttonSelectDestinationFolder.Location = '350,184'
	$buttonSelectDestinationFolder.Text = 'Destination'
	
	# Assigning destination folder select button
	$browseDestinationFolder = New-Object System.Windows.Forms.FolderBrowserDialog
	$buttonSelectDestinationFolder.Add_Click({
		$browseDestinationFolder.ShowDialog()
		$textBoxDestinationFolder.Text = $browseDestinationFolder.SelectedPath
	})
	$textBoxDestinationFolder.ReadOnly = $true
	
	
	# Defining copy button
	$copyButton = New-Object System.Windows.Forms.Button
	$copyButton.Location = '23,230'
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
	$basicForm.Controls.Add($labelSourceFolder)
	$basicForm.Controls.Add($textBoxSourceFolder)
	$basicForm.Controls.Add($buttonSelectSourceFolder)
	$basicForm.Controls.Add($labelDropDown)
	$basicForm.Controls.Add($boxDropDown)
	$basicForm.Controls.Add($labelDestinationFolder)
	$basicForm.Controls.Add($textBoxDestinationFolder)
	$basicForm.Controls.Add($buttonSelectDestinationFolder)
	$basicForm.Controls.Add($copyButton)
	
	
	$basicForm.ShowDialog()
	
}

GenerateForm
