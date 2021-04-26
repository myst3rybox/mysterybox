// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
/**
 * @dev Interface of the MysteryBox.
 */
interface IMysteryBox is IERC1155 {
    function generateBoxes(uint256 _counts) external;
    function unBox(uint256[] memory _boxes) external;
}