// SPDX-License-Identifier: SimPL-2.0
pragma solidity ^0.8.3;
/**
 * @dev Interface of the RandomX。
 */
interface iRandomX {
    function SetCaller(address _caller, uint256 _allowed) external;
    function AddRandomSeed(uint256 _seed) external;
    function GetRandomX() external returns(uint256 random_number);
}