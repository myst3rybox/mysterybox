// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;
/**
 * @title MysteryBox ERC1155 token
 *
 * @dev Implementation of the mystery box.
 * @dev https://github.com/myst3rybox/mysterybox
*/
import "./MysteryBox.sol";

contract MysteryCosmicBoy is MysteryBox{
    constructor() MysteryBox(0x28F465ce9ef7447d04C27E9615677946EF6A3c89, 10000){
        owner_address = msg.sender;
        author_address = 0x28F465ce9ef7447d04C27E9615677946EF6A3c89;
        max_quantity = 10000;
        map_caller[msg.sender] = true;
    }
}
