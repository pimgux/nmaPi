#!/bin/bash

#--------------------------------------------
#Network Interface: eth0, wlan0 
ifc=wlan0 
#Turn Macchanger ON/OFF: 1/0
mac=0
#Define the range of network: .1/24, .1/16, .*
range="1/24" 
range2="1-254"
#--------------------------------------------

cat logo

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
ip3=${ip1}${range2}
echo ""
echo "- The ip The network is: ${ip2} | ${ip3} -"
echo ""
case $1 in
	-f) 
		echo "Making a fast scanning"
		nmap -T4 -F ${ip2} -oN /tmp/out ;
		sleep 4
	;;

	-d) 
		echo "Making a deep scanning"
		nmap -T4 -A -V -PE -PS22,25,80,3389 ${ip2} -oN /tmp/out2 ;
		sleep 4
	;;

	-q) 
		echo "Making a silent scanning"
		nmap -sS -sU -T4 -A -v -PE -PP -PS80,443 -PA3389 -PU40125 -PY -g 53 ${ip2} -oN /tmp/out3 ;
		sleep 4
	;;

	-h) 
		echo "
			Automatic Nmap for Raspberry Pi
			-------------------------------
					by Pimux & Qbit
			
		Use ./nmapi.sh [option]

		-h - This Help.

		-f - Fast Scan.
		-d - Deep Scan {Default Option}.
		-q - Quiet Scan.
		    "
		
		exit
	;;

	*) 
		echo "Invalid Option. Use -h for help" 
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

	
echo "			----Happy Hacking----	:)"
exit
