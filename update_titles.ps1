$htmlDir = "c:/Users/USER/Downloads/Icube website/arinde-architecture-interior-html-template-2025-10-01-07-10-18-utc/arinde/html"
$countFiles = 0

Get-ChildItem -Path $htmlDir -Filter *.html | ForEach-Object {
    $path = $_.FullName
    $content = Get-Content -Path $path -Raw -Encoding UTF8
    
    # Replace content inside <title> tags
    $newContent = [Regex]::Replace($content, '<title>.*?</title>', '<title>iCUBE</title>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

    if ($content -ne $newContent) {
        Set-Content -Path $path -Value $newContent -Encoding UTF8
        Write-Host "Updated Title in $($_.Name)"
        $countFiles++
    }
}

Write-Host "Finished. Updated files: $countFiles"
