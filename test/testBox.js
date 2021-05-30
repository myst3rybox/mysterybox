const MysteryCosmicBoy = artifacts.require("MysteryCosmicBoy");
const TestRecv = artifacts.require("TestRecv");

contract("MysteryCosmicBoy", accounts => {
    it("MysteryCosmicBoy should get author.", async () => {
        let instance = await MysteryCosmicBoy.deployed();
        author_address = await instance.getAuthor();
        assert.equal(
            author_address, "0x28F465ce9ef7447d04C27E9615677946EF6A3c89",
            "MysteryCosmicBoy author address NOT match."
        );
    });
    it("MysteryCosmicBoy should get quantity.", async () => {
        let instance = await MysteryCosmicBoy.deployed();
        let quantity = await instance.max_quantity.call();
        assert.equal(
            quantity, 10000,
            "MysteryCosmicBoy quantity NOT match."
        );
    });
    it("MysteryCosmicBoy should set caller.", async () => {
        let instance = await MysteryCosmicBoy.deployed();
        await instance.setCaller(accounts[9], true);
        let rights = await instance.map_caller.call(accounts[9]);
        assert.equal(
            rights, true,
            "MysteryCosmicBoy caller NOT match."
        );
    });
    it("MysteryCosmicBoy should generate box.", async () => {
        let instance = await MysteryCosmicBoy.deployed();
        await instance.generate(accounts[1], 3, {from: accounts[9]});
        quantity = await instance.box_quantity.call();
        assert.equal(
            quantity, 3,
            "MysteryCosmicBoy generate box quantity is NOT match."
        );
    });
    it("MysteryCosmicBoy should unbox.", async () => {
        let instance = await MysteryCosmicBoy.deployed();
        await instance.unBox([0,1], {from:accounts[1]});
        let attr = await instance.getAttributes(0);
        console.log(JSON.stringify(attr));
        assert.equal(
            attr.price, 99*10**6,
            "MysteryCosmicBoy unbox price is NOT match."
        );
    });
    it("MysteryCosmicBoy should change name.", async () => {
        let instance = await MysteryCosmicBoy.deployed();
        let name = "Hello Kitty";
        await instance.changeName(0, name, {from:accounts[1]});
        let attr = await instance.getAttributes(0);
        console.log(JSON.stringify(attr));
        assert.equal(
            attr.name, name,
            "MysteryCosmicBoy change name is NOT match."
        );
    });
    it("MysteryCosmicBoy should transfer to other user.", async () => {
        let instance = await MysteryCosmicBoy.deployed();
        let box_index = 0;
        await instance.safeTransferFrom(accounts[1], accounts[2], box_index, 1, "0x0", {from:accounts[1]});
        let balance = await instance.balanceOf(accounts[2], box_index);
        assert.equal(
            balance, 1,
            "MysteryCosmicBoy transfer to user is NOT match."
        );
    });
    it("MysteryCosmicBoy should transfer to contract.", async () => {
        let instance = await MysteryCosmicBoy.deployed();
        let test = await TestRecv.deployed();
        let box_index = 1;
        await instance.safeTransferFrom(accounts[1], test.address, box_index, 1, "0x0", {from:accounts[1]});
        let balance = await instance.balanceOf(TestRecv.address, box_index);
        assert.equal(
            balance, 1,
            "MysteryCosmicBoy transfer to contract is NOT match."
        );
    });
    it("MysteryCosmicBoy should transfer from contract.", async () => {
        let instance = await MysteryCosmicBoy.deployed();
        let test = await TestRecv.deployed();
        let box_index = 1;
        console.log(instance.address, accounts[0]);
        await test.sendTo(instance.address, accounts[0], box_index);
        let balance = await instance.balanceOf(accounts[0], box_index);
        assert.equal(
            balance, 1,
            "MysteryCosmicBoy transfer from contract is NOT match."
        );
    });
})