#! /bin/bash

# servet name and kernel version and current users to be added.

echo "********* Server status **********"

# Operating system
operating_system=$(uname -o )

echo "Operatin System:"

echo " >> $operating_system"
 
echo ""

# kernel Version
kernel_Version=$(uname -v)
echo "Kernel Version:"

echo " >> $kernel_Version"
 
echo ""


# kernel release
kernel_release=$(uname -r )
echo "Kernel Release:"

echo " >> $kernel_release"
 
echo ""

# Current user

current_user=$(whoami)

echo "current user:"

echo " >> $current_user"
 
echo ""

# Total CPU usage

Total_CPU_usage=$(top -bn1 | grep "Cpu(s)" | sed 's/.*, *\([0-9.]*\)%* id.*/\1/' | awk '{print 100 - $1 "%"}')

echo "The total CPU usage:"

echo " >> $Total_CPU_usage"
 
echo ""
#Total memory usage (Free vs Used including percentage)

Total_memory_usage=$(free -m | awk '/Mem:/ {used=$2-$7; printf "Used: %sMB | Free: %sMB | Usage: %.2f%%\n", used, $7, used/$2 * 100}')

echo "pelase find the Memory information below:"
echo " >> $Total_memory_usage" 

echo ""
#Total disk usage (Free vs Used including percentage)

Total_disk_usage=$(df -h --total | awk '/total/{printf "Used %s | Free: %s | Usage: %s \n",$3,$4,$5}')

echo "The Disk information is below:"
echo " >> $Total_disk_usage"

echo ""

#Top 5 processes by CPU usage

Top_five_pro_cpu=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6)

echo "Please find the Top 5 processes by CPU usage:" 
echo ""
echo "$Top_five_pro_cpu"
echo ""
#Top 5 processes by memory usage

Top_five_pro_mem=$(ps -eo pid,comm,%mem --sort=-%mem | head -n 6)
echo "Please find the Top 5 processes by memory usage:"
echo ""
echo "$Top_five_pro_mem"