#! /bin/bash
set -euxo pipefail
shopt -s extglob

readonly line_pattern='^[0-9]+ [0-9]+$'

for ((i = 1; i <= 1; i++)); do 
    echo -n "data$i   python        "
    time python_output=`python3 ./code/main.py ./data/data$i`
    echo -n "    "
    
    # first loop calculates total genome length
    sum=0
    while read line; do
	# check that the line describes a contig length
	if [[ $line =~ $line_pattern ]]; then
	    read -r first second <<< "$line" # separate the two numbers	
	    sum=$((sum + second)) # add the contig length to the running total
	fi
    done <<< $python_output
    target=$((sum / 2))

    # second loop finds N50
    sum2=0
    while read line; do
	# check that the line describes a contig length
	if [[ $line =~ $line_pattern ]]; then
	    read -r first second <<< "$line" # separate the two numbers
    	    sum2=$((sum2 + second))
	    if [[ $sum2 > $target ]]; then
		echo $second
		break
	    fi    
	fi
    done <<< $python_output
done
