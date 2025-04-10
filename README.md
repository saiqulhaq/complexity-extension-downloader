# Complexity Extension Downloader

A utility script that seamlessly downloads and extracts the latest version of the Complexity Chrome extension for Perplexity AI. 
While the Complexity team diligently works to enhance and update their extension, 
there's often a delay before these updates reach the Chrome Web Store. 
This script bridges that gap, giving you immediate access to the most recent version directly 
from the official GitHub repository—saving you time and eliminating the wait for Chrome Web Store updates. 
Perfect for developers, power users, and anyone who wants to stay at the cutting edge of Perplexity's extension capabilities.

## Features

- ✅ Automatically fetches the latest release information from GitHub
- ✅ Downloads the CRX file directly from the official repository
- ✅ Extracts the contents with proper error handling
- ✅ Configurable download and extraction paths
- ✅ Automatic dependency management (downloads required tools if needed)
- ✅ Comprehensive cleanup of temporary files


## Requirements

- Bash shell environment
- `curl` for downloading files
- `jq` for parsing JSON responses
- Python for CRX extraction

## Installation

```bash
# Clone the repository
git clone https://github.com/[your-username]/complexity-extension-downloader.git

# Navigate to the directory
cd complexity-extension-downloader

# Make the script executable
chmod +x complexity-downloader.sh
```

## Usage

### Basic Usage


Run the script without any arguments to download and extract using default settings:

```bash
./complexity-downloader.sh
```

By default, the CRX file will be downloaded to `~/Downloads/complexity.crx` and extracted to `~/complexity`.

### Customizing Paths

You can customize the download and extraction directories using environment variables:


```bash
# Change only the extraction directory

COMPLEXITY_EXTRACT_DIR=~/dev/extensions/complexity ./complexity-downloader.sh

# Change both directories

COMPLEXITY_DOWNLOAD_DIR=/tmp COMPLEXITY_EXTRACT_DIR=./extracted ./complexity-downloader.sh
```

## Troubleshooting

### Common Issues

- **Missing jq**: Install with your package manager (`apt install jq`, `brew install jq`, etc.)
- **Permission Denied**: Make sure you've made the script executable with `chmod +x`
- **Python Not Found**: Ensure Python is installed on your system

## License

This project is licensed under the [MIT License](LICENSE) - see the LICENSE file for details.

## Credits

- [pnd280/complexity](https://github.com/pnd280/complexity) - The official Complexity extension repository
- [Poikilos/uncrx](https://github.com/Poikilos/uncrx) - The tool used for CRX extraction

## Contributing

Contributions are welcome! Feel free to:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Disclaimer

This tool is not officially affiliated with Perplexity AI or the Complexity extension developers. 
It is provided for educational and development purposes only.
