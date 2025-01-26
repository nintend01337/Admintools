# Admintools
Шпаргалка терминала и вавершела для меня и для моих плановых работ.

Проверка запущенных служб 

```Get-Service tact*,zabb*,mesh*```

## Планировщик
```taskschd``` Вызовет планировщик из командной строки.

``` schtasks /create /tn "Reboot" /tr "shutdown /r /f /t 0" /sc daily /st 23:00 /f ```

## Антивирус
### Список исключений антивируса (MS Defender) : 
```Get-MpPreference | Select-Object -ExpandProperty ExclusionPath```
### Добавляем в исключения : 
```
Add-MpPreference -ExclusionPath "C:\Program Files\TacticalAgent\*" 
Add-MpPreference -ExclusionPath "C:\Program Files\Mesh Agent\*"
Add-MpPreference -ExclusionPath "C:\ProgramData\TacticalRMM\*"

```
Расшифровка параметров:
/create: Указывает, что мы создаем новую задачу.

/tn "Reboot": Устанавливает имя задачи (в данном случае "Reboot").

/tr "shutdown /r /f /t 0": Указывает действие, которое будет выполняться (перезагрузка с принудительным завершением всех процессов).

/sc daily: Устанавливает расписание для задачи (ежедневно).

/st 23:00: Указывает время запуска задачи (23:00).

/f: Принудительное создание задачи, даже если такая уже существует.

## Автозагрузка
```wmic startup list brief```
второй вариант :
```Get-CimInstance Win32_StartupCommand```

## Получаем список установленного ПО 
### через wmic

```wmic product get Name,IdentifyingNumber```

Далее если мы хотим что то удалить используем следующую команду
```msiexec /x {IdentifyingNumber}```

### через PS
```Get-AppxPackage *| select Name, PackageFamilyName,NonRemovable ```
Удаление
```Remove-AppxPackage <PackageFamilyName>```
Установка WINGET на пк :
```
Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -OutFile "$env:TEMP\Microsoft.DesktopAppInstaller.msixbundle"
```
```
Add-AppxPackage -Path "$env:TEMP\Microsoft.DesktopAppInstaller.msixbundle"
```


## Zabbix
Получаем имя пк в заббиксе
```type C:/zabbix/config.conf | findstr "Hostname" ``` либо ```Get-Content C://Zabbix//config.conf | Select-String Hostname```
### Удаление Zabbix'a 
#### Удаляем заббикса происходит следующим путем
+ Стопаем службу заббикса ```sc stop "zabbix agent"```
+ Запускаем батник "Удаление Агента"
+ Забираем права на папку себе : ``` takeown /F C:/zabbix /R /D Y ```
+ Удаляем остатки Заббикса ```Remove-Item -Path "C:/zabbix" -Recurse ```
