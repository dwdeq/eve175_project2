#!/usr/bin/env bash
# quality_filter.sh
# Usage: ./quality_filter.sh <fastq_file> <minimum_average_quality>

if [ "$#" -ne 2 ]; then
	echo "Usage: $0 <fastq_file> <minimum_average_quality>" >&2
	exit 1
fi

fastq="$1"
minq="$2"

if [ ! -f "$fastq" ]; then
	echo "Error: file not found: $fastq" >&2
	exit 1
fi

if ! [[ "$minq" =~ ^[0-9]+$ ]]; then
	echo "Error: minimum_average_quality must be an integer" >&2
	exit 1
fi

case $fastq in
		*.fq|*.fastq) 
			cmd="cat $fastq"
			;;
		*.fq.gz|*.fastq.gz)
			cmd="zcat $fastq"
			;;
		*)
			echo "Error: please input a fastq file" >&2
			exit 1
			;;
esac

reads_before=0
reads_after=0

while IFS= read -r header && \
	  IFS= read -r seq && \
	  IFS= read -r plus && \
	  IFS= read -r qual; do

	((reads_before++))

	sum=0
	len=${#qual}
	for ((i=0; i < len; i++)); do
		c=${qual:i:1}
		score=$(printf '%d' "'${c}")
		sum=$((sum + score - 33))
	done

	avg=$((sum / len))

	if [ "$avg" -ge "$minq" ]; then
		((reads_after++))
		printf '%s\n%s\n%s\n%s\n' "$header" "$seq" "$plus" "$qual"
	fi

done < <($cmd)

echo "Reads before filtering: $reads_before" >&2
echo "Reads after filtering: $reads_after" >&2
