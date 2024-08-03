$profiles = netsh wlan show profiles | Select-String "所有用户配置文件 : " | ForEach-Object { $_.ToString().Split(':')[1].Trim() }
foreach ($profile in $profiles) {
    $details = netsh wlan show profile name="$profile" key=clear
    $wifiName = $details | Select-String "名称" | ForEach-Object { $_.ToString().Split(':')[1].Trim() }
    $keyContent = $details | Select-String "关键内容" | ForEach-Object { $_.ToString().Split(':')[1].Trim() }
    Write-Output "WiFi 名称: $wifiName"
    Write-Output "密钥: $keyContent"
    Write-Output "`n"
}