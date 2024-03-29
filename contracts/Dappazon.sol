// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Dappazon {
    address public owner;

    //Defining the item structure
    struct Item {
        uint256 id;
        string name;
        string category;
        string image;
        uint256 cost;
        uint256 rating;
        uint256 stock;
    }

    //Defining the order structure
    struct Order {
        uint256 time;
        Item item;
    }

    //Defining of events to be emitted on listing or buying of items
    event List(string name, uint256 cost, uint256 quantity);
    event Buy(address buyer, uint256 orderId, uint256 itemId);
    
    //defining required mappings
    mapping(uint256 => Item) public items;
    mapping(address => mapping(uint256 => Order)) public orders;
    mapping(address => uint256) public orderCount;

    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // List Products
    function list(
        uint256 _id,
        string memory _name,
        string memory _category,
        string memory _image,
        uint256 _cost,
        uint256 _rating,
        uint256 _stock
    ) public onlyOwner {
        //Create product struct
        Item memory item = Item(
            _id,
            _name,
            _category,
            _image,
            _cost,
            _rating,
            _stock
        );

        // Save item strcut to blockchain
        items[_id] = item;

        //emit an event
        emit List(_name, _cost, _stock);
    }

    //Buy products
    function buy(uint256 _id) public payable {
        // ftech item

        Item memory item = items[_id];
        //create the order

        require(msg.value>= item.cost);

        require(item.stock>0);

        Order memory order = Order(block.timestamp, item);

        //Save order to chain
        orderCount[msg.sender]++;
        orders[msg.sender][orderCount[msg.sender]] = order;

        //subtract stock
        items[_id].stock = item.stock - 1;

        //emit event
        emit Buy(msg.sender, orderCount[msg.sender], item.id);
    }
   
}
