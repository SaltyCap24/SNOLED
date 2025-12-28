#!/bin/bash
# update-firmware.sh
# Copy firmware from PlatformIO build directory to web flasher

set -e

PIO_BUILD=".pio/build"
FIRMWARE_DIR="web-flasher/firmware"

echo "🚀 Updating SNOLED Web Flasher Firmware..."

# Create firmware directory if it doesn't exist
mkdir -p "$FIRMWARE_DIR"

copy_firmware() {
    local BUILD_ENV=$1
    local PREFIX=$2
    local CHIP_FAMILY=$3
    
    local BUILD_PATH="$PIO_BUILD/$BUILD_ENV"
    
    if [ ! -d "$BUILD_PATH" ]; then
        echo "⚠️  Build directory not found: $BUILD_PATH"
        echo "   Run: pio run -e $BUILD_ENV"
        return 1
    fi
    
    echo "📦 Copying $PREFIX files..."
    
    # Copy main firmware
    cp "$BUILD_PATH/firmware.bin" "$FIRMWARE_DIR/$PREFIX.bin"
    
    # ESP32 family needs bootloader, partitions, and boot_app0
    if [ "$CHIP_FAMILY" != "ESP8266" ]; then
        cp "$BUILD_PATH/bootloader.bin" "$FIRMWARE_DIR/${PREFIX}_bootloader.bin"
        cp "$BUILD_PATH/partitions.bin" "$FIRMWARE_DIR/${PREFIX}_partitions.bin"
        
        # boot_app0.bin is in the framework
        BOOT_APP0="$HOME/.platformio/packages/framework-arduinoespressif32/tools/partitions/boot_app0.bin"
        if [ -f "$BOOT_APP0" ]; then
            cp "$BOOT_APP0" "$FIRMWARE_DIR/${PREFIX}_boot_app0.bin"
        else
            echo "   ⚠️  boot_app0.bin not found at: $BOOT_APP0"
        fi
    fi
    
    echo "   ✅ $PREFIX firmware copied"
    return 0
}

# Copy firmware for each platform
copy_firmware "snoled_esp32" "snoled_esp32" "ESP32" || true
copy_firmware "snoled_esp8266" "snoled_esp8266" "ESP8266" || true
copy_firmware "snoled_esp32s3_16mb" "snoled_esp32s3" "ESP32-S3" || true
copy_firmware "snoled_esp32c3" "snoled_esp32c3" "ESP32-C3" || true

echo ""
echo "🎉 Firmware update complete!"
echo ""
echo "Next steps:"
echo "  1. Test locally: cd web-flasher && python3 -m http.server 8000"
echo "  2. Or deploy to GitHub Pages / Netlify / Vercel"
echo "  3. Visit your web flasher URL to test installation"
