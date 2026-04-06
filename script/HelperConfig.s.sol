//1. Deploy mocks when we are on a local anvil chain
//2. Keep track of contract address accross different chains

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    uint8 public constant ETH_USD_DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;
    uint256 public constant SEPOLIA_CHAIN_ID = 11155111;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == SEPOLIA_CHAIN_ID) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getAnvilConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getAnvilConfig() public returns (NetworkConfig memory) {
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            ETH_USD_DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }
}
