$htmlDir = "c:/Users/USER/Downloads/Icube website/arinde-architecture-interior-html-template-2025-10-01-07-10-18-utc/arinde/html"
$countFiles = 0
$countLinks = 0

Get-ChildItem -Path $htmlDir -Filter *.html | ForEach-Object {
    $path = $_.FullName
    $content = Get-Content -Path $path -Raw -Encoding UTF8
    
    # Define regex callback to count changes (more complex in PS, so just doing replace and checking result)
    # Using [Regex]::Replace with a MatchEvaluator is possible but loop is easier for simple script
    
    $modified = $false
    $newContent = [Regex]::Replace($content, 'href="([^"#.:/]+)"', {
        param($match)
        $link = $match.Groups[1].Value
        Write-Host "  Replacing: $link -> $link.html in $($_.Name)"
        return 'href="' + $link + '.html"'
    })

    if ($content -ne $newContent) {
        Set-Content -Path $path -Value $newContent -Encoding UTF8
        Write-Host "Updated $($_.Name)"
        $countFiles++
    }
}

Write-Host "Finished. Updated files: $countFiles"
