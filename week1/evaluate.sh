#! /bin/bash
set -euxo pipefail
shopt -s extglob
exec 3>&1 4>&2 # link file descriptors 3 and 4 to original stdout and stderr

readonly line_pattern='^[0-9]+ [0-9]+$'

# output starts with table header
echo "Dataset Language      Runtime N50"
echo "---------------------------------"

# run python and codon scripts to fill in the table
for ((i = 1; i <= 1; i++)); do 
    str="data$i   python        "
    # run the python script while storing the runtime in a text file
    python_output=$( /usr/bin/time -f "%E" -o time_output.txt python3 ./code/main.py ./data/data$i 2>&4 )
    python_time=$(<time_output.txt)
    str="$str$python_time    "
    
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
		str="$str$second"
		break
	    fi    
	fi
    done <<< $python_output
    echo $str
done
