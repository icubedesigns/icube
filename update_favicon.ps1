$htmlDir = "c:/Users/USER/Downloads/Icube website/arinde-architecture-interior-html-template-2025-10-01-07-10-18-utc/arinde/html"
$countFiles = 0

Get-ChildItem -Path $htmlDir -Filter *.html | ForEach-Object {
    $path = $_.FullName
    $content = Get-Content -Path $path -Raw -Encoding UTF8
    
    # Replace the favicon link
    # Matches <link rel="shortcut icon" href="..." type="image/x-icon">
    $newContent = [Regex]::Replace($content, '<link rel="shortcut icon" href=".*?" type="image/x-icon">', '<link rel="shortcut icon" href="assets/images/logos/RED-RED TEXT - Rotated.png" type="image/x-icon">', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

    if ($content -ne $newContent) {
        Set-Content -Path $path -Value $newContent -Encoding UTF8
        Write-Host "Updated Favicon in $($_.Name)"
        $countFiles++
    }
}

Write-Host "Finished. Updated files: $countFiles"
