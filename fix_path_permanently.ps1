# --- PERMANENT PATH FIXER ---
$phpPath = "C:\xampp\php"
$composerDir = "C:\composer"

Write-Host "--- Fixing Environment Variables ---" -ForegroundColor Cyan

# 1. Add PHP to Path
$oldPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($oldPath -notlike "*$phpPath*") {
    $newPath = $oldPath + ";" + $phpPath
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "[SUCCESS] PHP added to PATH." -ForegroundColor Green
} else {
    Write-Host "[INFO] PHP is already in PATH." -ForegroundColor Gray
}

# 2. Add Composer to Path
if ($oldPath -notlike "*$composerDir*") {
    $newPath = [Environment]::GetEnvironmentVariable("Path", "User") + ";" + $composerDir
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "[SUCCESS] Composer added to PATH." -ForegroundColor Green
} else {
    Write-Host "[INFO] Composer is already in PATH." -ForegroundColor Gray
}

# 3. Ensure composer.bat exists if phar is there
if (Test-Path "$composerDir\composer.phar") {
    if (!(Test-Path "$composerDir\composer.bat")) {
        "@php `"$composerDir\composer.phar`" %*" | Out-File -FilePath "$composerDir\composer.bat" -Encoding ASCII
        Write-Host "[SUCCESS] Created composer.bat wrapper." -ForegroundColor Green
    }
}

Write-Host "`n--- FIX COMPLETE ---" -ForegroundColor Green
Write-Host "IMPORTANT: You MUST close and RESTART VS Code/Terminal for this to take effect." -ForegroundColor White
pause
