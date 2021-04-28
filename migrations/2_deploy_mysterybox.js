const RandomX = artifacts.require("RandomX");
const MysteryBox = artifacts.require("MysteryBox");
const TestRecv = artifacts.require("TestRecv");

let author_address = "0xB4980aDF7247Ab15f9abca7Aa4Fa354790931F8e";
let max_quantity = 10000;
module.exports = function (deployer) {
    deployer.deploy(RandomX)
    .then(function () {
        // address _randomx, address _author, uint256 _max_quantity
        return deployer.deploy(MysteryBox, RandomX.address, author_address, max_quantity);
    })
    .then(function () {
        return deployer.deploy(TestRecv);
    })
    .then(function () {
        console.log("Deploy RandomX: "+ RandomX.address)
        console.log("Deploy MysteryBox: "+ MysteryBox.address)
        console.log("Deploy TestRecv: "+ TestRecv.address)
    })
};
