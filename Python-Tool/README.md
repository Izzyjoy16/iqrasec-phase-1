
# Python File Integrity Checker

## Tool Name

Python File Integrity Checker

## Objective

A Python-based cybersecurity tool that monitors files and directories for unauthorized or unexpected changes using SHA-256 cryptographic hashes.

## Features

* Calculate SHA-256 hashes for files and directories
* Create a file integrity baseline
* Detect modified files
* Detect newly created files
* Detect missing files
* Identify unchanged files
* Command-line interface with help and usage information
* Basic error handling for missing or inaccessible files
* Clear security-focused output and summary

## Requirements

* Python 3
* Linux, macOS, or Windows
* No external Python libraries required

## How to Run

Make the tool executable:

```bash
chmod +x tool.py
```

Display the help menu:

```bash
./tool.py --help
```

Scan files and display their SHA-256 hashes:

```bash
./tool.py --scan .
```

Create a file integrity baseline:

```bash
./tool.py --baseline .
```

Check files against the existing baseline:

```bash
./tool.py --check .
```

## Command Options

| Option       | Description                                |
| ------------ | ------------------------------------------ |
| `--scan`     | Calculate and display SHA-256 hashes       |
| `--baseline` | Create a file integrity baseline           |
| `--check`    | Compare current files against the baseline |
| `--help`     | Display usage information                  |

## Example Usage

Create a baseline:

```bash
./tool.py --baseline .
```

After modifying a monitored file, run:

```bash
./tool.py --check .
```

The tool reports whether files are unchanged, modified, new, or missing.

## Example Output

```text
[MODIFIED]  /home/kali/iqrasec-phase-1/Python-Tool/test-file.txt
[UNCHANGED] /home/kali/iqrasec-phase-1/Python-Tool/tool.py

Unchanged files : 1
Modified files  : 1
New files       : 0
Missing files   : 0
```

## Challenges Faced

* Implementing SHA-256 hashing for files efficiently
* Handling both individual files and directories
* Comparing the current file state against a stored baseline
* Detecting modified, new, unchanged, and missing files
* Handling missing or invalid baseline files
* Preventing the generated baseline file from being included in integrity comparisons

## Future Improvements

* Add timestamped integrity reports
* Export results to CSV or JSON
* Add email or notification alerts
* Support scheduled integrity checks
* Add configurable baseline locations
* Integrate with SIEM platforms for centralized monitoring

## Tested Environment

* Kali Linux
* Python 3
* SHA-256 hashing

## Security Disclaimer

This tool is intended for authorized security monitoring, learning, and defensive cybersecurity activities. Only monitor files and systems that you own or have explicit permission to assess.

## Author

Amusan Israel Joy
IqraSec Academy — Cybersecurity Scripting & Automation Internship
Phase 1

