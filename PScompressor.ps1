# Set the root directory to the current directory
$rootDir = $PSScriptRoot

# Set the output file path
$outputFilePath = Join-Path $rootDir "compressed.txt"

# Define the compression function
function Compress-Code {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Code
    )
    process {
        if ($Code -eq "") {
            return ""
        }
        $replacements = @{}
        $i = 0
        $Code -replace '(?s)(["''])((?:\\\1|(?:(?!\1)).)*)(\1)', {
            $key = "p$i"
            if ($matches -ne $null) {
                $replacements[$key] = $matches[2]
                $i++
            }
            $key
        } -replace '\b([a-zA-Z][a-zA-Z0-9]*)\b', {
            if ($matches -ne $null) {
                $word = $matches[1]
                if ($word -ne $null -and $replacements.ContainsKey($word)) {
                    $replacements[$word]
                } else {
                    $word
                }
            } else {
                $_
            }
        } | ForEach-Object {
            $key = $_
            if ($replacements.ContainsKey($key)) {
                "d{{$key}:$($replacements[$key])}"
            } else {
                $_
            }
        } -join "`n"
    }
}


# Get all files in the root directory and its subfolders
$files = Get-ChildItem -Path $rootDir -Recurse -File

# Initialize an array to store the compressed contents of each file
$compressedContents = @()

# Loop through each file and compress its contents
foreach ($file in $files) {
    # Read the contents of the file
    $code = Get-Content $file.FullName -Raw

    # Compress the code
    $compressedCode = Compress-Code $code

    # Add the compressed code and file path to the array
    $compressedContents += ("//file:$($file.FullName)`n$compressedCode")
}

# Write the compressed contents to the output file
($compressedContents -join "`n`n") | Out-File -FilePath $outputFilePath -Encoding utf8
