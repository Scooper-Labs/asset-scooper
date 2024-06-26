// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "./utils/SafeTransferLib.sol";
import "./interfaces/IAggregationRouterV6.sol";
import "solady/src/utils/ReentrancyGuard.sol";

contract AssetScooper is ReentrancyGuard {

    IAggregationRouterV6 public i_AggregationRouter_V6;
    address constant ROUTER = 0x111111125421cA6dc452d289314280a0f8842A65;

    struct SwapDescription {
        address srcToken;
        address dstToken;
        address receiver; 
        uint256 amount;
        uint256 minReturnAmount;
        uint256 flags;
        bytes permit;
        bytes data;
    }

    event SwapExecuted(address indexed user, address indexed dstToken, uint256 indexed amountOut);

    error EmptyData(string message);
    error UnsuccessfulSwap(string message);
    error InsufficientOutputAmount(string message);
    error InvalidSelector();

    constructor(address aggregationRouterV6) {
        i_AggregationRouter_V6 = IAggregationRouterV6(aggregationRouterV6);
    }

    function swap(uint256 minAmountOut, bytes[] calldata data) external nonReentrant {
        if (data.length == 0) revert EmptyData("Asset Scooper: empty calldata");
        for (uint256 i = 0; i < data.length; i++) {
            (/*bytes4 selector*/, /*address executor*/, SwapDescription memory swapParam, /*bytes data*/) = abi.decode(
                data[i],
                (bytes4, address, SwapDescription, bytes)
            );

            (bool success, bytes memory returnData) = address(i_AggregationRouter_V6).call(data[i]);

            if (!success) revert UnsuccessfulSwap("Asset Scooper: unsuccessful swap");
            (uint256 returnAmount, /*uint256 spentAmount*/) = abi.decode(returnData, (uint256, uint256));
            if (returnAmount < minAmountOut) revert InsufficientOutputAmount("Asset Scooper: insufficient output amount");
            emit SwapExecuted(msg.sender, swapParam.dstToken, returnAmount);
        }
    }

    function approveAll(address[] calldata tokenAddresses, uint256[] calldata amounts) public {
        if (tokenAddresses.length != amounts.length) revert EmptyData("Asset Scooper: empty calldata");

        for (uint i = 0; i < tokenAddresses.length; i++) {
            address token = tokenAddresses[i];
            uint256 amount = amounts[i];
            
            SafeTransferLib.safeApprove(token, ROUTER, amount);
        }
    }

}
