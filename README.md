# github_random_file

This bash script pushes a randomly named file with a random text taken from a JSON to any of your github accounts in data.csv file.

How to use?

1. Install awk (pre-installed on Ubuntu)
2. Put your personal data to data.csv starting from the second row. For JSON_URL you can take any open api, I use this for example: https://uselessfacts.jsph.pl/api/v2/facts/random.
3. chmod +x run.sh
4. ./run.sh
5. Enter your account number from the list that will be shown
6. Enjoy another commit to your github account!
