// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {

    error HelperConfig__InvalidChainId();

    struct NetworkConfig {
        address entryPoint;
        address account;
    }

    uint256 public constant ETH_SEPOLIA_CHAIN_ID =  11155111;
    uint256 public constant ZKSYNC_SEPOLIA_CHAIN_ID = 300;
    uint256 public constant LOCAL_CHAIN_ID = 31337;
    address public constant BURNER_WALLET = 0xf240669b6AdeB433947D64e9Ea11b98FC6D888Ad;

    NetworkConfig public s_networkConfig;

    mapping(uint256 chainId => NetworkConfig) public s_networkConfigs;

constructor(){
    s_networkConfigs[ETH_SEPOLIA_CHAIN_ID] = getSepoliaEthConfig();
}

 function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            entryPoint: 0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789,
            account: BURNER_WALLET
        });
    }

    function getZkSyncSepoliaConfig() public pure returns (NetworkConfig memory) {
        // ZKSync Era has native account abstraction; an external EntryPoint might not be used in the same way.
        // address(0) is used as a placeholder or to indicate reliance on native mechanisms.
        return NetworkConfig({
            entryPoint: address(0),
            account: BURNER_WALLET
        });
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (s_networkConfig.entryPoint != address(0)) {
            return s_networkConfig;
        }
        // For local Anvil network, we might need to deploy a mock EntryPoint
        // address mockEntryPointAddress = deployMockEntryPoint(); // Placeholder
        // For now, let's use Sepolia's EntryPoint or a defined mock if available
        // This part would involve deploying a mock EntryPoint if one doesn't exist.
        // For simplicity in this example, we'll assume a mock or reuse Sepolia's for structure.
        // In a real scenario, you'd deploy a MockEntryPoint.sol here.
        // Example: localNetworkConfig = NetworkConfig({ entryPoint: mockEntryPointAddress, account: BURNER_WALLET });
        // Fallback for this lesson (actual mock deployment not shown):
        NetworkConfig memory sepoliaConfig = getSepoliaEthConfig(); // Or a specific local mock entry point
        s_networkConfig = NetworkConfig({
            entryPoint: sepoliaConfig.entryPoint,// Replace with actual mock entry point if deployed
            account: BURNER_WALLET
        });
        return s_networkConfig;
    }

    function getConfigByChainId(uint256 chainId) public  returns (NetworkConfig memory) {
        if (chainId == ETH_SEPOLIA_CHAIN_ID) {
            return getOrCreateAnvilEthConfig();
        } else if(s_networkConfigs[chainId].entryPoint != address(0)) {
            return s_networkConfigs[chainId];
        } else {
        revert HelperConfig__InvalidChainId();
        }
    }


    function getConfig() public returns (NetworkConfig memory) {
        return getConfigByChainId(block.chainid);
    }
}
