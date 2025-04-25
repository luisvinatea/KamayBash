#!/bin/bash

inputfile="$(pwd)/snippets/samples/sample.csv"
outputfile="$(pwd)/snippets/outputs/output.csv"

# join pairs of consecutive lines:
paste -d ' ' - - < "$inputfile" > "$outputfile"
# join three consecutive lines:
paste -d ' ' - - - < "$inputfile" > "$outputfile"
# join four consecutive lines:
paste -d ' ' - - - - < "$inputfile" > "$outputfile"

# Save the output file
echo "Output file saved to $outputfile"
echo "Processing completed."

# Only run the substitution after the file has been created
while [ ! -f "$outputfile" ]; do
    sleep 1
done

# Replace spaces with commas after pasting
sed -i "s/ /,/g" "$outputfile"

