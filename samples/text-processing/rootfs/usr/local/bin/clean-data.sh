#!/usr/bin/env bash

echo "Cleaning data from $1 to $2..."
mkdir -p "$(dirname ${2})"
sed -n '/^\*\*\* START OF THIS PROJECT GUTENBERG EBOOK/,/^\*\*\* END OF THIS PROJECT GUTENBERG EBOOK /p;/^\*\*\* END OF THIS PROJECT GUTENBERG EBOOK /q' $1  > $2
sleep 5
echo "Done..."
