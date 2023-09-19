#!/bin/bash

# Setting proxy
git config --global http.proxy http://USER:PASSWORD@IP:PORT

# Set the API key
API_KEY="YOUR_API_KEY"

# Set the repository details
USERNAME="YOUR_USERNAME"
REPO="YOUR_REPO_NAME"
BRANCH="YOUR_BRANCH"
DESCRIPTION="YOUR_FILE_DESCRIPTION"

# Fetch a random fact from the JSON API
FACT=$(curl -s "https://uselessfacts.jsph.pl/api/v2/facts/random" | jq -r '.text')

# Create a temporary directory
TEMP_DIR=$(mktemp -d)

# Clone the repository
git clone "https://$USERNAME:$API_KEY@github.com/$USERNAME/$REPO.git" "$TEMP_DIR"

# Change directory to the cloned repository
cd "$TEMP_DIR"

# Define an array of symbols, numbers, and letters
characters=("0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z")

# Generate a random number, symbol, or letter for each digit
number=""
for ((i=0; i<5; i++)); do
    # Generate a random index to select a character from the array
    index=$((RANDOM % ${#characters[@]}))
    digit="${characters[$index]}"
    number="${number}${digit}"
done

current_date=$(date +'%d%m%Y'_'%H%M%S')
file_name=$current_date$'_'$number.txt

# Create a random text file with the fetched fact

echo "$FACT" > $file_name

# Add the file to the staging area
git add $file_name

# Commit the changes with a message
git commit -m "$DESCRIPTION"

# Push the changes to the remote repository
git push origin "$BRANCH"

# Clean up the temporary directory
rm -rf "$TEMP_DIR"

# Unset the proxy
git config --global --unset http.proxy
