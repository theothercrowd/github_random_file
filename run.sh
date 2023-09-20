#!/bin/bash

# Setting path to data.csv file
DATAFILE="data.csv"

function github (){

# Setting account number from input (actually row number on which account is placed)
ACC=$1

  function readcsv() {
    awk -F ',' -v line="$1" -v field="$2" 'NR == line {print $field}'
  }
  function xreadcsv() {
    readcsv $ACC $1 < $DATAFILE
  }

# Setting proxy
HTTPPROXY=$(xreadcsv 8)
git config --global http.proxy $HTTPPROXY

# Set the API key
API_KEY=$(xreadcsv 5)

# Set other main variables
USEREMAIL=$(xreadcsv 1)
USERNAME=$(xreadcsv 2)
REPO=$(xreadcsv 3)
BRANCH=$(xreadcsv 4)
FILE_DESCRIPTION=$(xreadcsv 6)

# Set global git user.name and user.email
git config --global user.name "$USERNAME"
git config --global user.email "$USEREMAIL"

# Fetch a random fact from the JSON API
JSONURL=$(xreadcsv 7)
FACT=$(curl -s "$JSONURL" | jq -r '.text')

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

CURRENT_DATE=$(date +'%d%m%Y'_'%H%M%S')
FILE_NAME=$CURRENT_DATE$'_'$number$'.'txt

# Create a random text file with the fetched fact

echo "$FACT" > $FILE_NAME

# Add the file to the staging area
git add $FILE_NAME

# Commit the changes with a message
git commit -m "$FILE_DESCRIPTION"

# Push the changes to the remote repository
git push origin "$BRANCH"

# Clean up the temporary directory
cd ..
rm -rf "$TEMP_DIR"

# Unset the proxy
git config --global --unset http.proxy

# Unset username and email
git config --global user.name ""
git config --global user.email ""

}

CSVROWS=$(awk 'END {print NR}' $DATAFILE)

echo "
Available accounts (total = $CSVROWS):
"

echo "$(awk -F ',' 'NR > 1 { print NR, $2 }' $DATAFILE)"

read_input() {
    while true; do
        read -p "
        Please enter account number:
        " ACCN
        if ((ACCN < 2)); then
            echo "
            Number must be between 2 and $CSVROWS
            "
        else
            break
        fi
    done
    github "$ACCN"
}

read_input
