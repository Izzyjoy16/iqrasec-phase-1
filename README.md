# IqraSec Academy — Phase 1 Cybersecurity Scripting & Automation

This repository contains two functional cybersecurity scripting and automation tools developed as part of the **IqraSec Academy Cybersecurity Scripting & Automation Internship — Phase 1**.

The project demonstrates practical use of **Bash and Python** for cybersecurity monitoring, system security checks, and file integrity verification.

## Project Structure

```text
iqrasec-phase-1/
├── Bash-Tool/
│   ├── tool.sh
│   ├── README.md
│   └── screenshots/
│
├── Python-Tool/
│   ├── tool.py
│   ├── README.md
│   └── screenshots/
│
└── .gitignore
```

## Tools

### 1. Linux Security Checker — Bash

A Bash-based security assessment tool that performs several local Linux security checks.

Features include:

* User and privilege information
* System information
* Listening port detection
* Firewall status checks
* SSH configuration checks
* Failed authentication checks
* World-writable file detection

**Location:** `Bash-Tool/`

See the [Bash Tool README](Bash-Tool/README.md) for detailed documentation.

### 2. Python File Integrity Checker

A Python-based file integrity monitoring tool that uses **SHA-256 cryptographic hashes** to detect changes to monitored files.

It can identify:

* Unchanged files
* Modified files
* New files
* Missing files

**Location:** `Python-Tool/`

See the [Python Tool README](Python-Tool/README.md) for detailed documentation.

## Testing

Both tools were tested in a Kali Linux environment.

The Python File Integrity Checker was specifically tested against all four supported integrity states:

* Unchanged
* Modified
* New
* Missing

Screenshots documenting the tools and testing process are included in each project's `screenshots/` directory.

## Technologies

* Bash
* Python 3
* Linux
* SHA-256
* Git
* GitHub

## Purpose

The purpose of this project is to demonstrate practical cybersecurity scripting, automation, system monitoring, file integrity verification, documentation, and version-control skills.

## Security Disclaimer

These tools are intended for authorized cybersecurity testing, defensive security, educational, and laboratory purposes.

Only use them on systems and files that you own or have explicit permission to assess.

## Author

**Amusan Israel**

Cybersecurity Learner | Security Automation | Vulnerability Assessment
