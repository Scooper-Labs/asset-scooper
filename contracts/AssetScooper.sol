// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "./utils/SafeTransferLib.sol";
import "./interfaces/IAggregationRouterV6.sol";
import "solady/src/utils/ReentrancyGuard.sol";

contract AssetScooper is ReentrancyGuard {

    IAggregationRouterV6 public i_AggregationRouter_V6;

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
            (address selector, /*address executor*/, SwapDescription memory swapParam, /*bytes data*/) = abi.decode(
                data[i],
                (address, address, SwapDescription, bytes)
            );

            if (keccak256(abi.encode(selector)) != keccak256(abi.encode(i_AggregationRouter_V6.swap.selector))) revert InvalidSelector();

            (bool success, bytes memory returnData) = address(i_AggregationRouter_V6).call(data[i]);

            if (!success) revert UnsuccessfulSwap("Asset Scooper: unsuccessful swap");
            (uint256 returnAmount, /*uint256 spentAmount*/) = abi.decode(returnData, (uint256, uint256));
            if (returnAmount < minAmountOut) revert InsufficientOutputAmount("Asset Scooper: insufficient output amount");
            emit SwapExecuted(msg.sender, swapParam.dstToken, returnAmount);
        }
    }

    function approveForAll(bytes[] memory callDataArray) external {
        assembly {
            let len := mload(callDataArray)
            for { let i := 0 } lt(i, len) { i := add(i, 1) } {

                // calldataArray := location
                // add(calldataArray, 32) := element location
                // mul(i, 32) := offset
                // add(add(calldataArray, 32), mul(i, 20)) := element

                let calldataElement := mload(add(add(callDataArray, 0x20), mul(i, 0x20)))
                
                if iszero(iszero(calldataElement)) {
                    let token := mload(calldataElement)
                    let amount := mload(add(calldataElement, 0x20))

                    // Perform the safeApprove call

                    let freePtr := mload(0x40)

                    // approve sig := 0x095ea7b3

                    mstore(freePtr, 0x095ea7b3)

                    // advance memory to the location from the
                    // first bytes4 to store the parameters
                    mstore(add(freePtr, 0x04), 0x111111125421cA6dc452d289314280a0f8842A65)

                    // advance memory to the next 32 bytes to store 
                    // the amount
                    mstore(add(freePtr, 0x24), amount)
                    
                    // get parameters between freePtr - 0x44 (68 bytes) 
                    // for approval call and store return data between 0 - 0 
                    let result := call(gas(), token, 0, freePtr, 0x44, 0, 0)
                    if iszero(result) {
                        revert(0, 0)
                    }
                }
            }
        }
    }
}
