#! /bin/bash
set -euxo pipefail
shopt -s extglob
exec 3>&1 4>&2 # link file descriptors 3 and 4 to original stdout and stderr

readonly line_pattern='^[0-9]+ [0-9]+$'
readonly codon_path="code/codon"
readonly python_path="code/python"
readonly data_path="data"

# Function definitions
# ---------------------------------------------------------

# First parameter $1 is index from 1 to 4
# Second parameter $2 is language name "python3" or "codon"
print_single_row () {
    str="data$1   $2        "
    # run the python or codon script while storing the runtime in a text file
    if [[ $2 == "python" ]]; then
        code_output=$( /usr/bin/time -f "%E" -o time_output.txt python3 $python_path/main.py $data_path/data$1 2>&4 )
    elif [[ $2 == "codon" ]]; then
	code_output=$( /usr/bin/time -f "%E" -o time_output.txt codon run -release $codon_path/main.py $data_path/data$1 2>&4 )
    fi
    running_time=$(<time_output.txt)
    str="$str$running_time    "
    
    # first loop calculates total genome length
    sum=0
    while read line; do
	# check that the line describes a contig length
	if [[ $line =~ $line_pattern ]]; then
	    read -r first second <<< "$line" # separate the two numbers	
	    sum=$((sum + second)) # add the contig length to the running total
	fi
    done <<< $code_output
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
    done <<< $code_output
    echo $str
}

# Main code
# -----------------------------------

# output starts with table header
echo "Dataset Language      Runtime N50"
echo "---------------------------------"

# run python and codon scripts to fill in the table
for ((i = 1; i <= 4; i++)); do 
    print_single_row $i "python"
    print_single_row $i "codon"
done

