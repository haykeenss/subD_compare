#!/bin/bash

# Function to print a colorful header
print_header() {
    echo -e "\e[1;34m************************************************************"
    echo -e "*                \e[1;32mSubdomain Merge Tool\e[1;34m by author \e[1;33mHaykeensPaul\e[1;34m          *"
    echo -e "************************************************************"
    echo -e "\e[0m"
}

# Call the print_header function to display the header
print_header

# Check for at least two input files and one output file
if [ "$#" -lt 2 ]; then
  echo -e "\e[1;31mUsage: $0 <file1> <file2> [file3 ... fileN] <output_file>\e[0m"
  exit 1
fi

# Extract output file from the last argument
output_file="${@: -1}"

# Gather all input files (excluding the last argument)
input_files=("${@:1:$#-1}")

# Temporary file for duplicates
duplicates_file="duplicates.txt"

# Merge all input files and remove duplicates
echo -e "\e[1;36mMerging files and removing duplicates...\e[0m"
cat "${input_files[@]}" | sort | uniq > "$output_file"

# Identify duplicate subdomains across all input files
echo -e "\e[1;36mIdentifying duplicate subdomains across all files...\e[0m"
sort -m "${input_files[@]}" | uniq -d > "$duplicates_file"

# Calculate statistics
total_lines_combined_with_dups=0
for file in "${input_files[@]}"; do
  lines_in_file=$(wc -l < "$file")
  total_lines_combined_with_dups=$((total_lines_combined_with_dups + lines_in_file))
done

total_lines_output=$(wc -l < "$output_file")
duplicate_lines=$((total_lines_combined_with_dups - total_lines_output))

# Calculate percentage of duplicates
if [ "$total_lines_combined_with_dups" -gt 0 ]; then
  duplicate_percentage=$((duplicate_lines * 100 / total_lines_combined_with_dups))
else
  duplicate_percentage=0
fi

# Print the result
echo -e "\n\e[1;36mResult\e[0m:"
echo -e "\e[1;34mOutput file: \e[0m$output_file"
echo -e "\e[1;34mDuplicate lines: \e[0m$duplicate_lines"
echo -e "\e[1;34mTotal lines in input files: \e[0m$total_lines_combined_with_dups"
echo -e "\e[1;34mPercentage of duplicates: \e[0m$duplicate_percentage%"

# Output the duplicate subdomains
echo -e "\n\e[1;36mDuplicate subdomains (across all files):\e[0m"
cat "$duplicates_file"
