# pdf-project
[![](https://jitpack.io/v/onelenyk/pdf-project.svg)](https://jitpack.io/#onelenyk/pdf-project)

pdf-project is a Kotlin-based command-line tool designed to convert project files into a comprehensive PDF document. This tool simplifies the process of creating project documentation by transforming code files and related content into a single, well-organized PDF.

## Features

- **Kotlin CLI**: Built with Kotlin, ensuring modern language features and robust performance.
- **File Conversion**: Converts project files to HTML and then compiles them into a single PDF.
- **Customizable Rules**: Allows custom rules for file filtering.
- **Automated Processing**: Efficiently processes files and directories.
- **Comprehensive Output**: Generates a detailed PDF document.

## Installation

### Installation through `install_pdfproject.sh`

Follow these steps to install `pdfproject` using the `install_pdfproject.sh` script. This method requires only the installation script.

#### Prerequisites
- Ensure Java is installed on your system.

#### Steps

1. **Download the Installation Script:**
   curl -L -o install_pdfproject.sh "https://raw.githubusercontent.com/onelenyk/pdf-project/master/install_pdfproject.sh"

2. **Make the Script Executable:**
   chmod +x install_pdfproject.sh

3. **Run the Installation Script:**
   ./install_pdfproject.sh

4. **Verify Installation:**
   pdfproject --version

#### Script Details
The `install_pdfproject.sh` script downloads the latest JAR file, creates an execution script, and optionally sets up a symbolic link for easy access.

#### Usage
Run `pdfproject --help` to see the available options and commands. For further assistance, refer to the project's issues page on GitHub.

## Contributions

Contributions are welcome! Please submit a pull request or open an issue for improvements or bug fixes.

## Documentation

For more detailed information, please visit our [documentation](https://javadoc.jitpack.io/dev/onelenyk/pdf-project/latest/javadoc/index.html).

## Acknowledgements

- **onelenyk** - Initial work and maintenance.
- **ChatGPT by OpenAI** - Assisted in development.

## License

This project is licensed under the [Apache License 2.0](LICENSE).
