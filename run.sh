#!/bin/bash

# Setting paths to your data files
DATAFILE="/path/to/your/data.csv"
TXTFILE="/path/to/your/20k.txt"
FACTSFILE="/path/to/your/facts.txt"

# Function to find a row on which the needed account is placed

function find_row {
    local value="$1"

    if [ ! -f "$DATAFILE" ]; then
        echo "File not found: $file"
        return 1
    fi

    awk -v value="$value" -F ',' '$1 == value { print NR }' "$DATAFILE"
}

# Set the variable that is actually connecting account number with a csv file row number

ACC=$(find_row $1)

function github (){

  # Function to generate a random word for $FILE_DESCRIPTION

  function generate_rnd_words(){

    # Read the words from the file into an array
    IFS=$'\n' read -d '' -r -a words < $TXTFILE

    # Generate a random number between 4 and 10
    num_words=$1

    # Select random words from the array
    selected_words=()
    for ((i = 0; i < num_words; i++)); do
      index=$((RANDOM % ${#words[@]}))
      selected_words+=("${words[index]}")
    done

    # Join the selected words into a phrase
    phrase=$(IFS=" "; echo "${selected_words[*]}")

    echo $phrase

  }

  # Functions to read data.csv

  function readcsv() {
    awk -F ',' -v line="$1" -v field="$2" 'NR == line {print $field}'
  }
  function xreadcsv() {
    readcsv $ACC $1 < $DATAFILE
  }

# Set main variables
USEREMAIL=$(xreadcsv 2)
USERNAME=$(xreadcsv 3)
REPO=$(xreadcsv 4)
BRANCH=$(xreadcsv 5)
API_KEY=$(xreadcsv 6)
HTTPPROXY=$(xreadcsv 7)

# Generate file description
DESC_VERBS=("Creating" "Fixing" "Changing" "Setting" "Updating")
DESC_INDEX=$((RANDOM % ${#DESC_VERBS[@]}))
DESC_VERB=${DESC_VERBS[DESC_INDEX]}
RAND_WORD=$(generate_rnd_words 1)
FILE_DESCRIPTION="$DESC_VERB $RAND_WORD"

# Set global settings: git user.name, user.email, http.proxy
git config --global user.name "$USERNAME"
git config --global user.email "$USEREMAIL"
git config --global http.proxy $HTTPPROXY

# Fetch a random fact from the data/facts.txt
FACT=$(shuf -n 1 $FACTSFILE)

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
FILE_NAME=$REPO$'_'$CURRENT_DATE$'_'$number$'.'txt

# Create a random text file with the fetched fact

echo "$FACT" > $FILE_NAME

# Add the file to the staging area
git add $FILE_NAME

# Commit the changes with a message
git commit -m "$FILE_DESCRIPTION"

# Push the changes to the remote repository
git push origin "$BRANCH"

# Clean up the temporary directory
SHPATH=$(realpath $BASH_SOURCE)
SHDIR="${SHPATH%/*}"
cd ..
rm -rf "$TEMP_DIR"
cd $SHDIR

# Unsetting git config
git config --global --unset http.proxy
git config --global user.name ""
git config --global user.email ""

}

github $1
