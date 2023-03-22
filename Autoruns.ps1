# Define the path to the folder containing autorun files
$autorunPath = "C:\Windows\System32"

# Get all autorun files in the folder
$autorunFiles = Get-ChildItem -Path $autorunPath -Filter "autorun.*" -Recurse

# Create an array to store the autorun file information
$autorunInfo = @()

# Loop through each autorun file
foreach ($file in $autorunFiles) {
    # Get the file's name, path, and hash
    $fileName = $file.Name
    $filePath = $file.FullName
    $fileHash = (Get-FileHash -Path $filePath -Algorithm SHA256).Hash

    # Submit the file hash to VirusTotal for analysis
    $vtUrl = "https://www.virustotal.com/vtapi/v2/file/report?apikey=<YOUR_API_KEY>&resource=$fileHash"
    $vtResponse = Invoke-RestMethod -Uri $vtUrl
    $vtScanResult = $vtResponse.positives

    # Add the file information to the array
    $autorunInfo += [PSCustomObject]@{
        Name = $fileName
        Path = $filePath
        Hash = $fileHash
        VirusTotal = $vtScanResult
    }
}

# Export the autorun information to a CSV file
$autorunInfo | Export-Csv -Path "autorun_info.csv" -NoTypeInformation

# Display the autorun information in the console
$autorunInfo | Format-Table -AutoSize
