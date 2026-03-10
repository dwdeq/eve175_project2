#### README.md

This script (quality_filter.sh) accepts a FASTQ file as an input as well as a quality threshold (integer).
The FASTQ file must have one of the following file extensions:
- *.fastq
- *.fq
- *.fastq.gz
- *.fq.gz

The script outputs all FASTQ reads that surpass the quality threshold as well as the total number of reads and the number of reads that pass.

To use the script, use the following syntax:
```./quality_filter.sh <fastq> <quality_threshold>``` 
