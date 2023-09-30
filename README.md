# github_random_file

This bash script pushes a randomly named file with a random text taken from facts.txt to any of your github accounts in data.csv file, using a randomly generated action from 20k.txt file.

To use the script you need to create a repository and create a first file there.
Also you need a github api key of your account (preferrably created without expiration date).

How to use?

1. Install awk (pre-installed on Ubuntu)
2. Put your github personal data to data.csv starting from the second row.
3. Change variables DATAFILE, TXTFILE, FACTSFILE with your actual paths to these files from /data directory of this repository.
4. chmod +x run.sh
5. Execute ". run.sh 1" if you want the script to act with account number 1 from data.csv file (not the row number but the account number = a value from the first column of data.csv!)
6. Enjoy another commit to your github account!
