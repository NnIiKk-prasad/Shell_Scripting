#! /bin/bash
# clear the screen
#clear
# Check OS Release Version and Name
echo -e "\033[32m --------------- OS Version -------------------------------------------------------\033[0m"
osversion=` cat /etc/redhat-release`
echo -e '\E[32m'"OS Release     :" $osversion
echo -e "\033[32m --------------------- Kernel Release ------------------------------------------------\033[0m"
# Check Kernel Release
kernelrelease=$(uname -r)
echo -e '\E[32m'"Kernel Release :" $kernelrelease
echo -e "\033[32m -----------------------------------------------------------------------------------\033[0m"
echo -e "\033[32m ----------------- Hostname of the Server ------------------------------------------\033[0m"
# Check hostname
echo -e '\E[32m'"Hostname       :" $HOSTNAME
echo -e "\033[32m -----------------------------------------------------------------------------------\033[0m"
# Check Internal IP
internalip=$(hostname -I)
echo -e '\E[32m'"Internal IP    :" $internalip
echo -e "\033[32m ------------------Memory Usage------------------------------------------------------\033[0m"
mem_TOTAL=`/usr/bin/free -m |awk '{print $2}' |head -2 | tail -1`
mem_AVAIL=`/usr/bin/free -m |awk '{print $7}' |head -2 | tail -1`
real_MEMUSED=`expr $mem_TOTAL - $mem_AVAIL`
real_MEMPRCNT=`expr $real_MEMUSED \* 100`
real_TOTMEMUSED=`echo "scale=2;  $real_MEMPRCNT / $mem_TOTAL" | bc -l`
MEM=`echo $real_TOTMEMUSED | awk -F. '{ print $1 }'`
echo -e '\E[32m'"Memory Usage is    :" $MEM
if [ $MEM -gt 90 ]
then
echo -e '\E[31m'"Memory Usage is Critical"
else
echo -e '\E[32m'"Memory Usage is OK"
fi
echo -e "\033[32m -------------------Disk Usage -----------------------------------------------------\033[0m"
dusage=$(df -Ph | grep -vE '^tmpfs|cdrom' | sed s/%//g | awk '{ if($5 > 60) print $0;}')
fscount=$(echo "$dusage" | wc -l)
if [ $fscount -ge 2 ]; then
echo -e '\E[32m'"$dusage"
echo -e '\E[31m'"Above partition breached threshold"
else
echo "Disk usage is in under threshold"
fi
echo -e "\033[32m -------------------Load Average-----------------------------------------------------\033[0m"
# Check Load Average
loadaverage=$(top -n 1 -b | grep "load average:" | awk '{print $10 $11 $12}')
echo -e '\E[32m'"Load Average :" $tecreset $loadaverage
echo -e "\033[32m -------------------Uptime-----------------------------------------------------------\033[0m"
# Check System Uptime
tecuptime=$(uptime | awk '{print $3,$4}' | cut -f1 -d,)
echo -e '\E[32m'"System Uptime Days/(HH:MM) :" $tecreset $tecuptime
echo -e "\033[32m ----------------CPU Utilizatio ------------------------------------------------------\033[0m"
CPU=`top -bn1 | grep load | awk '{printf "%.2f%%\t\t\n", $(NF-2)}'`
echo -e '\E[32m'"CPU Utilization :" $CPU

# Unset Variables
unset tecreset os architecture kernelrelease internalip externalip nameserver loadaverage
#--------Print top 5 Memory & CPU consumed process threads---------#
echo -e "\033[32m -------------------Top 5 Memory Process ----------------------------------------------\033[0m"
echo -e "\n\nTop 5 Memory Resource Hog Processes"
echo -e "$D$D"
echo -e "\033[32m -------------------Top 5 CPU Process -------------------------------------------------\033[0m"
ps -eo pmem,pid,ppid,user,stat --sort=-pmem|grep -v $$|head -6|sed 's/$/\n/'
echo -e "\nTop 5 CPU Resource Hog Processes"
echo -e "$D$D"
ps -eo pcpu,pid,ppid,user,stat,args --sort=-pcpu|grep -v $$|head -6|sed 's/$/\n/' | awk '{print $1"\t" $2"\t" $4"\t" $6}'
#CPU=`top -bn1 | grep load | awk '{printf "%.2f%%\t\t\n", $(NF-2)}'`
#echo -e '\E[32m'"CPU Utilization :" $CPU

