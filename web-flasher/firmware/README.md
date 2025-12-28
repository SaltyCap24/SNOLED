Place your compiled firmware binaries here.

## Required Files

After building with PlatformIO, copy these files:

### ESP32
- `.pio/build/snoled_esp32/firmware.bin` → `snoled_esp32.bin`
- `.pio/build/snoled_esp32/bootloader.bin` → `snoled_esp32_bootloader.bin`
- `.pio/build/snoled_esp32/partitions.bin` → `snoled_esp32_partitions.bin`
- `~/.platformio/packages/framework-arduinoespressif32/tools/partitions/boot_app0.bin` → `snoled_esp32_boot_app0.bin`

### ESP8266
- `.pio/build/snoled_esp8266/firmware.bin` → `snoled_esp8266.bin`

### ESP32-S3
- `.pio/build/snoled_esp32s3_16mb/firmware.bin` → `snoled_esp32s3.bin`
- `.pio/build/snoled_esp32s3_16mb/bootloader.bin` → `snoled_esp32s3_bootloader.bin`
- `.pio/build/snoled_esp32s3_16mb/partitions.bin` → `snoled_esp32s3_partitions.bin`
- `~/.platformio/packages/framework-arduinoespressif32/tools/partitions/boot_app0.bin` → `snoled_esp32s3_boot_app0.bin`

### ESP32-C3
- `.pio/build/snoled_esp32c3/firmware.bin` → `snoled_esp32c3.bin`
- `.pio/build/snoled_esp32c3/bootloader.bin` → `snoled_esp32c3_bootloader.bin`
- `.pio/build/snoled_esp32c3/partitions.bin` → `snoled_esp32c3_partitions.bin`
- `~/.platformio/packages/framework-arduinoespressif32/tools/partitions/boot_app0.bin` → `snoled_esp32c3_boot_app0.bin`

## Quick Copy Script

Run from project root:
```bash
./web-flasher/update-firmware.sh
```
