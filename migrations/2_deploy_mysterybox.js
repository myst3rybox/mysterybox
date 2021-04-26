const RandomX = artifacts.require("RandomX");
const MysteryBox = artifacts.require("MysteryBox");

module.exports = function (deployer) {
    deployer.deploy(RandomX)
    .then(function () {
        // address _randomx, address _author, uint256 _max_quantity
        return deployer.deploy(MysteryBox, RandomX.address, "0xB4980aDF7247Ab15f9abca7Aa4Fa354790931F8e", 10);
    })
};
