# github_random_file

This bash script pushes a randomly named file with a random text taken from facts.txt to any of your github accounts in data.csv file, using a randomly generated action from 20k.txt file.

To use the script you need to create a repository and create a first file there.
Also you need a github api key of your account (preferrably created without expiration date).

How to use?

1. Install awk (pre-installed on Ubuntu)
2. Put your personal data to data.csv starting from the second row.
3. chmod +x run.sh
4. ./run.sh
5. Enter your account number from the list that will be shown in terminal
6. Enjoy another commit to your github account!
