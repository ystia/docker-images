#!/usr/bin/env bash

echo "Cleaning data from $1 to $2..."
sed -n '/^Acte I\./,/^\*\*\* END OF THIS PROJECT GUTENBERG EBOOK /p;/^\*\*\* END OF THIS PROJECT GUTENBERG EBOOK /q' $1  > $2
sleep 30
echo "Done..."
