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

# Check for correct number of arguments
if [ "$#" -ne 3 ]; then
  echo -e "\e[1;31mUsage: $0 <subdomains1.txt> <subdomains2.txt> <output_file.txt>\e[0m"
  exit 1
fi

# Input files
file1="$1"
file2="$2"
output_file="$3"
duplicates_file="duplicates.txt"

# Combine the files and remove duplicates
echo -e "\e[1;36mMerging files and removing duplicates...\e[0m"
cat "$file1" "$file2" | sort | uniq > "$output_file"

# Find the duplicate subdomains (subdomains that appear in both files)
echo -e "\e[1;36mIdentifying duplicate subdomains in both files...\e[0m"
comm -12 <(sort "$file1") <(sort "$file2") > "$duplicates_file"

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
echo -e "\n\e[1;36mResult\e[0m:"
echo -e "\e[1;34mOutput file: \e[0m$output_file"
echo -e "\e[1;34mDuplicate lines: \e[0m$duplicate_lines"
echo -e "\e[1;34mTotal lines in input files: \e[0m$total_lines_file1 + $total_lines_file2 = $total_lines_combined_with_dups"
echo -e "\e[1;34mPercentage of duplicates: \e[0m$duplicate_percentage%"

# Output the duplicate subdomains
echo -e "\n\e[1;36mDuplicate subdomains (both files):\e[0m"
cat "$duplicates_file"
