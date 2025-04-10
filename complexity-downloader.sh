#!/bin/bash
# complexity-downloader.sh - Downloads and extracts the latest Complexity Chrome extension
set -e

# Function to display usage information
display_help() {

  cat << EOF
complexity-downloader.sh - Downloads and extracts the latest Complexity Chrome extension

Usage: $(basename "$0") [options]

Options:
  -h, --help        Display this help message and exit

Environment variables:
  COMPLEXITY_DOWNLOAD_DIR   Override the download directory (default: ~/Downloads)
  COMPLEXITY_EXTRACT_DIR    Override the extraction directory (default: ~/complexity)

Example:
  COMPLEXITY_EXTRACT_DIR=~/custom/path $(basename "$0")
EOF
  exit 0
}

# Process command line arguments
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  display_help
fi

# Configuration
REPO="pnd280/complexity"
DOWNLOAD_DIR="${HOME}/Downloads"  # Default download directory
EXTRACT_DIR="${HOME}/complexity"   # Default extraction directory

# Allow overriding defaults through environment variables
CRX_TMP="${COMPLEXITY_DOWNLOAD_DIR:-$DOWNLOAD_DIR}/complexity.crx"
TARGET_DIR="${COMPLEXITY_EXTRACT_DIR:-$EXTRACT_DIR}"

# The GitHub API endpoint for the latest release
API_URL="https://api.github.com/repos/$REPO/releases/latest"

echo "=== Complexity Extension Downloader ==="
echo "Download directory: $(dirname "$CRX_TMP")"
echo "Extraction directory: $TARGET_DIR"


echo "Fetching the latest release info from GitHub..."
# Check for required dependencies
if ! command -v curl >/dev/null 2>&1; then

  echo "Error: curl is not installed. Please install curl to download files."
  exit 1

fi


# Use jq if available, otherwise show error

if command -v jq >/dev/null 2>&1; then
    RELEASE_INFO=$(curl -s "$API_URL")
    if [ $? -ne 0 ]; then
        echo "Error: Failed to fetch release information."
        exit 1
    fi

    CRX_URL=$(echo "$RELEASE_INFO" | jq -r '.assets | map(select(.name | endswith(".crx"))) | max_by(.created_at) | .browser_download_url')
    RELEASE_VERSION=$(echo "$RELEASE_INFO" | jq -r '.tag_name')
    echo "Found version: $RELEASE_VERSION"
else
    echo "Error: jq is not installed. Please install jq to parse JSON responses."
    echo "You can install jq using your package manager, e.g., 'sudo apt-get install jq'"
    exit 1
fi

if [ -z "$CRX_URL" ]; then
    echo "Error: No CRX asset found in the latest release."
    exit 1
fi

echo "Latest CRX URL: $CRX_URL"


# Create directories if they don't exist
mkdir -p "$(dirname "$CRX_TMP")"

echo "Downloading CRX asset from: $CRX_URL"
curl -L -o "$CRX_TMP" "$CRX_URL"

# Remove previous extraction directory if it exists
if [ -d "$TARGET_DIR" ]; then
    echo "Removing existing extraction directory..."
    rm -rf "$TARGET_DIR"
fi

# Remove tmp directory created by uncrx.py, usually it is the same as the name of the crx file, but without extension
if [ -d "${CRX_TMP%.crx}" ]; then
    echo "Removing existing tmp directory..."
    rm -rf "${CRX_TMP%.crx}"
fi


# Create target directory
mkdir -p "$TARGET_DIR"

echo "Unzipping the archive to $TARGET_DIR..."
# Check if uncrx.py is in current directory, otherwise download it
if [ -f "./uncrx.py" ]; then
    echo "uncrx.py found in the current directory. Using it..."
else
    echo "uncrx.py not found in the current directory. Downloading..."
    UNCRX_URL="https://raw.githubusercontent.com/Poikilos/uncrx/refs/heads/master/uncrx.py"
    curl -L -o "./uncrx.py" "$UNCRX_URL"
fi

# Check if python is available
if ! command -v python >/dev/null 2>&1; then
    echo "Error: python is not installed. Please install python to extract the CRX file."

    exit 1
fi

echo "Extracting CRX file..."
python ./uncrx.py "$CRX_TMP"

# delete complexity.crx files
echo "Cleaning up downloaded files..."
rm -rf "$CRX_TMP"
rm -rf "$CRX_TMP".zip

# Move the extracted files to the target directory
mv "${CRX_TMP%.crx}"/* "$TARGET_DIR"

echo "Download and extraction complete. Files are in $TARGET_DIR"

# cleanup uncrx extraction files
echo "Cleaning up temporary files..."
rm -rf "${CRX_TMP%.crx}"

echo "✅ Completed successfully!"
