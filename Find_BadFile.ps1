# Define list of bad file extensions
$badFileExtensions = ".exe", ".bat", ".js", ".vbs", ".ps1", ".hta", ".jar", ".dll", ".zip", ".rar"

# Define the event handler function
function FileOpenedHandler($sender, $e) {
    $file = $e.FullPath

    # Check if the file is a PDF
    if ([System.IO.Path]::GetExtension($file) -ne ".pdf") {
        return
    }

    # Check if the file has any attachments
    $pdf = New-Object -ComObject "AcroExch.PDDoc"
    $pdf.Open($file)
    $attachments = $pdf.GetJSObject().this.info.Files
    if ($attachments.Count -gt 0) {
        # Check each attachment for bad file extension
        foreach ($attachment in $attachments) {
            $extension = [System.IO.Path]::GetExtension($attachment)
            if ($badFileExtensions.Contains($extension)) {
                Write-Host "Error: PDF file contains a bad file extension: $extension"
                $pdf.Close()
                Exit
            }
        }
    }

    # If no bad file extensions were found, open the PDF file
    $pdf.Close()
    Invoke-Item $file
}

# Register the event handler for PDF file open events
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $env:userprofile
$watcher.Filter = "*.pdf"
$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $true
Register-ObjectEvent -InputObject $watcher -EventName "Created" -Action { FileOpenedHandler $sender $args[1] } | Out-Null
