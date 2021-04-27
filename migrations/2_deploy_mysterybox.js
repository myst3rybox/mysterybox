const RandomX = artifacts.require("RandomX");
const MysteryBox = artifacts.require("MysteryBox");
const TestRecv = artifacts.require("TestRecv");

module.exports = function (deployer) {
    deployer.deploy(RandomX)
    .then(function () {
        // address _randomx, address _author, uint256 _max_quantity
        return deployer.deploy(MysteryBox, RandomX.address, "0xB4980aDF7247Ab15f9abca7Aa4Fa354790931F8e", 10);
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
