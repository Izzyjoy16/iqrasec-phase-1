#!/bin/bash

# IqraSec Academy - Phase 1
# Linux Security Checker
# Purpose: Perform basic security checks on a Linux system.

# -----------------------------
# Colors
# -----------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# -----------------------------
# Help Function
# -----------------------------
show_help() {
    echo "Linux Security Checker"
    echo
    echo "Usage: $0 [OPTION]"
    echo
    echo "Options:"
    echo "  -a, --all       Run all security checks"
    echo "  -h, --help      Show this help message"
    echo
    echo "Example:"
    echo "  sudo $0 --all"
}

# -----------------------------
# Check Root Privileges
# -----------------------------
check_privileges() {
    echo -e "${BLUE}[+] Checking current user...${NC}"

    echo "User: $(whoami)"

    if [ "$EUID" -eq 0 ]; then
        echo -e "${GREEN}[+] Running with root privileges.${NC}"
    else
        echo -e "${YELLOW}[!] Running without root privileges.${NC}"
        echo "[!] Some checks may provide limited results."
    fi

    echo
}

# -----------------------------
# System Information
# -----------------------------
system_info() {
    echo -e "${BLUE}[+] System Information${NC}"

    echo "Hostname: $(hostname)"
    echo "Operating System: $(grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2- | tr -d '"')"
    echo "Kernel: $(uname -r)"
    echo "Architecture: $(uname -m)"
    echo
}

# -----------------------------
# Check Listening Ports
# -----------------------------
check_ports() {
    echo -e "${BLUE}[+] Checking Listening Ports${NC}"

    if command -v ss >/dev/null 2>&1; then
        ss -tuln
    else
        echo -e "${RED}[!] 'ss' command is not available.${NC}"
    fi

    echo
}

# -----------------------------
# Check Firewall
# -----------------------------
check_firewall() {
    echo -e "${BLUE}[+] Checking Firewall Status${NC}"

    if command -v ufw >/dev/null 2>&1; then
        status=$(ufw status 2>/dev/null)

        if echo "$status" | grep -qi "Status: active"; then
            echo -e "${GREEN}[+] UFW firewall is active.${NC}"
        else
            echo -e "${YELLOW}[!] UFW is installed but not active.${NC}"
        fi

        echo "$status"

    elif command -v firewall-cmd >/dev/null 2>&1; then
        status=$(firewall-cmd --state 2>/dev/null)

        if [ "$status" = "running" ]; then
            echo -e "${GREEN}[+] Firewalld is active.${NC}"
        else
            echo -e "${YELLOW}[!] Firewalld is installed but not running.${NC}"
        fi

    else
        echo -e "${YELLOW}[!] No supported firewall management tool detected.${NC}"
        echo "    UFW or firewalld can be installed if firewall management is required."
    fi

    echo
}

# -----------------------------
# Check SSH Configuration
# -----------------------------
check_ssh() {
    echo -e "${BLUE}[+] Checking SSH Configuration${NC}"

    if [ -f /etc/ssh/sshd_config ]; then

        echo "SSH configuration found."

        permit_root=$(grep -Ei '^[[:space:]]*PermitRootLogin' /etc/ssh/sshd_config | tail -1)

        if [ -n "$permit_root" ]; then
            echo "Root login setting: $permit_root"
        else
            echo "Root login setting: Default configuration"
        fi

        password_auth=$(grep -Ei '^[[:space:]]*PasswordAuthentication' /etc/ssh/sshd_config | tail -1)

        if [ -n "$password_auth" ]; then
            echo "Password authentication: $password_auth"
        else
            echo "Password authentication: Default configuration"
        fi

    else
        echo "SSH server configuration was not found."
    fi

    echo
}
# -----------------------------
# Check Failed Login Attempts
# -----------------------------
check_failed_logins() {
    echo -e "${BLUE}[+] Checking Failed Login Attempts${NC}"

    if command -v lastb >/dev/null 2>&1; then
        failed=$(lastb 2>/dev/null | head -10)

        if [ -n "$failed" ]; then
            echo "$failed"
        else
            echo "No failed login records found."
        fi

    elif [ -f /var/log/auth.log ]; then
        failed=$(grep -i "failed password" /var/log/auth.log 2>/dev/null | tail -10)

        if [ -n "$failed" ]; then
            echo "$failed"
        else
            echo "No failed password attempts found in auth.log."
        fi

    elif [ -f /var/log/secure ]; then
        failed=$(grep -i "failed password" /var/log/secure 2>/dev/null | tail -10)

        if [ -n "$failed" ]; then
            echo "$failed"
        else
            echo "No failed password attempts found in secure log."
        fi

    else
        echo -e "${YELLOW}[!] No supported authentication log source was found.${NC}"
    fi

    echo
}

# -----------------------------
# Check World-Writable Files
# -----------------------------
check_writable_files() {
    echo -e "${BLUE}[+] Checking World-Writable Files${NC}"

    echo "Searching common locations..."

    writable=$(find /tmp /var/tmp -type f -perm -0002 2>/dev/null | head -20)

    if [ -n "$writable" ]; then
        echo -e "${YELLOW}[!] World-writable files found:${NC}"
        echo "$writable"
    else
        echo -e "${GREEN}[+] No world-writable files found in checked locations.${NC}"
    fi

    echo
}

# -----------------------------
# Run All Checks
# -----------------------------
run_all_checks() {
    echo "=============================================="
    echo "        LINUX SECURITY CHECKER"
    echo "        IqraSec Academy - Phase 1"
    echo "=============================================="
    echo

    check_privileges
    system_info
    check_ports
    check_firewall
    check_ssh
    check_failed_logins
    check_writable_files

    echo "=============================================="
    echo "Security checks completed."
    echo "=============================================="
}

# -----------------------------
# Main Program
# -----------------------------
case "$1" in
    -a|--all)
        run_all_checks
        ;;
    -h|--help|"")
        show_help
        ;;
    *)
        echo -e "${RED}[!] Unknown option: $1${NC}"
        echo
        show_help
        exit 1
        ;;
esac
