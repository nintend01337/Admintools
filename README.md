# Admintools
Шпаргалка терминала и вавершела для меня и для моих плановых работ.

Проверка запущенных служб 

```powershell 
Get-Service tact*,zabb*,mesh*
```
## Получение Базовой информации
```powershell
Get-ComputerInfo|Select-Object CsName,CsUserName,CsDomain,CsSystemFamily,CsSystemType,CsProcessors,OsName,OsVersion,OsUptime |Format-List
```

## Планировщик
```cmd
taskschd
```
Вызовет планировщик из командной строки.

```powershell 
schtasks /create /tn "Reboot" /tr "shutdown /r /f /t 0" /sc daily /st 23:00 /f
```
Расшифровка параметров:
/create: Указывает, что мы создаем новую задачу.

/tn "Reboot": Устанавливает имя задачи (в данном случае "Reboot").

/tr "shutdown /r /f /t 0": Указывает действие, которое будет выполняться (перезагрузка с принудительным завершением всех процессов).

/sc daily: Устанавливает расписание для задачи (ежедневно).

/st 23:00: Указывает время запуска задачи (23:00).

/f: Принудительное создание задачи, даже если такая уже существует.

## Антивирус
### Список исключений антивируса (MS Defender) : 
```powershell
Get-MpPreference | Select-Object -ExpandProperty ExclusionPath
```
### Добавляем в исключения : 
```powershell
Add-MpPreference -ExclusionPath "C:\zabbix\"
Add-MpPreference -ExclusionPath "C:\Program Files\TacticalAgent\*" 
Add-MpPreference -ExclusionPath "C:\Program Files\Mesh Agent\*"
Add-MpPreference -ExclusionPath "C:\ProgramData\TacticalRMM\*"

```
### Удаление из исключений
```powershell
Remove-MpPreference -ExclusionPath <String[]>
Remove-MpPreference -ExclusionExtension <String[]>
Remove-MpPreference -ExclusionProcess <String[]>
Remove-MpPreference -ThreatIDExclusion <String[]>

Remove-MpPreference -ExclusionPath "C:\Program Files\TacticalAgent\*" 
Remove-MpPreference -ExclusionPath "C:\Program Files\Mesh Agent\*"
Remove-MpPreference -ExclusionPath "C:\ProgramData\TacticalRMM\*"

```
## Изменение Хостнейма пк через командную строку
```powershell 
wmic computersystem where name="%COMPUTERNAME%" call rename name="OFFICE-PC07"
```


## Автозагрузка
```cmd 
wmic startup list brief
```
второй вариант :
``` powershell 
Get-CimInstance Win32_StartupCommand
```

## Получаем список установленного ПО 
### через wmic

```powershell  
product get Name,IdentifyingNumber
```

Далее если мы хотим что то удалить используем следующую команду
```powershell 
msiexec /x {IdentifyingNumber}
```

### через PS
```powershell
Get-AppxPackage * | select Name, PackageFamilyName,NonRemovable
```
Удаление
``` powershell 
Remove-AppxPackage <PackageFamilyName>
```
Установка WINGET на пк :
```powershell
Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -OutFile "$env:TEMP\Microsoft.DesktopAppInstaller.msixbundle"
```
```powershell
Add-AppxPackage -Path "$env:TEMP\Microsoft.DesktopAppInstaller.msixbundle"
```
## из заданной папки удалять все файлы и папки старше 14 дней
```powershell
$Path = "C:\temp"
$Days = "-14"
$CurrentDate = Get-Date
$OldDate = $CurrentDate.AddDays($Days)
Get-ChildItem $Path -Recurse | Where-Object { $_.LastWriteTime -lt $OldDate } | Remove-Item
```

## Удаление файлов

### Удаляем временные файлы пользователя
```powershell
Remove-Item -Path "$env:LOCALAPPDATA\Temp\*" -Recurse -Force
Remove-Item -Path "$env:HOMEDRIVE$env:HOMEPATH\Local Settings\Temp\*" -Recurse -Force
```
### Удаляем временные файлы системы
```powershell
Remove-Item -Path "$env:WinDir\Temp\*" -Recurse -Force
Remove-Item -Path "$env:TEMP\*" -Recurse -Force
Remove-Item -Path "$env:TMP\*" -Recurse -Force
```
### Удаляем временные файлы браузера
```powershell
Remove-Item -Path "$env:HOMEDRIVE$env:HOMEPATH\Local Settings\Temporary Internet Files\*" -Recurse -Force
Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Windows\Temporary Internet Files\*" -Recurse -Force
```
## Создать точку восстановления : 

