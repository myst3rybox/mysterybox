// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "./IMysteryBox.sol";
/**
 * @title Invite contract
 *
 * @dev Implementation of the mystery box token.
 * @dev https://github.com/myst3rybox/mysterybox
*/

contract TestRecv is IERC1155Receiver{
    event OnERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes data
    );
    event OnERC1155BatchReceived(
        address operator,
        address from,
        uint256[] ids,
        uint256[] values,
        bytes data
    );
    event SupportsInterface(bytes4 interfaceId);
    event SendTo(address _box, address _to, uint256 _index);

    function sendTo(address _box, address _to, uint256 _index)
    public {
        emit SendTo(_box, _to, _index);
        IMysteryBox(_box).safeTransferFrom(address(this), _to, _index, 1, "");
    }
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) 
    public pure override 
    returns (bool) {
        //emit SupportsInterface(interfaceId);
        // return interfaceId == type(IERC165).interfaceId 
        // || interfaceId == type(IERC1155).interfaceId;
        return interfaceId == type(IERC1155).interfaceId;
    }

    // /**
    //  * @dev See {IERC165-supportsInterface}.
    //  */
    // function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
    //     return interfaceId == type(IERC1155).interfaceId
    //         || interfaceId == type(IERC1155MetadataURI).interfaceId
    //         || super.supportsInterface(interfaceId);
    // }
    /**
        @dev Handles the receipt of a single ERC1155 token type. This function is
        called at the end of a `safeTransferFrom` after the balance has been updated.
        To accept the transfer, this must return
        `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
        (i.e. 0xf23a6e61, or its own function selector).
        @param operator The address which initiated the transfer (i.e. msg.sender)
        @param from The address which previously owned the token
        @param id The ID of the token being transferred
        @param value The amount of tokens being transferred
        @param data Additional data with no specified format
        @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
    */
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    )
    public override 
    returns(bytes4){
        emit OnERC1155Received(operator, from, id, value, data);
        return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));
    }

    /**
        @dev Handles the receipt of a multiple ERC1155 token types. This function
        is called at the end of a `safeBatchTransferFrom` after the balances have
        been updated. To accept the transfer(s), this must return
        `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
        (i.e. 0xbc197c81, or its own function selector).
        @param operator The address which initiated the batch transfer (i.e. msg.sender)
        @param from The address which previously owned the token
        @param ids An array containing ids of each token being transferred (order and length must match values array)
        @param values An array containing amounts of each token being transferred (order and length must match ids array)
        @param data Additional data with no specified format
        @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
    */
    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    )
    public override
    returns(bytes4){
        emit OnERC1155BatchReceived(operator, from, ids, values, data);
        return bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"));
    }
}