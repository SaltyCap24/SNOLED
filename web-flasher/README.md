# SNOLED Web Flasher

A browser-based firmware installer for SNOLED, allowing users to flash SNOLED firmware directly from their browser without installing any software.

## 🚀 Quick Start

### Option 1: GitHub Pages (Recommended for Public Use)

1. **Build your SNOLED firmware:**
   ```bash
   pio run -e snoled_esp32
   pio run -e snoled_esp8266
   pio run -e snoled_esp32s3_16mb
   pio run -e snoled_esp32c3
   ```

2. **Copy firmware files:**
   - ESP32 firmware is in `.pio/build/snoled_esp32/`
   - Copy these files to `web-flasher/firmware/`:
     - `firmware.bin` → `snoled_esp32.bin`
     - `bootloader.bin` → `snoled_esp32_bootloader.bin`
     - `partitions.bin` → `snoled_esp32_partitions.bin`
     - `boot_app0.bin` → `snoled_esp32_boot_app0.bin`
   - Repeat for other platforms

3. **Create a GitHub repository for your web flasher:**
   ```bash
   cd web-flasher
   git init
   git add .
   git commit -m "Initial SNOLED web flasher"
   git remote add origin https://github.com/yourusername/snoled-installer.git
   git push -u origin main
   ```

4. **Enable GitHub Pages:**
   - Go to repository Settings → Pages
   - Source: Deploy from branch `main`
   - Folder: `/` (root)
   - Your flasher will be at: `https://yourusername.github.io/snoled-installer/`

### Option 2: Local Testing

1. **Start a local HTTPS server:**
   
   ESP Web Tools requires HTTPS. Use one of these methods:
   
   **Using Python:**
   ```bash
   cd web-flasher
   # Generate self-signed certificate (one-time)
   openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -nodes
   
   # Start HTTPS server
   python -m http.server 8000 --bind localhost
   ```
   
   Then visit: `https://localhost:8000`
   
   **Using npx (with https-localhost):**
   ```bash
   cd web-flasher
   npx https-localhost
   ```

2. **Accept the self-signed certificate warning** in your browser

### Option 3: Deploy to Netlify/Vercel (Free Hosting)

**Netlify:**
```bash
cd web-flasher
npm install -g netlify-cli
netlify deploy --prod
```

**Vercel:**
```bash
cd web-flasher
npm install -g vercel
vercel --prod
```

## 📁 File Structure

```
web-flasher/
├── index.html              # Main installer page
├── manifests/              # ESP Web Tools manifests
│   ├── snoled_esp32.json
│   ├── snoled_esp8266.json
│   ├── snoled_esp32s3.json
│   └── snoled_esp32c3.json
├── firmware/               # Compiled firmware binaries
│   ├── snoled_esp32.bin
│   ├── snoled_esp32_bootloader.bin
│   ├── snoled_esp32_partitions.bin
│   ├── snoled_esp32_boot_app0.bin
│   ├── snoled_esp8266.bin
│   └── ... (other variants)
└── README.md
```

## 🔧 Updating Firmware

When you release a new version:

1. **Build the firmware** with your updated code
2. **Copy new binaries** to `web-flasher/firmware/`
3. **Update version** in manifest JSON files
4. **Commit and push** to GitHub (if using GitHub Pages)

## 🎨 Customization

### Branding

Edit `index.html` to customize:
- Logo (change the emoji or add an image)
- Colors (CSS variables in `<style>` section)
- Text and descriptions
- Links to your documentation

### Add More Variants

1. **Create a new manifest** in `manifests/` (e.g., `snoled_custom.json`)
2. **Add a version card** in `index.html`:
   ```html
   <div class="version-card">
     <h3>🔷 Custom Board</h3>
     <p><strong>For:</strong> Your custom board</p>
     <esp-web-install-button manifest="./manifests/snoled_custom.json">
       <button slot="activate">Install Custom</button>
     </esp-web-install-button>
   </div>
   ```

## 📦 Automating Firmware Builds

Create a GitHub Actions workflow to automatically build and update firmware:

```yaml
# .github/workflows/build-firmware.yml
name: Build SNOLED Firmware
on:
  push:
    branches: [main]
  release:
    types: [published]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
      - name: Install PlatformIO
        run: pip install platformio
      - name: Build firmware
        run: |
          pio run -e snoled_esp32
          pio run -e snoled_esp8266
      - name: Copy firmware
        run: |
          mkdir -p web-flasher/firmware
          cp .pio/build/snoled_esp32/*.bin web-flasher/firmware/
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./web-flasher
```

## 🌐 Browser Compatibility

Web Serial API is required:
- ✅ Chrome 89+
- ✅ Edge 89+
- ✅ Opera 75+
- ❌ Firefox (not supported)
- ❌ Safari (not supported)

## 🔒 Security Notes

- HTTPS is **required** for Web Serial API
- GitHub Pages provides HTTPS automatically
- For local testing, use self-signed certificates
- Never commit sensitive credentials to the repository

## 📚 Resources

- [ESP Web Tools Documentation](https://esphome.github.io/esp-web-tools/)
- [Web Serial API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Serial_API)
- [WLED Install Guide](https://install.wled.me) (reference)

## ⚙️ Advanced: Custom Flasher Script

For automated firmware copying, create `web-flasher/update-firmware.sh`:

```bash
#!/bin/bash
# Copy firmware from PlatformIO build directory to web flasher

PIO_BUILD=".pio/build"
FIRMWARE_DIR="web-flasher/firmware"

mkdir -p "$FIRMWARE_DIR"

# ESP32
cp "$PIO_BUILD/snoled_esp32/firmware.bin" "$FIRMWARE_DIR/snoled_esp32.bin"
cp "$PIO_BUILD/snoled_esp32/bootloader.bin" "$FIRMWARE_DIR/snoled_esp32_bootloader.bin"
cp "$PIO_BUILD/snoled_esp32/partitions.bin" "$FIRMWARE_DIR/snoled_esp32_partitions.bin"
cp ~/.platformio/packages/framework-arduinoespressif32/tools/partitions/boot_app0.bin "$FIRMWARE_DIR/snoled_esp32_boot_app0.bin"

# ESP8266
cp "$PIO_BUILD/snoled_esp8266/firmware.bin" "$FIRMWARE_DIR/snoled_esp8266.bin"

echo "Firmware files updated!"
```

Make it executable: `chmod +x web-flasher/update-firmware.sh`

## 📝 License

Same license as your SNOLED project.
