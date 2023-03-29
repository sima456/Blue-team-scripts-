
Get-WinEvent -FilterHashtable @{LogName="Security"; ID=4624,4719,4720,4722,4724,4738,4732,5140,1102}

Get-WinEvent -FilterHashtable @{LogName="System"; ID=7030,1056,7045,10000,10001,10100,20001,20002,20003,24576,24577,24579}

Get-WinEvent -FilterHashTable @{LogName="Microsoft-Windows-Windows Firewall With Advanced Security/Firewall"; ID=2003}

