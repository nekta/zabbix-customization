#!/bin/bash 

function main() {
	IFS=$'\n'
	array=( `exec 3<>/dev/tcp/10.222.1.250/4730; echo -e "status" >&3; timeout 1 cat <&3 ;exec 3>&- `)
	#array=( `exec 3<>/dev/tcp/$1/$2; echo -e "status" >&3; timeout 1 cat <&3 ;exec 3>&- `)
	len=${#array[*]}
	i=0

	while [ $i -lt $len ]; do
		echo ${array[$i]} | awk '{ if ( ($2 > 0 && $4 == 0) || ($2 > $4*3) )  print "1" }'
		let i++
	done
}
VAR=$(main)

if  echo $VAR | grep 1 &>/dev/null ; then 
	echo "Check queue"
else 
	echo OK
fi
