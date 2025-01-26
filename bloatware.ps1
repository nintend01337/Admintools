# Убедитесь, что PowerShell запущен с правами администратора

# Исключения (не удаляются)
$ExcludedApps = @(
    "Microsoft.Store",              # Microsoft Store
    "Microsoft.DesktopAppInstaller", # Winget
    "Microsoft.WindowsCalculator",  # Калькулятор
    "Microsoft.Windows.Photos",     # Фото
    "Microsoft.WindowsSoundRecorder" # Диктофон
)

# Список предустановленных приложений (bloatware), которые нужно удалить
$BloatwareApps = @(
    "Microsoft.3DBuilder",
    "Microsoft.Microsoft3DViewer",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.OneConnect",
    "Microsoft.People",
    "Microsoft.SkypeApp",
    "Microsoft.XboxApp",
    "Microsoft.XboxGameOverlay",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.XboxSpeechToTextOverlay",
    "Microsoft.YourPhone",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo",
    "Microsoft.BingWeather",
    "Microsoft.GetHelp",
    "Microsoft.Getstarted",
    "Microsoft.Messaging",
    "Microsoft.MSPaint",
    "Microsoft.Office.OneNote",
    "Microsoft.Wallet",
    "Microsoft.WindowsAlarms",
    "Microsoft.WindowsCamera",
    "Microsoft.WindowsMaps",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.Xbox.TCUI",
    "Microsoft.XboxGameCallableUI"
)

# === УДАЛЕНИЕ ONEDRIVE ===
Write-Host "Удаление OneDrive..." -ForegroundColor Yellow
Stop-Process -Name "OneDrive" -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
if (Test-Path "$env:LOCALAPPDATA\Microsoft\OneDrive\Update\OneDriveSetup.exe") {
    Start-Process "$env:LOCALAPPDATA\Microsoft\OneDrive\Update\OneDriveSetup.exe" "/uninstall" -NoNewWindow -Wait
    Remove-Item -Recurse -Force "$env:OneDrive" -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force "$env:USERPROFILE\OneDrive" -ErrorAction SilentlyContinue
    Write-Host "OneDrive успешно удалён." -ForegroundColor Green
} else {
    Write-Host "OneDrive уже удалён или не установлен." -ForegroundColor Cyan
}

# === УДАЛЕНИЕ ПРЕДУСТАНОВЛЕННЫХ ПРИЛОЖЕНИЙ ===
foreach ($App in $BloatwareApps) {
    if ($ExcludedApps -notcontains $App) {
        Write-Host "Удаление приложения: $App..." -ForegroundColor Yellow
        Get-AppxPackage -Name $App -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
        Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -like $App} | ForEach-Object {
            Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName -ErrorAction SilentlyContinue
        }
    } else {
        Write-Host "Пропуск исключённого приложения: $App" -ForegroundColor Cyan
    }
}

Write-Host "Удаление предустановленных приложений завершено!" -ForegroundColor Green

# === ФИНАЛЬНОЕ СООБЩЕНИЕ ===
Write-Host "Система очищена от ненужных предустановленных приложений и OneDrive." -ForegroundColor Cyan
Write-Host "Microsoft Store и Winget сохранены." -ForegroundColor Cyan
