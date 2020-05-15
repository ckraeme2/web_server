#!/bin/sh


SERVER=12
PORT=9898
THROWS=15
HAMMS=2
total=0



usage() {
	cat 1>&2 <<EOF
Usage: $(basename $0) [flags]
	
	-m [MACHINE NUMBER] 
	-p [PORT]
EOF
	exit $1

}
execute() {
	output=$(./bin/thor.py -t $THROWS -h $HAMMS http://student${SERVER}.cse.nd.edu:$PORT/text | tail -n 1 | grep -Eo "[[:digit:]].*"  )
}



		
smasher(){
	for i in {1..5}
	do
		execute
		total=$(echo "$output + $total" | bc)
	done

	echo "Using $HAMMS Hammers with $THROWS throws: $(echo "$total / 10" | bc -l) Seconds On Average"
	total=0
}

while [ $# -gt 0 ]; do
	case $1 in
		--help) usage 0;;
		-m) shift
			SERVER=$1 ;;
		-p) shift
			PORT=$1 ;;
	esac
	shift
done


for j in {1..15}
do
	smasher
	THROWS=$(echo "$THROWS + 3" | bc)
	HAMMS=$( echo "$HAMMS + 1" | bc) 
done
