#!/bin/bash

# Get OS version and kernel release
os_version=$(cat /etc/*-release | grep "PRETTY_NAME" | cut -d "=" -f 2-)
kernel_release=$(uname -r)

# Get hostname and internal IP address
hostname=$(hostname)
internal_ip=$(hostname -I | awk '{print $1}')

# Get memory usage percentage
mem_total=$(free -m | awk '/^Mem:/{print $2}')
mem_used=$(free -m | awk '/^Mem:/{print $3}')
mem_free=$(free -m | awk '/^Mem:/{print $4}')
mem_usage=$(echo "scale=2; $mem_used/$mem_total * 100" | bc)

# Get disk usage percentage
disk_usage=$(df -h / | awk '/\//{print $(NF-1)}')

# Get load average
load_average=$(uptime | awk -F'average: ' '{print $2}')

# Get system uptime
uptime=$(uptime | awk '{print $3,$4}' | sed 's/,//')

# Get CPU utilization percentage
cpu_usage=$(mpstat 1 1 | awk '$12 ~ /[0-9.]+/ { print 100 - $12"%" }')

# Get top 5 memory usage processes
mem_processes=$(ps aux --sort=-%mem | awk 'NR<=6{print $0}')

# Get top 5 CPU usage processes
cpu_processes=$(ps aux --sort=-%cpu | awk 'NR<=6{print $0}')

# Print system information with color coding
echo -e "\033[32mOS Version     : $os_version\033[0m"
echo -e "\033[32mKernel Release : $kernel_release\033[0m"
echo -e "\033[32mHostname       : $hostname\033[0m"
echo -e "\033[32mInternal IP    : $internal_ip\033[0m"
echo -e "\033[32mMemory Usage   : $mem_usage%\033[0m"
echo -e "\033[32mDisk Usage     : $disk_usage\033[0m"
echo -e "\033[32mLoad Average   : $load_average\033[0m"
echo -e "\033[32mSystem Uptime  : $uptime\033[0m"
echo -e "\033[32mCPU Utilization: $cpu_usage\033[0m"
echo -e "\033[32mTop 5 Memory Resource Hog Processes:\033[0m\n$mem_processes"
echo -e "\033[32mTop 5 CPU Resource Hog Processes:\033[0m\n$cpu_processes"

