//GitHub API Library
const { Octokit } = require('@octokit/rest');

//Insert your GitHub tokens here in next format ['token1', 'token2', 'token3']
const gitTokens = ['API_GITHUB']

//Insert your GitHub names here in next format ['name1', 'name2', 'name3']
const gitNames = ['USERNAME_GITHUB']



//Function to generate unique name for the file
function generateUniqueName() {
    return `test_${Math.floor(Math.random() * 150000000)}.txt`;
}

//Function to push random cat fact to the GitHub repo
async function pushRandomCatName(repoOwner, token) {
    //API initialization
    const octokit = new Octokit({ auth: token });

    try {

        //Get all files from the repo
        const branchFilesData = await octokit.rest.repos.getContent({
            owner: repoOwner,
            repo: 'randomtest',
            branch: 'main',
        });

        console.log(branchFilesData, 'branchFilesData')

        //Get random cat fact
        const catsResponse = await fetch("https://uselessfacts.jsph.pl/api/v2/facts/random");
        const { text } = await catsResponse.json();

        //Generate unique name for the file
        let randomName = generateUniqueName();

        //Check if file name is unique in the repo
        const isAlreadyFileNameExist = !!branchFilesData.data.find((user) => {
            return user.path === randomName;
        });

        //If file name is not unique, generate new name
        if (isAlreadyFileNameExist) {
            pushRandomCatName(repoOwner, token);
        }

        // Push file to the repo
        await octokit.rest.repos.createOrUpdateFileContents({
            owner: repoOwner,
            repo: 'randomtest',
            path: randomName,
            message: 'This Change is happening daily',
            content: Buffer.from(text).toString('base64'),
            branch: 'main',
        });
        console.log('Pushed fact to randomtest');
    } catch (error) {
        console.error('Error pushing fact to randomtest', error);
    }
}

//Function to start execution
function startExecution() {
    gitTokens.forEach((token, index) => {
        pushRandomCatName(gitNames[index], token);
    })
}

//Start execution
startExecution();
