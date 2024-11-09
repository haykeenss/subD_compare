#!/bin/bash

# Check for correct number of arguments
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <subdomains1.txt> <subdomains2.txt> <output_file.txt>"
  exit 1
fi

# Input files
file1="$1"
file2="$2"
output_file="$3"

# Combine the files and remove duplicates
cat "$file1" "$file2" | sort | uniq > "$output_file"

# Calculate duplicates
total_lines_file1=$(wc -l < "$file1")
total_lines_file2=$(wc -l < "$file2")
total_lines_combined=$(wc -l < "$output_file")
duplicate_lines=$((total_lines_file1 + total_lines_file2 - total_lines_combined))

# Calculate percentage of duplicates
total_lines_combined_with_dups=$((total_lines_file1 + total_lines_file2))
if [ "$total_lines_combined_with_dups" -gt 0 ]; then
  duplicate_percentage=$((duplicate_lines * 100 / total_lines_combined_with_dups))
else
  duplicate_percentage=0
fi

# Print the result
echo "Output file: $output_file"
echo "Duplicate lines: $duplicate_lines"
echo "Total lines in input files: $total_lines_file1 + $total_lines_file2 = $total_lines_combined_with_dups"
echo "Percentage of duplicates: $duplicate_percentage%"
