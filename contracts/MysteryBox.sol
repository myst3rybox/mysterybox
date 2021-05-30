// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;
/**
 * @title MysteryBox ERC1155 token
 *
 * @dev Implementation of the mystery box.
 * @dev https://github.com/myst3rybox/mysterybox
*/
import "./IMysteryBox.sol";
import "../libraries/SafeMath.sol";

contract MysteryBox is IMysteryBox, ERC1155 {
    using SafeMath for uint256;
    /*
        Datas
    */
    address public owner_address;
    // Mapping from caller address to access rights
    mapping(address => bool) public map_caller;
    // Mapping from mysterybox id to withdrawed
    mapping(uint256 => bool) public map_withdrawed;
    // Mysterybox informations
    uint256 public max_quantity;
    uint256 public box_quantity;
    address public author_address;
    struct attributes{
        uint256 block_number;
        uint256 price;
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
    modifier onlyCaller(){
        require(map_caller[msg.sender], "Not owner");
        _;
    }
    /*
        Events
    */
    // Called when box is generate.
    event GenerateBox(address owner, uint256 index);
    // Called when box is unboxed.
    event UnBox(address owner, uint256 index, uint256 open_block_number);
    // Called when owner changed.
    event ChangeOwner(address _newOwner);
    // Called when debug.
    event Debug(uint256 data, address addr);
    /**
    * @dev constructor that sets the random, author, max quantity and owner address
    * @param _author The address of author.
    * @param _max_quantity The max quantity.
    */
    constructor(address _author, uint256 _max_quantity) ERC1155("https://mysterynft.org/api/boy/{id}.json") {
        require(address(0) != _author, "author address is invalid.");
        owner_address = msg.sender;
        author_address = _author;
        max_quantity = _max_quantity;
        map_caller[msg.sender] = true;
    }    
    /**
    * @dev Change the owner of contract
    * @param _newOwner The address of new owner.
    */
    function changeOwner(address _newOwner)
    public override onlyOwner{
        require(address(0) != _newOwner, "Invalid owner address");
        owner_address = _newOwner;
        emit ChangeOwner(_newOwner);
    }
    /**
    * @dev set caller access rights.
    * @param _caller The address of caller.
    * @param _access The rights of access.
    */
    function setCaller(address _caller, bool _access)
    public onlyOwner{
        map_caller[_caller] = _access;
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
    * @param _to The address of customer.
    * @param _counts The number of boxes that will be generated.
    */
    function generate(address _to, uint256 _counts) 
    public onlyCaller override{
        require(box_quantity.add(_counts) <= max_quantity, "Max quantity limited.");
        for (uint256 index = 0; index < _counts; index++) {
            _mint(_to, box_quantity, 1, "");  
            attributes memory attr = attributes({block_number:0, price:99*10**6, name:""}); // price is 99 USDT
            boxes_attributes.push(attr);
            box_quantity = box_quantity.add(1);
            emit GenerateBox(_to, box_quantity);
        }
    }
    /**
    * @dev Unbox.
    * @param _boxes The arrary of boxes that will be unboxed.
    */
    function unBox(uint256[] memory _boxes) 
    public override{
        require(_isEOA(msg.sender), "Not EOA.");
        require(_boxes.length <= 12, "Max box counts limited.");
        for (uint256 index = 0; index < _boxes.length; index++) {
            require(balanceOf(msg.sender, _boxes[index]) > 0, "Not this box's owner");
            require(boxes_attributes[_boxes[index]].block_number == 0, "Box has been opened");
            // set block number
            boxes_attributes[_boxes[index]].block_number = block.number.add(2);
            emit UnBox(msg.sender, _boxes[index], boxes_attributes[_boxes[index]].block_number);
        }
    }
    /**
    * @dev Withdraw a CASH box.
    * @param _index The index of box that is CASH level.
    */
    function withdrawCash(uint256 _index)
    public onlyCaller override{
        require(!map_withdrawed[_index], "This cash box had been withdrawed");
        uint256 level;
        (, , level, , ) = getAttributes(_index);
        require(level == 6, "Not a CASH level box");
        map_withdrawed[_index] = true;
    }
    /**
    * @dev Get attributes by index of boxes.
    * @param _index The index of box.
    * @return block_number The block number of open
    * @return types The types of box
    * @return level The level of box
    * @return price The price of box
    * @return name The name of box
    */
    function getAttributes(uint256 _index) 
    public view override 
    returns(uint256 block_number, uint256 types, uint256 level, uint256 price, string memory name){
        attributes memory attr = boxes_attributes[_index];
        if( 0 == attr.block_number || attr.block_number > block.number){
            types = 0;
            level = 0;
        }else{
            uint256 randomX = uint256(keccak256(abi.encodePacked(blockhash(attr.block_number), _index)));
            uint256 random_type = randomX % 100;
            if(random_type == 99){
                // types(12)    1%
                types = 12;
            }else{
                // types(1~11)
                types = random_type % 11 + 1;
            }
            randomX = uint256(keccak256(abi.encodePacked(randomX, _index)));
            uint256 random_level = randomX % 100;
            if(random_level < 50){
                // 50% Universal
                level = 1;
            }else if(random_level < 80){
                // 30% Rare
                level = 2;
            }else if(random_level < 92){
                // 12% Epical
                level = 3;
            }else if(random_level < 97){
                // 5% Legendary
                level = 4;
            }else if(random_level < 99){
                // 2% Mythic
                level = 5;
            }else{
                // 1% CASH
                level = 6;
            }
        }
        price = attr.price;
        name = attr.name;
        block_number = attr.block_number;
    }
    /**
    * @dev Change the name of box.
    * @param _index The index of box.
    * @param _name The new name of box.
    */
    function changeName(uint256 _index, string memory _name) 
    public override {
        require(balanceOf(msg.sender, _index) > 0, "Not this box's owner");
        boxes_attributes[_index].name = _name;
    }
    /**
    * @dev Check whether address belongs to a EOA
    * @param addr The address of user.
    * @return bool
    */
    function _isEOA(address addr) 
    internal view
    returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return size == 0 && (tx.origin == msg.sender);
    }
}
