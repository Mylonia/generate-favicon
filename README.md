# generate-favicon

A script for generating all necessary favicon files from a single SVG source file.

## Features

- ✅ Generates all standard favicon formats and sizes
- ✅ Multi-resolution `.ico` file (16x16, 32x32, 48x48)
- ✅ Creates web app manifest with proper icon references
- ✅ Preserves SVG source for modern browsers
- ✅ Proper error handling and validation
- ✅ Colored terminal output for better UX
- ✅ Helpful HTML snippet generation

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

### Option 2: Manual Installation
1. Save the script as `generate-favicon`
2. Make it executable: `chmod +x generate-favicon`
3. Place it in your PATH or use with `./generate-favicon`

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

### Legacy Browsers

If you need to support very old browsers, also include:

```html
<link rel="shortcut icon" href="/favicon/favicon.ico">
```

## Web Manifest Configuration

The script generates a basic `site.webmanifest` file. You should customize it for your application:

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

## Best Practices for Source SVG

For optimal results, your source SVG should:

1. **Be square** - Favicons are square, so use a 1:1 aspect ratio
2. **Use simple shapes** - Complex details may not render well at small sizes
3. **Have good contrast** - Ensure visibility on light and dark backgrounds
4. **Be optimized** - Remove unnecessary metadata and compress the file
5. **Test at small sizes** - Preview how it looks at 16×16 and 32×32

### Recommended SVG Specifications

- **Dimensions:** 512×512 or larger (vector scales down better than up)
- **Stroke width:** At least 2-3px for visibility at small sizes
- **Safe area:** Keep important elements within the center 80%

## Troubleshooting

### Error: "Missing required dependencies"

Install the required tools using your package manager (see System Requirements).

### Error: "Source file does not exist"

Check that the file path is correct and the file exists. Use an absolute path if needed:

```bash
./generate-favicon --source=/full/path/to/icon.svg
```

### Error: "Source file must be an SVG file"

Ensure your source file has a `.svg` extension and is a valid SVG file.

### Blurry or pixelated output

This usually means your source SVG is too small or not properly vectorized. Use a larger SVG (512×512 or bigger) for best results.