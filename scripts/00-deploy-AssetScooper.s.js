const ethers = require("ethers");

const provider = new ethers.providers.JsonRpcProvider("http://localhost:8545");
const signer = provider.getSigner();

const routerAddress = "0xYourRouterContractAddress";
const routerABI = [
    "function swap(address executor, (address srcToken, address dstToken, address payable recipient, uint256 amount, uint256 minReturnAmount, uint256 flags, bytes permit) swapDescription, bytes data) external"
];

const routerContract = new ethers.Contract(routerAddress, routerABI, signer);

const swapDescription = {
    srcToken: "0xSrcTokenAddress",
    dstToken: "0xDstTokenAddress",
    recipient: "0xRecipientAddress",
    amount: ethers.utils.parseUnits("1.0", 18),
    minReturnAmount: ethers.utils.parseUnits("0.9", 18),
    flags: 0,
    permit: "0x"
};

const swapData = "0x";

const swapTx = await routerContract.populateTransaction.swap(
    "0xCallerAddress",
    swapDescription,
    swapData
);

console.log(swapTx.data);
