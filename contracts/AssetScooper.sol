// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "./interfaces/SafeTransferLib.sol";
import "./interfaces/IAggregationRouterV5.sol";
import "solady/src/utils/ReentrancyGuard.sol";
import "./interfaces/SignUtils.sol";

contract AssetScooper is ReentrancyGuard {
    IAggregationRouterV3 private immutable i_AggregationRouter_V3;

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
    error InvalidSignature(string message);

    constructor(address aggregationRouterV3) {
        i_AggregationRouter_V3 = IAggregationRouterV3(aggregationRouterV3);
    }

    function swap(uint256 minAmountOut, bytes[] calldata data) external nonReentrant {
        if (data.length == 0) revert EmptyData("Asset Scooper: empty calldata");
        for (uint256 i = 0; i < data.length; i++) {
            (address executor, SwapDescription memory swapParam) = abi.decode(
                data[i],
                (address, SwapDescription)
            );
            
            // Handle permit
            if (swapParam.permit.length != 0) {
                (address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) = abi.decode(
                    swapParam.permit,
                    (address, address, uint256, uint256, uint8, bytes32, bytes32)
                );
                
                SafeTransferLib.permit2(swapParam.srcToken, owner, address(this), value, deadline, v, r, s);
                SafeTransferLib.safeTransferFrom(swapParam.srcToken, owner, address(this), swapParam.amount);
            }
            
            /// bytes32 hash = keccak256(abi.encodePacked(owner, spender, value, deadline));

            (bool success, bytes memory returnData) = address(i_AggregationRouter_V3).call(
                abi.encodeWithSelector(
                    i_AggregationRouter_V3.swap.selector, 
                    executor, 
                    swapParam,
                    swapParam.permit
                    swapParam.data
                )
            );

            if (!success) revert UnsuccessfulSwap("Asset Scooper: unsuccessful swap");
            (uint256 returnAmount, uint256 spentAmount) = abi.decode(returnData, (uint256, uint256));
            if (returnAmount < minAmountOut) revert InsufficientOutputAmount("Asset Scooper: insufficient output amount");
            uint256 dstTokenBalance = SafeTransferLib.balanceOf(swapParam.dstToken, address(this));
            if (dstTokenBalance > 0) SafeTransferLib.safeTransfer(swapParam.receiver, dstTokenBalance);
            emit SwapExecuted(msg.sender, swapParam.dstToken, returnAmount);
        }
    }
}
