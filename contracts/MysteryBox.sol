// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;
/**
 * @title MysteryBox ERC1155 token
 *
 * @dev Implementation of the mystery box.
 * @dev https://github.com/myst3rybox/solidity
*/
import "./IMysteryBox.sol";
import "../interfaces/iRandomX.sol";
import "../libraries/SafeMath.sol";
contract MysteryBox is IMysteryBox, ERC1155 {
    using SafeMath for uint256;
    /*
        Datas
    */
    address public owner_address;
    uint256 public max_quantity;
    uint256 public box_quantity;
    address public randomx_address;
    address public author_address;
    uint256 public sell_price = 99*10**6; // price is 99 USDT
    struct attributes{
        uint256 types;
        uint256 level;
        uint256 price;
        uint256 status; // 0:boxed, 1:unboxed, 2:on auction, 3:swapping
        string name;
    }
    attributes[] public boxes_attributes;
    /*
        Modifyer
    */
    modifier onlyOwner(){
        require(msg.sender == owner_address, "Not owner");
        _;
    }
    /*
        Events
    */
    // Called when owner changed.
    event GenerateBox(address owner, uint256 index);
    // Called when box is unboxed.
    event UnBox(address owner, uint256 index, uint256 types, uint256 level);
    /**
    * @dev constructor that sets the random, author, max quantity and owner address
    * @param _randomx The address of RandomX contract.
    * @param _author The address of author.
    * @param _max_quantity The max quantity.
    */
    constructor(address _randomx, address _author, uint256 _max_quantity) ERC1155("https://game.example/api/item/{id}.json") {
        require(address(0) != _randomx, "randomx contract address is invalid.");
        require(address(0) != _author, "author address is invalid.");
        owner_address = msg.sender;
        randomx_address = _randomx;
        author_address = _author;
        max_quantity = _max_quantity;
    }
    /**
    * @dev get author address.
    * @return The address of author.
    */
    function getAuthor() 
    public view override
    returns(address){
        return author_address;
    }
    /**
    * @dev get author address.
    * @return The max quantity of box.
    */
    function getQuantity() 
    public view override
    returns(uint256){
        return box_quantity;
    }
    /**
    * @dev generate boxes.
    * @param _counts The number of boxes that will be generated.
    */
    function generate(uint256 _counts) 
    public onlyOwner override{
        require(box_quantity.add(_counts) <= max_quantity, "Max quantity limited.");
        if(!isApprovedForAll(msg.sender, address(this))){
            setApprovalForAll(address(this), true);
        }
        for (uint256 index = 0; index < _counts; index++) {
            _mint(msg.sender, box_quantity, 1, "");  
            attributes memory attr = attributes({types:0, level:0, price:sell_price, status:0, name:""});
            boxes_attributes.push(attr);
            box_quantity = box_quantity.add(1);
            emit GenerateBox(msg.sender, box_quantity);
        }
    }
    /**
    * @dev Unbox.
    * @param _boxes The arrary of boxes that will be unboxed.
    */
    function unBox(uint256[] memory _boxes) 
    public override{
        require(_boxes.length < 12, "Max box counts limited.");
        for (uint256 index = 0; index < _boxes.length; index++) {
            require(balanceOf(msg.sender, _boxes[index]) > 0, "Not this box's owner");
            attributes memory attr = boxes_attributes[_boxes[index]];
            require(attr.level == 0 && attr.types == 0, "Box has been opened");
            uint256 random_type = iRandomX(randomx_address).GetRandomX() % 100;
            if(random_type == 99){
                // types(12)    1%
                boxes_attributes[_boxes[index]].types = 12;
            }else{
                // types(1~11)
                boxes_attributes[_boxes[index]].types = random_type % 11 + 1;
            }
            uint256 random_level = iRandomX(randomx_address).GetRandomX() % 100;
            if(random_level < 50){
                // 50% Universal
                boxes_attributes[_boxes[index]].level = 1;
            }else if(random_level < 80){
                // 30% Rare
                boxes_attributes[_boxes[index]].level = 2;
            }else if(random_level < 92){
                // 12% Epical
                boxes_attributes[_boxes[index]].level = 3;
            }else if(random_level < 97){
                // 5% Legendary
                boxes_attributes[_boxes[index]].level = 4;
            }else if(random_level < 99){
                // 2% Mythic
                boxes_attributes[_boxes[index]].level = 5;
            }else{
                // 1% CASH
                boxes_attributes[_boxes[index]].level = 6;
            }
            boxes_attributes[_boxes[index]].status = 1;
            emit UnBox(msg.sender, index, boxes_attributes[_boxes[index]].types, boxes_attributes[_boxes[index]].level);
        }
    }
    function getAttributes(uint256 _index) 
    public view override 
    returns(uint256 types, uint256 level, uint256 price, uint256 status, string memory name){
        attributes memory attr = boxes_attributes[_index];
        types = attr.types;
        level = attr.level;
        price = attr.price;
        status = attr.status;
        name = attr.name;
    }
    function changeName(uint256 _index, string memory _name) 
    public override {
        require(balanceOf(msg.sender, _index) > 0, "Not this box's owner");
        boxes_attributes[_index].name = _name;
    }
}