```powershell
Checkpoint-Computer -Description "ChangeNetSettings" -RestorePointType MODIFY_SETTINGS
```
### Параметры:
+ -Description
Указывает описание контрольной точки, которое поможет вам идентифицировать её позже. Это описание может быть произвольным.

Пример:

```powershell 
Checkpoint-Computer -Description "Before installing new software"
-RestorePointType
```
### Указывает тип точки восстановления. Возможные значения:

+ APPLICATION_INSTALL — точка восстановления перед установкой приложения.
+ APPLICATION_UNINSTALL — точка восстановления перед удалением приложения.
+ DEVICE_DRIVER_INSTALL — точка восстановления перед установкой драйвера устройства.
+ MODIFY_SETTINGS — точка восстановления при изменении настроек системы.
### Пример:

```powershell
Checkpoint-Computer -Description "Before updating drivers" -RestorePointType "DEVICE_DRIVER_INSTALL"
```
### Пример использования:
Если вы хотите создать точку восстановления перед установкой нового программного обеспечения, выполните следующую команду:

```powershell
Checkpoint-Computer -Description "Before installing software XYZ" -RestorePointType "APPLICATION_INSTALL"
```
## Как проверить существующие точки восстановления:
Чтобы проверить существующие контрольные точки на вашем компьютере, используйте команду:

```powershell
Get-ComputerRestorePoint
```
Это выведет список всех точек восстановления, включая их описание, дату и тип.

## WMIC несколько штук которые можно сделать через WMIC
+ Получение информации о принтерах
  ```powershell
  wmic printer list brief
  ```
+ Получение списка служб
  ``` powershell
  wmic service list brief
  ```
 ```powershell
  wmic service where "state='Running'" get name, state
 ```
+ Получение списка обновлений
  ``` powershell
  wmic qfe list brief
  ```
  либо
  ``` powershell
  Get-HotFix
  ```
Удалить можно командой : 
```powershell 
wusa /uninstall /kb:  /quiet /norestart
```
Пример удаления нескольких обнов : 
```powershell
$updatesToRemove = @("KB5021234", "KB5019980")
foreach ($update in $updatesToRemove) {
    Start-Process "wusa.exe" -ArgumentList "/uninstall /kb:$update /quiet /norestart" -Wait
}
```
## Zabbix
Получаем имя пк в заббиксе
```powershell
type C:/zabbix/config.conf | findstr "Hostname" 
```
либо 
```powershell 
Get-Content C://Zabbix//config.conf | Select-String Hostname
```
Переименовываем хост удаленно 
```powershell 
(Get-Content "C:/zabbix/config.conf") -replace "Hostname=Current","Hostname=Result" | Set-Content "C:/zabbix/config.conf"
```

### Удаление Zabbix'a 
#### Удаляем заббикса происходит следующим путем
+ Стопаем службу заббикса ```sc stop "zabbix agent"```
+ Запускаем батник "Удаление Агента"
+ Забираем права на папку себе : ``` takeown /F C:/zabbix /R /D Y ```
+ Удаляем остатки Заббикса ```Remove-Item -Path "C:/zabbix" -Recurse ```

## Некоторые сокращенные команды которые можно запустить из под терминала CMD
+ appwiz.cpl – утилита «Программы и компоненты»
+ certmgr.msc – окно для управления сертификатами системы
+ control printers – окно для управления устройствами и принтерами 
+ control userpasswords2 – «Учетные записи пользователя»  
+ compmgmt.msc – «Администрирование»
+ devmgmt.msc – «Диспетчер устройств»
+ diskmgmt.msc – «Управление дисками
+ hdwwiz.cpl – еще одна команда для вызова окна «Диспетчер устройств»
+ firewall.cpl – Брандмауэр Защитника Windows
+ gpedit.msc – «Редактор локальной групповой политики»
+ lusrmgr.msc – «Локальные пользователи и группы»
+ secpol.msc - Локальная политика безопасности
+ mmc – консоль управления системными оснастками
+ services.msc – средство управления службами операционной системы
+ taskschd.msc – «Планировщик заданий»
+ control admintools – открытие папки со средствами администрирования
+ eventvwr.msc – просмотр журнала событий
+ fsmgmt.msc – средство работы с общими папками
+ msinfo32 – просмотр сведений об операционной системе
+ mstsc – подключение к удаленному Рабочему столу
+ netplwiz – панель управления «Учетными записями пользователей»
+ optionalfeatures – включение и отключение стандартных компонентов операционной системы
+ sndvol – запуск микшера громкости
+ sysdm.cpl – вызов окна «Свойства системы»
+ useraccountcontrolsettings – «Параметры управления учетными записями пользователей»
+ winver – просмотр общих сведений об операционной системе и ее версии
+ control netconnections – просмотр и настройка доступных «Сетевых подключений»
+ slui – средство активации лицензии ОС Windows

