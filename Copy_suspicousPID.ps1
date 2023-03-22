# Check if a PID was provided as an argument
if ($args.Count -eq 0) {
    Write-Host "Please provide a PID as an argument."
    exit 1
}

# Get the process name from the PID
$processName = (Get-Process -Id $args[0]).Name

# Check if the process exists
if ($processName -eq $null) {
    Write-Host "Process with PID $($args[0]) does not exist."
    exit 1
}

# Create a copy of the process
Copy-Item -Path (Get-Process -Id $args[0]).Path -Destination "C:\Temp\$processName-$($args[0]).exe"

Write-Host "Copied executable file of process with PID $($args[0]) to C:\Temp\$processName-$($args[0]).exe"
