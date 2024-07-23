
## Advanced Domain Dorking and Shodan Search Tool

This Bash script provides a comprehensive and interactive way to perform Google Dorking and Shodan searches on a specified domain. It allows users to leverage both Google Dorks and Shodan's extensive search capabilities to gather information about a target domain.

### Features

1. **Interactive Menu System**: Choose between Google Dorking, Shodan Search, or both.
2. **Domain Validation**: Ensures the domain input is in a valid format.
3. **Automatic Google Dork File Download**: Automatically downloads the largest Google Dork file.
4. **Error Handling and Instructions**: Provides clear instructions if the dork file download fails.
5. **Concurrent Dork Checks**: Uses background jobs for faster Google Dorking.
6. **Progress Bar**: Displays a progress bar for Google Dorking.
7. **User-Friendly**: Clear and concise prompts for user inputs and API key entry.

### Prerequisites

- `curl`: Ensure `curl` is installed on your system.
- **Optional**: Shodan API key if you wish to perform Shodan searches.

### Installation

Clone the repository and navigate to the directory:
```bash
git clone https://github.com/yourusername/dork-shodan-tool.git
cd dork-shodan-tool
```

### Usage

Run the script:
```bash
./dOrkinG.sh
```

Follow the interactive prompts to:
- Enter the target domain.
- Choose whether to use Google Dorking, Shodan Search, or both.
- If using Shodan, provide your Shodan API key when prompted.

### Example

```bash
Enter the target domain: example.com
Select an option:
1. Google Dorking
2. Shodan Search
3. Both
Enter your choice (1/2/3): 3
Downloading Google Dork file...
Google Dork file downloaded successfully.
Starting Google Dork search for domain: example.com
Progress: 10% (5/50) complete
...
Google Dork search completed.
Enter your Shodan API key: ************
Shodan search - Status: Success
```

### Note

- Ensure you have appropriate permissions to test the target domain.
- Use this tool responsibly and adhere to legal and ethical guidelines.

### Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

### License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

### Disclaimer

This tool is intended for educational purposes only. The authors are not responsible for any misuse or damage caused by this tool.

---

This description provides a comprehensive overview of the tool, including features, prerequisites, installation instructions, usage examples, and legal disclaimers.
