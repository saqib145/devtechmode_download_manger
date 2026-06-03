# AUTOMATED COMPOSER INSTALLER & PATH FIXER
$phpPath = "C:\xampp\php\php.exe"
$installDir = "C:\composer"

Write-Host "--- TikTok Downloader: Composer Fixer ---" -ForegroundColor Cyan

# 1. Check if PHP exists
if (!(Test-Path $phpPath)) {
    Write-Host "ERROR: PHP not found at $phpPath. Please ensure XAMPP is installed." -ForegroundColor Red
    pause
    exit
}

# 2. Create installation directory
if (!(Test-Path $installDir)) {
    try {
        New-Item -ItemType Directory -Force -Path $installDir -ErrorAction Stop | Out-Null
    } catch {
        Write-Host "ERROR: Could not create $installDir. Try running as Administrator." -ForegroundColor Red
        pause
        exit
    }
}

# 3. Download Composer
Write-Host "Step 1: Downloading Composer..." -ForegroundColor Yellow
$installerPath = "$env:TEMP\composer-setup.php"
try {
    Invoke-WebRequest -Uri "https://getcomposer.org/installer" -OutFile $installerPath -ErrorAction Stop
} catch {
    Write-Host "ERROR: Download failed. Check your internet connection." -ForegroundColor Red
    pause
    exit
}

# 4. Install Composer
Write-Host "Step 2: Installing Composer to $installDir..." -ForegroundColor Yellow
& $phpPath $installerPath --install-dir=$installDir --filename=composer.phar

# 5. Create a batch wrapper for easy 'composer' command
"@php `"$installDir\composer.phar`" %*" | Out-File -FilePath "$installDir\composer.bat" -Encoding ASCII

# 6. Add to User PATH
Write-Host "Step 3: Updating Windows Environment Variables..." -ForegroundColor Yellow
$oldPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($oldPath -notlike "*$installDir*") {
    $newPath = $oldPath + ";" + $installDir
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "SUCCESS: Path updated!" -ForegroundColor Green
} else {
    Write-Host "Note: Path already contains the composer directory." -ForegroundColor Gray
}

Write-Host "`n--- FIX COMPLETE ---" -ForegroundColor Green
Write-Host "IMPORTANT: You MUST close and RESTART VS Code/Terminal for this to work." -ForegroundColor White
pause
