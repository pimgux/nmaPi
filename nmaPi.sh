#!/bin/bash

#---------------------------------------------
#Network Interface: eth0, wlan0 
ifc=wlan0 
#Turn Macchanger ON/OFF: 0-1
mac=0
#Define the range of network: .1/24, .1/16, .*
range=".1/24" 
range2="-254"
#---------------------------------------------

cat logo

#....Led's Power Up and Test .................
echo 17 > /sys/class/gpio/export
echo 27 > /sys/class/gpio/export
echo 22 > /sys/class/gpio/export

echo out > /sys/class/gpio/gpio17/direction
echo out > /sys/class/gpio/gpio27/direction
echo out > /sys/class/gpio/gpio22/direction


echo 1 > /sys/class/gpio/gpio27/value
	sleep 1
echo 1 > /sys/class/gpio/gpio17/value
	sleep 1
echo 1 > /sys/class/gpio/gpio22/value
	sleep 3

echo 0 > /sys/class/gpio/gpio17/value
echo 0 > /sys/class/gpio/gpio22/value
echo 0 > /sys/class/gpio/gpio27/value
#..................................../

if [ ${mac} -eq 1 ] 
then
	echo "- Macchanger ON :)  "
	ifconfig $ifc down
	sleep 5
	macchanger -a $ifc
	sleep 5
	ifconfig $ifc up
	sleep 5
else
	echo "- Macchanger OFF :( - "
fi

ip1=$(ip -f inet addr show dev $ifc | sed -n 's/^ *inet *\([.0-9]*\).*/\1/p' | awk -F. ' {print $1"."$2"."$3"."} ' )
ip2=${ip1}${range}
echo ""
echo "- The IP The network ip is: ${ip2} -"
echo ""
	echo 1 > /sys/class/gpio/gpio27/value

case $1 in
	1) 
		echo "Making a quick scanning"
			echo 0 > /sys/class/gpio/gpio17/value ;
		nmap -T4 -F ${ip2} -oN /tmp/out ;
			echo 1 > /sys/class/gpio/gpio17/value ;
		sleep 4
	;;

	2) 
		echo "Making a deep scanning"
			echo 0 > /sys/class/gpio/gpio17/value ;
		nmap -T4 -A -V -PE -PS22,25,80,3389 ${ip2} -oN /tmp/out2 ;
			echo 1 > /sys/class/gpio/gpio17/value ;
		sleep 4
	;;

	3) 
		echo "Making a silent scanning"
			echo 0 > /sys/class/gpio/gpio17/value ;
		nmap -sS -sU -T4 -A -v -PE -PP -PS80,443 -PA3389 -PU40125 -PY -g 53 ${ip2} -oN /tmp/out3 ;
			echo 1 > /sys/class/gpio/gpio17/value ;
		sleep 4
	;;

	4) 
		echo "
			Automatic Nmap for Raspberry Pi
			-------------------------------
					by Pimux & Qbit
			
		Use ./nmapi.sh [option]

		-h - This Help.

		-f - Fast Scan.
		-d - Deep Scan {Default Option}.
		-q - Quiet Scan."

		exit
	;;

	*) 
		echo "Invalid Option. Use -h for help
			" 
		exit
	;;
esac

	echo "
End Scan"

echo "Generating log..."
touch ./map.txt
date >map.txt
cat /tmp/out* >> ./map.txt
rm /tmp/out*

	echo 1 > /sys/class/gpio/gpio22/value

echo "			----Happy Hacking----   :)"
sleep 1

#-----Confirmation LED's ------------
echo 1 > /sys/class/gpio/gpio27/value
echo 1 > /sys/class/gpio/gpio17/value
echo 1 > /sys/class/gpio/gpio22/value
	sleep 1

echo 0 > /sys/class/gpio/gpio27/value
echo 0 > /sys/class/gpio/gpio17/value
echo 0 > /sys/class/gpio/gpio22/value
	sleep 1

echo 1 > /sys/class/gpio/gpio27/value
echo 1 > /sys/class/gpio/gpio17/value
echo 1 > /sys/class/gpio/gpio22/value
	sleep 1

echo 0 > /sys/class/gpio/gpio27/value
echo 0 > /sys/class/gpio/gpio17/value
echo 0 > /sys/class/gpio/gpio22/value
	sleep 1

echo 1 > /sys/class/gpio/gpio27/value
echo 1 > /sys/class/gpio/gpio17/value
echo 1 > /sys/class/gpio/gpio22/value
	sleep 1

echo 0 > /sys/class/gpio/gpio27/value
echo 0 > /sys/class/gpio/gpio17/value
echo 0 > /sys/class/gpio/gpio22/value
	sleep 1

echo 1 > /sys/class/gpio/gpio27/value
echo 1 > /sys/class/gpio/gpio17/value
echo 1 > /sys/class/gpio/gpio22/value
	sleep 1

echo 0 > /sys/class/gpio/gpio27/value
echo 0 > /sys/class/gpio/gpio17/value
echo 0 > /sys/class/gpio/gpio22/value
	sleep 1
#-----------------------------------/
exit