const main = async () => {
    const voteTokenFactory = await hre.ethers.getContractFactory("VoteToken");
    const voteToken = await voteTokenFactory.deploy();
    await voteToken.deployed();
    console.log("Contract deployed to:", voteToken.address);
};

const runMain = async () => {
    try {
        await main();
        process.exit(0); // exit Node process without error
    } catch (error) {
        console.log(error);
        process.exit(1); // exit Node process while indicating 'Uncaught Fatal Exception' error
    }
    // Read more about Node exit ('process.exit(num)') status codes here: https://stackoverflow.com/a/47163396/7974948
};

runMain();

// npx hardhat run scripts/run.js