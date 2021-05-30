// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
/**
 * @dev Interface of the MysteryBox.
 */
interface IMysteryBox is IERC1155 {
    function changeOwner(address _newOwner) external;
    function getAuthor() external view returns(address);
    function getQuantity() external view returns(uint256);
    function generate(address _to, uint256 _counts) external;
    function unBox(uint256[] memory _boxes) external;
    function withdrawCash(uint256 _index) external;
    function getAttributes(uint256 _index) external returns(uint256 block_number, uint256 types, uint256 level, uint256 price, string memory name);
    function changeName(uint256 _index, string memory _name) external;
}