require("@nomiclabs/hardhat-waffle");
// Import and configure dotenv
require("dotenv").config();

module.exports = {
    solidity: "0.8.4",
    networks: {
        rinkeby: {
            // This value will be replaced on runtime
            url: process.env.RINKEBY_ALCHEMY_URL,
            // url: `https://goerli.infura.io/v3/`,
            accounts: [process.env.PRIVATE_KEY],
        },
    },
};
