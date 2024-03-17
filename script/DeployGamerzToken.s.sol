// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {GamerzToken} from "../src/GamerzToken.sol";
import {Script} from "forge-std/Script.sol";

contract DeployGamerzToken is Script {

    GamerzToken token;

    function run() external returns(GamerzToken) {
        vm.startBroadcast();
        token = new GamerzToken("GamerzToken", "GZT");
        vm.stopBroadcast();
        return token;
    }
}