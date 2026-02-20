#!/bin/bash

# ================================
# System Monitoring Tool - Bash
# ================================

LOGFILE="system_report.log"

CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# -------------------------
# Function: Check CPU Usage
# -------------------------
check_cpu() {
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}' | cut -d'.' -f1)
    echo "CPU Usage: $CPU_USAGE%" | tee -a $LOGFILE

    if [ "$CPU_USAGE" -ge 90 ]; then
        echo -e "${RED}CRITICAL: CPU usage extremely high!${NC}" | tee -a $LOGFILE
    elif [ "$CPU_USAGE" -ge 80 ]; then
        echo -e "${YELLOW}WARNING: CPU usage high!${NC}" | tee -a $LOGFILE
    else
        echo -e "${GREEN}INFO: CPU usage normal${NC}" | tee -a $LOGFILE
    fi
    echo "" | tee -a $LOGFILE
}

# -------------------------
# Function: Check Memory Usage
# -------------------------
check_memory() {
    MEM_USAGE=$(free | awk '/Mem/ {printf("%.0f"), $3/$2 * 100}')
    echo "Memory Usage: $MEM_USAGE%" | tee -a $LOGFILE

    if [ "$MEM_USAGE" -ge 90 ]; then
        echo -e "${RED}CRITICAL: Memory usage extremely high!${NC}" | tee -a $LOGFILE
    elif [ "$MEM_USAGE" -ge 80 ]; then
        echo -e "${YELLOW}WARNING: Memory usage high!${NC}" | tee -a $LOGFILE
    else
        echo -e "${GREEN}INFO: Memory usage normal${NC}" | tee -a $LOGFILE
    fi
    echo "" | tee -a $LOGFILE
}

# -------------------------
# Function: Check Disk Usage
# -------------------------
check_disk() {
    DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
    echo "Disk Usage: $DISK_USAGE%" | tee -a $LOGFILE

    if [ "$DISK_USAGE" -ge 90 ]; then
        echo -e "${RED}CRITICAL: Disk usage extremely high!${NC}" | tee -a $LOGFILE
    elif [ "$DISK_USAGE" -ge 80 ]; then
        echo -e "${YELLOW}WARNING: Disk usage high!${NC}" | tee -a $LOGFILE
    else
        echo -e "${GREEN}INFO: Disk usage normal${NC}" | tee -a $LOGFILE
    fi
    echo "" | tee -a $LOGFILE
}

# -------------------------
# Function: Top Processes
# -------------------------
check_top_processes() {
    echo "Top 5 Processes by CPU:" | tee -a $LOGFILE
    ps -eo comm,%cpu --sort=-%cpu | head -n 6 | tee -a $LOGFILE
    echo "" | tee -a $LOGFILE
}

# -------------------------
# Function: System Uptime
# -------------------------
check_uptime() {
    UPTIME=$(uptime -p)
    echo "System Uptime: $UPTIME" | tee -a $LOGFILE
    echo "" | tee -a $LOGFILE
}

# -------------------------
# Function: Logged-in Users
# -------------------------
check_users() {
    echo "Logged in Users:" | tee -a $LOGFILE
    who | awk '{print $1}' | sort | uniq | tee -a $LOGFILE
    echo "" | tee -a $LOGFILE
}

# -------------------------
# Function: Generate Full Report
# -------------------------
generate_report() {
    echo "===== System Health Report =====" | tee -a $LOGFILE
    echo "Date: $(date)" | tee -a $LOGFILE
    echo "" | tee -a $LOGFILE

    check_cpu
    check_memory
    check_disk
    check_top_processes
    check_uptime
    check_users

    echo "================================" | tee -a $LOGFILE
}

# -------------------------
# Menu System
# -------------------------
show_menu() {
    echo "=============================="
    echo "   System Monitoring Tool"
    echo "=============================="
    echo "1. Generate System Report"
    echo "2. View Last Report"
    echo "3. Clear Report Log"
    echo "4. Exit"
    echo "=============================="

    read -p "Enter your choice: " choice

    case $choice in
        1) generate_report ;;
        2) cat $LOGFILE ;;
        3) > $LOGFILE; echo "Log file cleared." ;;
        4) exit 0 ;;
        *) echo "Invalid choice" ;;
    esac
}

# -------------------------
# Main Loop
# -------------------------
while true
do
    show_menu
    echo ""
done
