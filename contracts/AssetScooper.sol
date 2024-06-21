// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "./interfaces/SafeTransferLib.sol";
import "./interfaces/IAggregationRouterV5.sol";
import "solady/src/utils/ReentrancyGuard.sol";

contract AssetScooper is ReentrancyGuard {
    IAggregationRouterV3 private immutable i_AggregationRouter_V3;

    struct SwapDescription {
        address srcToken;
        address dstToken;
        uint256 amount;
        address to;
        uint256 deadline;
        uint256 minReturnAmount;
    }

    event SwapExecuted(address indexed user, address indexed dstToken, uint256 indexed amountOut);

    error EmptyData(string message);
    error UnsuccessfulSwap(string message);
    error InsufficientOutputAmount(string message);

    constructor(address aggregationRouterV3) {
        i_AggregationRouter_V3 = IAggregationRouterV3(aggregationRouterV3);
    }

    function swap(uint256 minAmountOut, bytes[] calldata data) external nonReentrant {
        if (data.length == 0) revert EmptyData("Asset Scooper: empty calldata");
        for (uint256 i = 0; i < data.length; i++) {
            (address executor, SwapDescription memory swapParam, bytes memory _data) = abi.decode(data[i[4:]], (address, SwapDescription, bytes));

            SafeTransferLib.safeTransferFrom(swapParam.srcToken, msg.sender, address(this), swapParam.amount);
            SafeTransferLib.approve(swapParam.srcToken, address(i_AggregationRouter_V3), swapParam.amount);

            (bool success, bytes memory returnData) = address(i_AggregationRouter_V3).call(
                abi.encodeWithSelector(i_AggregationRouter_V3.swap.selector, executor, swapParam, _data)
            );

            if (!success) revert UnsuccessfulSwap("Asset Scooper: unsuccessful swap");
            (uint256 returnAmount, uint256 gasLeft) = abi.decode(returnData, (uint256, uint256));
            if (returnAmount < minAmountOut) revert InsufficientOutputAmount("Asset Scooper: insufficient output amount");
        }
        emit SwapExecuted(msg.sender, swapParam.dstToken, returnAmount);

    }
}
