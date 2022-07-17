// SETUP BEGINS
const express = require("express");
const cors = require("cors");
const hre = require("hardhat");
require("dotenv").config();

let app = express();

// !! Enable processing JSON data
app.use(express.json());

// !! Enable CORS
app.use(cors());

function sleep(ms) {
    return new Promise((resolve) => {
        setTimeout(resolve, ms);
    });
}

// SETUP END
async function main() {
    app.get("/", function (req, res) {
        res.status(200);
        res.send("Hello World! This is the backend.");
    });

    app.post("/ethfaucet", async function (req, res) {
        try {
            console.log(req.body);
            console.log("Claiming faucet for ", req.body.address);

            // Rinkeby Provider
            let rinkebyProvider = new hre.ethers.providers.AlchemyProvider("rinkeby", process.env.RINKEBY_ALCHEMY_API_KEY);

            // Building the tx
            let faucetAddress = new hre.ethers.Wallet(process.env.PRIVATE_KEY, rinkebyProvider);
            let walletSigner = faucetAddress.connect(rinkebyProvider);
            let gas_price = await rinkebyProvider.getGasPrice();
            let nonce = await rinkebyProvider.getTransactionCount(walletSigner.address, "latest");

            const ethFaucetTx = {
                from: walletSigner.address,
                to: req.body.address,
                value: hre.ethers.utils.parseEther("0.1"),
                nonce: nonce,
                gasLimit: hre.ethers.utils.hexlify("0x100000"),
                gasPrice: gas_price,
            };
            console.log(ethFaucetTx);

            // Sending the tx
            let ethFaucetTxId = await walletSigner.sendTransaction(ethFaucetTx);
            console.log(ethFaucetTxId.hash);

            res.status(200);
            res.send(ethFaucetTxId.hash);
        } catch (e) {
            res.status(500);
            res.send({
                error: "Issues with claiming...",
            });
            console.log(e);
        }
    });
}

main();
// Test
// START SERVER
app.listen(process.env.PORT || 5000, () => {
    console.log("Server has started");
});
