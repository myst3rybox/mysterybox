const MysteryCosmicBoy = artifacts.require("MysteryCosmicBoy");
const MysteryYoloBoy = artifacts.require("MysteryYoloBoy");
const TestRecv = artifacts.require("TestRecv");

let author_address = "0xB4980aDF7247Ab15f9abca7Aa4Fa354790931F8e";
let max_quantity = 10000;
module.exports = function (deployer) {
    deployer.deploy(MysteryYoloBoy)
    .then(function () {
        // address _randomx, address _author, uint256 _max_quantity
        return deployer.deploy(MysteryCosmicBoy);
    })
    .then(function () {
        return deployer.deploy(TestRecv);
    })
    .then(function () {
        console.log("Deploy MysteryCosmicBoy: "+ MysteryCosmicBoy.address)
        console.log("Deploy MysteryYoloBoy: "+ MysteryYoloBoy.address)
        console.log("Deploy TestRecv: "+ TestRecv.address)
    })
};
