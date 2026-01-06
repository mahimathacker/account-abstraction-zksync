// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {MinimalAccount} from "../src/ethereum/minimalaccount.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployMinimal {
    function run() public {}

    function deployMinimal() public {
        HelperConfig helperConfig = new HelperConfig();
        HelperConfig.NetworkConfig memory networkConfig = helperConfig.getConfig();

        MinimalAccount minimalAccount = new MinimalAccount(networkConfig.entryPoint);
    }
}