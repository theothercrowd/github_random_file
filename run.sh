#!/bin/bash

# Setting path to data.csv file
DATAFILE="data/data.csv"

function github (){

# Set account number from input (actually row number on which account is placed)
ACC=$1

  # Function to generate a random word for $FILE_DESCRIPTION

  function generate_rnd_words(){

    # Read the words from the file into an array
    IFS=$'\n' read -d '' -r -a words < data/20k.txt

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
USEREMAIL=$(xreadcsv 1)
USERNAME=$(xreadcsv 2)
REPO=$(xreadcsv 3)
BRANCH=$(xreadcsv 4)
API_KEY=$(xreadcsv 5)
HTTPPROXY=$(xreadcsv 6)

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
FACT=$(shuf -n 1 data/facts.txt)

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

# Unsetting git config
git config --global --unset http.proxy
git config --global user.name ""
git config --global user.email ""

}

if command -v awk &> /dev/null; then
echo "awk is installed"

CSVROWS=$(awk 'END {print NR}' $DATAFILE)
TOTALACCS=$(($CSVROWS - 1))

echo "
Available accounts (total = $TOTALACCS):
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

else
    echo "awk is not installed, please install awk and run again"
    exit 1
fi
