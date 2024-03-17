// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {GamerzToken} from "../src/GamerzToken.sol";
import {DeployGamerzToken} from "../script/DeployGamerzToken.s.sol";

contract TestToken is Test {

    GamerzToken public token;
    DeployGamerzToken public deployer;

    // Creating addresses
    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant BOB_STARTING_BALANCE = 100 ether;
    uint256 public constant ALICE_STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployGamerzToken();
        token = deployer.run();

        vm.prank(msg.sender);
        token.transfer(bob, BOB_STARTING_BALANCE);

        vm.prank(msg.sender);
        token.transfer(alice, ALICE_STARTING_BALANCE);
    }

    function testBobBalance() view public {
        assertEq(BOB_STARTING_BALANCE, token.balanceOf(bob));
    }

    function testAliceBalance() view public {
        assertEq(ALICE_STARTING_BALANCE, token.balanceOf(alice));
    }

    function testAllowances() public {
        uint256 initialAllowance = 100 ether; // Setting an initial allowance by bob for alice to spend
        
        vm.prank(bob);
        token.approve(alice, initialAllowance); // We approve of alice to spend tokens from bob's account 
        uint256 transferAmount = 50 ether; // Transfer a specific amount

        vm.prank(alice);
        token.transferFrom(bob, alice, transferAmount); // Transfer the amount from bob's account to alices'
        assertEq(token.balanceOf(alice), ALICE_STARTING_BALANCE + transferAmount);
        assertEq(token.balanceOf(bob), BOB_STARTING_BALANCE - transferAmount);
    }
}