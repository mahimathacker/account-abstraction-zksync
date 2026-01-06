// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {MinimalAccount} from "../src/ethereum/minimalaccount.sol";
import  { Script } from "forge-std/Script.sol";

contract SendPackedUserOp is Script {
    function run() public {
        vm.startBroadcast();
        MinimalAccount minimalAccount = new MinimalAccount(address(this));
        vm.stopBroadcast();
    }
}