## Shell
+ shell:NetworkPlacesFolder  - Сетевые Ресурсы
+ shell:FileHistory - История файлов
+ shell:SystemRestore - Восстановление Системы
+ shell:Profile – %UserProfile%  Профиль пользователя
+ shell:Public – %Public%
+ shell:Recent – %AppData%\Microsoft\Windows\Recent
+ shell:RecycleBinFolder – Recycle Bin (Корзина)
+ shell:Start Menu - Пуск
+ shell:Startup - автозапуск
+ shell:AppUpdatesFolder - Установленные обновления
+ shell:Cache - Просмотр кеша
+ shell:Cookies - Куки
+ shell:ConnectionsFolder - Сетевые подключения
+ shell:Windows - Windir 


## Принтеры : 
+ shell:DevicesAndPrintersFolder  - Устройства и принтеры
+ shell:PrintersFolder - Просмотр принтеров в системе
+ printui /s - Просмотр драйверов принтера, портов
+ printui /s /t2

### Получить список принтеров в системе
```powershell
Get-Printer
```

### Удаление всех принтеров
```powershell
Get-Printer | ForEach-Object { Remove-Printer -Name $_.Name }
```
### Получение списка портов принтера
```powershell
 Get-WmiObject -Class Win32_TCPIPPrinterPort | Select Name,PortNumber,Description,HostAddress
```
### Удаление всех портов принтера
```powershell
Get-WmiObject -Class Win32_TCPIPPrinterPort | ForEach-Object { $_.Delete() }
```

### Получение списка драйверов принтеров
```powershell
 Get-WmiObject -Class Win32_PrinterDriver | select Name, DriverPath
```
### Удалить все драйвера принтеров
```powershell
Get-WmiObject -Class Win32_PrinterDriver | ForEach-Object { $_.Delete() }
```
Пример удаления всех принтеров,портов,драйверов : только фирмы hp (код требует проверки не копировать слепо)
```powershell
Get-Printer | Where-Object { $_.Name -like "*HP*" } | ForEach-Object { Remove-Printer -Name $_.Name }
Get-WmiObject -Class Win32_TCPIPPrinterPort | Where-Object { $_.Name -like "*HP*" } | ForEach-Object { $_.Delete() }
Get-WmiObject -Class Win32_PrinterDriver | Where-Object { $_.Name -like "*HP*" } | ForEach-Object { $_.Delete() }
```



## Очистка диска 

### Подготовка сета :
```cmd 
cleanmgr /sageset:1

```
### Запуск сета :
```cmd 
cleanmgr /sagerun:1

```
### Добавить очистку в планировщик  :
```cmd 
schtasks /create /tn "Очистка диска" /tr "cleanmgr.exe /sagerun:1" /sc monthly /d 1 /st 09:00 /f

```
## DISM 

### Узнать состояние зарезервированого хранилища
```cmd
DISM /Online  /Get-ReservedStorageState
```

### Отключить зарезервированое хранилище

```cmd
DISM /Online  /Set-ReservedStorageState /State:Disabled 
```
### Включить зарезервированое хранилище

```cmd
DISM /Online  /Set-ReservedStorageState /State:Enabled 
```

### Анализ и очистка компонентов хранилища Windows WinSxS

```cmd
DISM /Online  /cleanup-image /AnalyzeComponentStore
```

### Очистка хранилища Windows WinSxS

```cmd
DISM /Online  /cleanup-image /StartComponentCleanUp /ResetBase
```

### Сжатие Системы 

Проверить сжатие системы

```cmd
compact /CompactOS:query
```
Сжать систему 
```cmd
compact /CompactOS:always
```
Отменить сжатие
```cmd
compact /CompactOS:never
```

## PnpUtil
