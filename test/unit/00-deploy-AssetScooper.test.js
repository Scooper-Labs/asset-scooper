const { deployments, getNamedAccounts, ethers } = require("hardhat")
const { assert, expect } = require("chai");
const { developmentChains } = require("../../helper-hardhat-config");


!developmentChains.includes(network.name) ? describe.skip :
    describe("AssetScooper", async () => {

        let assetScooper;
        let deployer;
        const args = ["0x111111125421cA6dc452d289314280a0f8842A65"];

        beforeEach(async () => {
            deployer = (await getNamedAccounts()).deployer;
            await deployments.fixture(["all"]);
            assetScooper = await ethers.getContract("AssetScooper", deployer);
        });

        describe("Deployment", async () => {
            it("sets router address", async () => {
                const txresponse = await assetScooper.i_AggregationRouter_V6();
                assert.equal(txresponse, args[0]);
            });
        });

        describe("swap", async () => {
            it("reverts if empty calldata", async () => {
                const swaptx = assetScooper.connect(deployer).swap([]);
                await expect(swaptx).to.be.revertedWith("EmptyData()");
            });

            it("reverts if selector invalid", async () => {
                const swaptx = assetScooper.connect(deployer).swap(["0x095ea7b3"]);
                await expect(swaptx).to.be.revertedWith("InvalidSelector()");
            });

        });

    })