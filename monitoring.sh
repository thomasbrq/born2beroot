#!/bin/bash
archi=$(uname -a)
pcpu=$(grep "physical id" /proc/cpuinfo | sort -u | wc -l)
vcpu=$(grep -c "processor" /proc/cpuinfo)
memt=$(free -m | awk '$1 == "Mem:" {print $2}')
memu=$(free -m | awk '$1 == "Mem:" {print $3}')
prct=$(($memu*100/$memt))
dskt=$(df -Bm | awk '{s+=$4} END {print s}')
dskc=$(($dskt/1024))
dsku=$(df -Bm | awk '{s+=$3} END {print s}')
dskp=$(($dsku*100/$dskt))
cpul=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')
lstb=$(who -b | sed 's/system boot//g' | xargs)
lvmc=$(lsblk | grep "lvm" | wc -l)
lvme=$(if [ $lvmc == 0 ]; then echo no; else echo yes; fi)
ctcp=$(cat /proc/net/sockstat{,6} | awk '$1 == "TCP:" {print $3}')
usrs=$(users | wc -w)
ipv4=$(hostname -I)
macc=$(cat /sys/class/net/*/address | head -n 1)
sudo=$(journalctl -q _COMM=sudo | grep COMMAND | wc -l)
wall "
	#Architecture: $archi
	#CPU physical: $pcpu
	#vCPU: $vcpu
	#Memory Usage: $memu/$memt"MB" ($prct%)
	#Disk Usage: $dsku/$dskc"Gb" ($dskp%)
	#CPU load : $cpul
	#Last boot: $lstb
	#LVM use: $lvme
	#Connexions TCP: $ctcp ETABLISHED
	#User log: $usrs
	#Network: IP $ipv4 ($macc)
	#Sudo: $sudo cmd"
