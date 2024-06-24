// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "./interfaces/SafeTransferLib.sol";
import "./interfaces/IAggregationRouterV6.sol";
import "solady/src/utils/ReentrancyGuard.sol";
import "./interfaces/SignUtils.sol";

contract AssetScooper is ReentrancyGuard {
    IAggregationRouterV6 private immutable i_AggregationRouter_V6;

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

    error UnsuccessfulSwap(string message);
    error InsufficientOutputAmount(string message);
    error InvalidSelector()

    constructor(address aggregationRouterV6) {
        i_AggregationRouter_V6 = IAggregationRouterV6(aggregationRouterV6);
    }

    function swap(uint256 minAmountOut, bytes[] calldata data) external nonReentrant {
        if (data.length == 0) revert EmptyData("Asset Scooper: empty calldata");
        for (uint256 i = 0; i < data.length; i++) {
            (address selector, address executor, SwapDescription memory swapParam) = abi.decode(
                data[i],
                (address, SwapDescription)
            );

            if (selector != i_AggregationRouter_V6.swap.selector) revert InvalidSelector();

            SafeTransferLib.safeTransferFrom(swapParam.srcToken, swapParam.receiver, address(this), swapParam.amount);
            SafeTransferLib.safeApprove(swapParam.srcToken, address(i_AggregationRouter_V6), swapParam.amount);

            (bool success, bytes memory returnData) = address(i_AggregationRouter_V5).call(data);

            if (!success) revert UnsuccessfulSwap("Asset Scooper: unsuccessful swap");
            (uint256 returnAmount, uint256 spentAmount) = abi.decode(returnData, (uint256, uint256));
            if (returnAmount < minAmountOut) revert InsufficientOutputAmount("Asset Scooper: insufficient output amount");
            emit SwapExecuted(msg.sender, swapParam.dstToken, returnAmount);
        }
    }

    function approveForAll(bytes[] memory callDataArray) external {
        assembly {
            let len := mload(callDataArray)
            for { let i := 0 } lt(i, len) { i := add(i, 1) } {
                let calldataElement := mload(add(add(callDataArray, 0x20), mul(i, 0x20)))
                
                if iszero(iszero(calldataElement)) {
                    let token := mload(calldataElement)
                    let amount := mload(add(calldataElement, 0x20))

                    // Perform the safeApprove call
                    let freePtr := mload(0x40)
                    mstore(freePtr, 0x095ea7b3)
                    mstore(add(freePtr, 0x04), address())
                    mstore(add(freePtr, 0x24), amount)
                    
                    let result := call(gas(), token, 0, freePtr, 0x44, 0, 0)
                    if iszero(result) {
                        revert(0, 0)
                    }
                }
            }
        }

    receive() external payable {}
}
