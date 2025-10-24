# generate-favicon

This script can help you generate different favicon files based on a single SVG you provide.

```bash
./generate-favicon --source=icon.svg
```

## Features

- ✅ Generates all standard favicon formats and sizes
- ✅ Multi-resolution `.ico` file (16x16, 32x32, 48x48)
- ✅ Creates web app manifest with proper icon references
- ✅ Preserves SVG source for modern browsers

## Generated Files

The script generates the following files:

| File | Size | Purpose |
|------|------|---------|
| `favicon.svg` | Vector | Modern browsers, scalable |
| `favicon.ico` | 16/32/48px | Legacy browser support |
| `favicon-96x96.png` | 96×96 | Standard favicon for most browsers |
| `apple-touch-icon.png` | 180×180 | iOS home screen icon |
| `web-app-manifest-192x192.png` | 192×192 | PWA icon (standard) |
| `web-app-manifest-512x512.png` | 512×512 | PWA icon (high-res) |
| `site.webmanifest` | JSON | Web app manifest file |

## System Requirements

### Required Dependencies

The script requires one SVG converter and ImageMagick:

**SVG Converter** (choose one):
- `inkscape` (recommended) - Full-featured SVG editor with CLI
- `rsvg-convert` (from librsvg) - Lightweight alternative

**Image Processing:**
- `imagemagick` - For creating multi-resolution `.ico` files

### Installation Instructions

#### macOS
```bash
brew install librsvg imagemagick
```

## Installation

### Option 1: Direct Download
```bash
# Download the script
wget https://raw.githubusercontent.com/Mylonia/generate-favicon/main/generate-favicon

# Make it executable
chmod +x generate-favicon

# Move to a directory in your PATH (optional)
sudo mv generate-favicon /usr/local/bin/
```

## Usage

### Basic Usage

```bash
# Generate favicons in default "favicon" folder
./generate-favicon --source=icon.svg

# Specify custom output folder
./generate-favicon --source=icon.svg --folder=public/icons
```

### Command-Line Options

```
--source=FILE    Source SVG file (required)
--folder=DIR     Output folder (default: favicon)
-h, --help       Display help message
```

### Complete Example

```bash
# Create favicons from your logo
./generate-favicon --source=logo.svg --folder=assets/favicon

# Output:
# ✓ Created output folder: assets/favicon
# ✓ favicon.svg
# ✓ apple-touch-icon.png (180x180)
# ✓ favicon-96x96.png (96x96)
# ✓ web-app-manifest-192x192.png (192x192)
# ✓ web-app-manifest-512x512.png (512x512)
# ✓ favicon.ico (16x16, 32x32, 48x48)
# ✓ site.webmanifest
```

## HTML Integration

After generating your favicons, add these tags to your HTML `<head>`:

```html
<link rel="icon" type="image/svg+xml" href="/favicon/favicon.svg">
<link rel="icon" type="image/png" sizes="96x96" href="/favicon/favicon-96x96.png">
<link rel="apple-touch-icon" sizes="180x180" href="/favicon/apple-touch-icon.png">
<link rel="manifest" href="/favicon/site.webmanifest">
```

## Web Manifest Configuration

The script only generates a basic `site.webmanifest` file. You should customize the `name`, `short_name` and color fields for your use case manually:

```json
{
  "name": "Your App Name",
  "short_name": "App",
  "icons": [
    {
      "src": "/favicon/web-app-manifest-192x192.png",
      "sizes": "192x192",
      "type": "image/png",
      "purpose": "any"
    },
    {
      "src": "/favicon/web-app-manifest-512x512.png",
      "sizes": "512x512",
      "type": "image/png",
      "purpose": "any"
    }
  ],
  "theme_color": "#ffffff",
  "background_color": "#ffffff",
  "display": "standalone"
}
```