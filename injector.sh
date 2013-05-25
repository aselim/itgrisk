#!/bin/bash

dialog --backtitle "itg-risk Injector" --title "About" --msgbox "This to inject nodes in itg-risk wargame\n\n Created by:Ahmed Atef @NU !" 10 33

dialog --backtitle "itg-risk Injector" --title "Setup LANS" --inputbox "Enter number of LANS" 8 60 2>lans.ir
lans=$(<lans.ir)
response=$?

rm subnet.ir

for (( i=1; i<=$lans; i++ ))
	do
		dialog --backtitle "itg-risk Injector" --title "Setup LANS" --inputbox "Enter the ip subnet to vlan $i" 8 60 2>>subnet.ir
		echo $'\n'>>subnet.ir
	done
subnet=$(<subnet.ir)
rm /home/ahmed/honey.conf
rm /home/ahmed/t
cp /home/ahmed/honeyd.conf /home/ahmed/honey.conf
touch /home/ahmed/t
farpd -i eth1 $subnet.0/24

sys_arr=( smtp msftp ms_smtp iis ssh vnc ldap r_telnet )
pwr=( 1 2 4 8 )
for (( i=1; i<=255; i++ ))
	do
		j=`for j in ${sys_arr[@]}; do echo $j; done|shuf|head -1`
                k=`for k in ${pwr[@]}; do echo $k; done|shuf|head -1`
		echo "|$subnet.$i|$j|$k|false|||">>/home/ahmed/t 
		echo "bind $subnet.$i $j">>/home/ahmed/honey.conf
	done
honeyd -d -f /home/ahmed/honey.conf -i eth1 $subnet.0/24
#for (( i=1; i<=$lans; i++ ))
#	do
#		ifconfig eth0:$i 10.10.10.10/24 up
#	done
