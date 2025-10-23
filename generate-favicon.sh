#!/usr/bin/env bash

set -euo pipefail

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

# Default values
SOURCE_FILE=""
OUTPUT_FOLDER="favicon"

# Function to print colored messages
print_error() {
    echo -e "${RED}Error: $1${NC}" >&2
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}→ $1${NC}"
}

# Function to display usage
usage() {
    cat << EOF
Usage: generate-favicon --source=<svg-file> [--folder=<output-folder>]

Generate favicon files from an SVG source file.

Options:
  --source=FILE    Source SVG file (required)
  --folder=DIR     Output folder (default: favicon)
  -h, --help       Display this help message

Example:
  generate-favicon --source=icon.svg --folder=favicon

Generated files:
  - apple-touch-icon.png (180x180)
  - favicon-96x96.png
  - favicon.ico
  - favicon.svg
  - web-app-manifest-192x192.png
  - web-app-manifest-512x512.png
  - site.webmanifest
EOF
    exit 0
}

# Parse command line arguments
parse_args() {
    if [[ $# -eq 0 ]]; then
        usage
    fi

    for arg in "$@"; do
        case $arg in
            --source=*)
                SOURCE_FILE="${arg#*=}"
                shift
                ;;
            --folder=*)
                OUTPUT_FOLDER="${arg#*=}"
                shift
                ;;
            -h|--help)
                usage
                ;;
            *)
                print_error "Unknown option: $arg"
                echo "Use --help for usage information."
                exit 1
                ;;
        esac
    done
}

# Validate dependencies
check_dependencies() {
    local missing_deps=()

    if ! command -v inkscape &> /dev/null && ! command -v rsvg-convert &> /dev/null; then
        missing_deps+=("inkscape or rsvg-convert")
    fi

    if ! command -v convert &> /dev/null; then
        missing_deps+=("imagemagick (convert)")
    fi

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        echo ""
        echo "Install them with:"
        echo "  Ubuntu/Debian: sudo apt-get install inkscape imagemagick"
        echo "  macOS:         brew install librsvg imagemagick"
        echo "  Fedora/RHEL:   sudo dnf install librsvg2-tools imagemagick"
        exit 1
    fi
}

# Validate input
validate_input() {
    if [[ -z "$SOURCE_FILE" ]]; then
        print_error "Source file is required."
        echo "Use --help for usage information."
        exit 1
    fi

    if [[ ! -f "$SOURCE_FILE" ]]; then
        print_error "Source file '$SOURCE_FILE' does not exist."
        exit 1
    fi

    if [[ ! "$SOURCE_FILE" =~ \.svg$ ]]; then
        print_error "Source file must be an SVG file."
        exit 1
    fi
}

# Convert SVG to PNG at specified size
svg_to_png() {
    local input="$1"
    local output="$2"
    local size="$3"

    if command -v inkscape &> /dev/null; then
        inkscape "$input" --export-filename="$output" \
            --export-width="$size" --export-height="$size" &> /dev/null
    elif command -v rsvg-convert &> /dev/null; then
        rsvg-convert "$input" -w "$size" -h "$size" -o "$output"
    else
        print_error "No SVG converter found (tried inkscape and rsvg-convert)"
        exit 1
    fi
}

# Generate site.webmanifest
generate_webmanifest() {
    local output_file="$1"
    
    cat > "$output_file" << 'EOF'
{
  "name": "",
  "short_name": "",
  "icons": [
    {
      "src": "/web-app-manifest-192x192.png",
      "sizes": "192x192",
      "type": "image/png",
      "purpose": "any"
    },
    {
      "src": "/web-app-manifest-512x512.png",
      "sizes": "512x512",
      "type": "image/png",
      "purpose": "any"
    }
  ],
  "theme_color": "#ffffff",
  "background_color": "#ffffff",
  "display": "standalone"
}
EOF
}

# Main execution
main() {
    parse_args "$@"
    
    print_info "Checking dependencies..."
    check_dependencies
    
    print_info "Validating input..."
    validate_input
    
    # Create output folder
    if [[ -d "$OUTPUT_FOLDER" ]]; then
        print_info "Output folder '$OUTPUT_FOLDER' already exists. Files will be overwritten."
    else
        mkdir -p "$OUTPUT_FOLDER"
        print_success "Created output folder: $OUTPUT_FOLDER"
    fi
    
    # Copy source SVG
    print_info "Copying source SVG..."
    cp "$SOURCE_FILE" "$OUTPUT_FOLDER/favicon.svg"
    print_success "favicon.svg"
    
    # Generate PNG files
    print_info "Generating PNG files..."
    
    svg_to_png "$SOURCE_FILE" "$OUTPUT_FOLDER/apple-touch-icon.png" 180
    print_success "apple-touch-icon.png (180x180)"
    
    svg_to_png "$SOURCE_FILE" "$OUTPUT_FOLDER/favicon-96x96.png" 96
    print_success "favicon-96x96.png (96x96)"
    
    svg_to_png "$SOURCE_FILE" "$OUTPUT_FOLDER/web-app-manifest-192x192.png" 192
    print_success "web-app-manifest-192x192.png (192x192)"
    
    svg_to_png "$SOURCE_FILE" "$OUTPUT_FOLDER/web-app-manifest-512x512.png" 512
    print_success "web-app-manifest-512x512.png (512x512)"
    
    # Generate favicon.ico (multi-resolution)
    print_info "Generating favicon.ico..."
    
    # Create temporary PNGs for .ico file
    local temp_16="$OUTPUT_FOLDER/.temp_16.png"
    local temp_32="$OUTPUT_FOLDER/.temp_32.png"
    local temp_48="$OUTPUT_FOLDER/.temp_48.png"
    
    svg_to_png "$SOURCE_FILE" "$temp_16" 16
    svg_to_png "$SOURCE_FILE" "$temp_32" 32
    svg_to_png "$SOURCE_FILE" "$temp_48" 48
    
    # Combine into multi-resolution .ico file
    convert "$temp_16" "$temp_32" "$temp_48" "$OUTPUT_FOLDER/favicon.ico"
    
    # Clean up temporary files
    rm -f "$temp_16" "$temp_32" "$temp_48"
    print_success "favicon.ico (16x16, 32x32, 48x48)"
    
    # Generate site.webmanifest
    print_info "Generating site.webmanifest..."
    generate_webmanifest "$OUTPUT_FOLDER/site.webmanifest"
    print_success "site.webmanifest"
    
    echo ""
    print_success "All favicon files generated successfully in '$OUTPUT_FOLDER/'!"
    echo ""
    echo "Add these to your HTML <head>:"
    echo '  <link rel="icon" type="image/svg+xml" href="/favicon/favicon.svg">'
    echo '  <link rel="icon" type="image/png" sizes="96x96" href="/favicon/favicon-96x96.png">'
    echo '  <link rel="apple-touch-icon" sizes="180x180" href="/favicon/apple-touch-icon.png">'
    echo '  <link rel="manifest" href="/favicon/site.webmanifest">'
}

main "$@"
