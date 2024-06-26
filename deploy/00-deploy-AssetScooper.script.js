const { network } = require("hardhat");
const { verify } = require('../utils/verify');
const { developmentChains } = require("../helper-hardhat-config");
const { ETHERSCAN_APIKEY } = process.env || "";

const deployAssetScooper = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments;
    const { deployer } = await getNamedAccounts();
    const chainId = network.config.chainId;

    const ROUTER_ADDRESS = "0x111111125421cA6dc452d289314280a0f8842A65";
    let args = [ROUTER_ADDRESS];

    const assetScooper = await deploy("AssetScooper", {
        from: deployer,
        args: args,
        log: true,
        blockConfirmations: network.config.blockConfirmations
    });

    log("Deploying..................................................")
    log("...........................................................")
    log(assetScooper.address);

    // if (!developmentChains.includes(network.name) && chainId == 8453 && ETHERSCAN_APIKEY) {
    //     await verify(assetScooper.address, args);
    // }
}

module.exports.default = deployAssetScooper;
module.exports.tags = ["all", "assetScooper"];