#!/usr/bin/env python3

"""
IqraSec Academy - Phase 1
Python File Integrity Checker

Purpose:
    Monitor files using SHA-256 hashes and detect
    new, modified, unchanged, and missing files.
"""

import argparse
import hashlib
import json
import os
import sys


BASELINE_FILE = "baseline.json"


def calculate_hash(file_path):
    """Calculate the SHA-256 hash of a file."""

    sha256 = hashlib.sha256()

    try:
        with open(file_path, "rb") as file:
            while chunk := file.read(4096):
                sha256.update(chunk)

        return sha256.hexdigest()

    except PermissionError:
        print(f"[!] Permission denied: {file_path}")
        return None

    except OSError as error:
        print(f"[!] Error reading {file_path}: {error}")
        return None


def collect_hashes(path):
    """Collect SHA-256 hashes from a file or directory."""

    hashes = {}

    if os.path.isfile(path):
        file_hash = calculate_hash(path)

        if file_hash:
            hashes[os.path.abspath(path)] = file_hash

        return hashes

    if os.path.isdir(path):
        for root, directories, files in os.walk(path):
            for filename in files:

                # Skip the baseline file itself.
                if filename == BASELINE_FILE:
                    continue

                file_path = os.path.join(root, filename)
                file_hash = calculate_hash(file_path)

                if file_hash:
                    hashes[os.path.abspath(file_path)] = file_hash

        return hashes

    print(f"[!] Invalid path: {path}")
    sys.exit(1)


def create_baseline(path):
    """Create a JSON baseline containing file hashes."""

    hashes = collect_hashes(path)

    try:
        with open(BASELINE_FILE, "w") as file:
            json.dump(hashes, file, indent=4)

        print(f"[+] Baseline created successfully.")
        print(f"[+] Files recorded: {len(hashes)}")
        print(f"[+] Baseline file: {BASELINE_FILE}")

    except OSError as error:
        print(f"[!] Could not create baseline: {error}")
        sys.exit(1)


def load_baseline():
    """Load the saved baseline file."""

    if not os.path.isfile(BASELINE_FILE):
        print(f"[!] Baseline file '{BASELINE_FILE}' was not found.")
        print("[!] Create a baseline first using --baseline.")
        sys.exit(1)

    try:
        with open(BASELINE_FILE, "r") as file:
            return json.load(file)

    except (OSError, json.JSONDecodeError) as error:
        print(f"[!] Could not read baseline: {error}")
        sys.exit(1)


def check_integrity(path):
    """Compare current hashes against the saved baseline."""

    baseline = load_baseline()
    current = collect_hashes(path)

    print("[+] Integrity Check Results")
    print()

    unchanged = 0
    modified = 0
    new_files = 0
    missing = 0

    # Check files currently present.
    for file_path, current_hash in current.items():

        if file_path not in baseline:
            print(f"[NEW]       {file_path}")
            new_files += 1

        elif baseline[file_path] != current_hash:
            print(f"[MODIFIED]  {file_path}")
            modified += 1

        else:
            print(f"[UNCHANGED] {file_path}")
            unchanged += 1

    # Check files that existed in the baseline but are now missing.
    for file_path in baseline:

        if file_path not in current:
            print(f"[MISSING]   {file_path}")
            missing += 1

    print()
    print("==============================================")
    print("Integrity Check Summary")
    print("==============================================")
    print(f"Unchanged files : {unchanged}")
    print(f"Modified files  : {modified}")
    print(f"New files       : {new_files}")
    print(f"Missing files   : {missing}")
    print("==============================================")


def main():
    """Main program function."""

    parser = argparse.ArgumentParser(
        description="Monitor file integrity using SHA-256 hashes."
    )

    parser.add_argument(
        "path",
        help="File or directory to monitor"
    )

    group = parser.add_mutually_exclusive_group(required=True)

    group.add_argument(
        "--scan",
        action="store_true",
        help="Calculate and display SHA-256 hashes"
    )

    group.add_argument(
        "--baseline",
        action="store_true",
        help="Create a file integrity baseline"
    )

    group.add_argument(
        "--check",
        action="store_true",
        help="Compare current files against the baseline"
    )

    args = parser.parse_args()

    print("=" * 55)
    print("          PYTHON FILE INTEGRITY CHECKER")
    print("          IqraSec Academy - Phase 1")
    print("=" * 55)
    print()

    if args.scan:
        hashes = collect_hashes(args.path)

        for file_path, file_hash in hashes.items():
            print(f"[+] File: {file_path}")
            print(f"    SHA-256: {file_hash}")

    elif args.baseline:
        create_baseline(args.path)

    elif args.check:
        check_integrity(args.path)


if __name__ == "__main__":
    main()
