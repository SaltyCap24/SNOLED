# update-firmware.ps1
# Copy firmware from PlatformIO build directory to web flasher

$ErrorActionPreference = "Stop"

$PIO_BUILD = ".pio/build"
$FIRMWARE_DIR = "web-flasher/firmware"

Write-Host "Updating SNOLED Web Flasher Firmware..." -ForegroundColor Cyan

# Create firmware directory if it doesn't exist
if (-not (Test-Path $FIRMWARE_DIR)) {
    New-Item -ItemType Directory -Path $FIRMWARE_DIR -Force | Out-Null
}

function Copy-FirmwareFiles {
    param(
        [string]$BuildEnv,
        [string]$Prefix,
        [string]$ChipFamily
    )
    
    $buildPath = "$PIO_BUILD/$BuildEnv"
    
    if (-not (Test-Path $buildPath)) {
        Write-Host "  Build directory not found: $buildPath" -ForegroundColor Yellow
        Write-Host "   Run: pio run -e $BuildEnv" -ForegroundColor Yellow
        return $false
    }
    
    Write-Host "Copying $Prefix files..." -ForegroundColor Green
    
    # Copy main firmware
    Copy-Item "$buildPath/firmware.bin" "$FIRMWARE_DIR/$Prefix.bin" -Force
    
    # ESP32 family needs bootloader, partitions, and boot_app0
    if ($ChipFamily -ne "ESP8266") {
        Copy-Item "$buildPath/bootloader.bin" "$FIRMWARE_DIR/${Prefix}_bootloader.bin" -Force
        Copy-Item "$buildPath/partitions.bin" "$FIRMWARE_DIR/${Prefix}_partitions.bin" -Force
        
        # boot_app0.bin is in the framework, not build directory
        $bootApp0 = "$env:USERPROFILE\.platformio\packages\framework-arduinoespressif32\tools\partitions\boot_app0.bin"
        if (Test-Path $bootApp0) {
            Copy-Item $bootApp0 "$FIRMWARE_DIR/${Prefix}_boot_app0.bin" -Force
        } else {
            Write-Host "   boot_app0.bin not found at: $bootApp0" -ForegroundColor Yellow
        }
    }
    
    Write-Host "   Done: $Prefix firmware copied" -ForegroundColor Green
    return $true
}

# Copy firmware for each platform
$success = @{
    ESP32   = Copy-FirmwareFiles "esp32dev" "snoled_esp32" "ESP32"
    ESP8266 = Copy-FirmwareFiles "nodemcuv2" "snoled_esp8266" "ESP8266"
    ESP32S3 = Copy-FirmwareFiles "esp32s3dev_16MB_opi" "snoled_esp32s3" "ESP32-S3"
    ESP32C3 = Copy-FirmwareFiles "esp32c3dev" "snoled_esp32c3" "ESP32-C3"
}

Write-Host ""
Write-Host "Summary:" -ForegroundColor Cyan
foreach ($platform in $success.Keys) {
    $status = if ($success[$platform]) { "OK" } else { "SKIP" }
    Write-Host "   $status - $platform"
}

Write-Host ""
Write-Host "Firmware update complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Test locally: cd web-flasher && python -m http.server 8000" -ForegroundColor White
Write-Host "  2. Or deploy to GitHub Pages / Netlify / Vercel" -ForegroundColor White
Write-Host "  3. Visit your web flasher URL to test installation" -ForegroundColor White
