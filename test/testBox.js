const RandomX = artifacts.require("RandomX");
const MysteryBox = artifacts.require("MysteryBox");
const TestRecv = artifacts.require("TestRecv");

contract("MysteryBox", accounts => {
    it("RandomX should set caller.", async () => {
        let randomX = await RandomX.deployed();
        let instance = await MysteryBox.deployed();
        await randomX.SetCaller(instance.address, 1);
        
        let allowed = await randomX.caller_addresses.call(instance.address);
        assert.equal(
            allowed, 1,
            "RandomX caller address NOT match."
        );
    });
    it("MysteryBox should get author.", async () => {
        let instance = await MysteryBox.deployed();
        author_address = await instance.getAuthor();
        assert.equal(
            author_address, "0xB4980aDF7247Ab15f9abca7Aa4Fa354790931F8e",
            "MysteryBox author address NOT match."
        );
    });
    it("MysteryBox should get quantity.", async () => {
        let instance = await MysteryBox.deployed();
        let quantity = await instance.max_quantity.call();
        assert.equal(
            quantity, 10000,
            "MysteryBox quantity NOT match."
        );
    });
    it("MysteryBox should set caller.", async () => {
        let instance = await MysteryBox.deployed();
        await instance.setCaller(accounts[9], true);
        let rights = await instance.map_caller.call(accounts[9]);
        assert.equal(
            rights, true,
            "MysteryBox caller NOT match."
        );
    });
    it("MysteryBox should generate box.", async () => {
        let instance = await MysteryBox.deployed();
        await instance.generate(accounts[1], 3, {from: accounts[9]});
        quantity = await instance.box_quantity.call();
        assert.equal(
            quantity, 3,
            "MysteryBox generate box quantity is NOT match."
        );
    });
    it("MysteryBox should unbox.", async () => {
        let instance = await MysteryBox.deployed();
        await instance.unBox([0,1], {from:accounts[1]});
        let attr = await instance.getAttributes(0);
        console.log(JSON.stringify(attr));
        assert.equal(
            attr.price, 99*10**6,
            "MysteryBox unbox price is NOT match."
        );
    });
    it("MysteryBox should change name.", async () => {
        let instance = await MysteryBox.deployed();
        let name = "Hello Kitty";
        await instance.changeName(0, name, {from:accounts[1]});
        let attr = await instance.getAttributes(0);
        console.log(JSON.stringify(attr));
        assert.equal(
            attr.name, name,
            "MysteryBox change name is NOT match."
        );
    });
    it("MysteryBox should transfer to other user.", async () => {
        let instance = await MysteryBox.deployed();
        let box_index = 0;
        await instance.safeTransferFrom(accounts[1], accounts[2], box_index, 1, "0x0", {from:accounts[1]});
        let balance = await instance.balanceOf(accounts[2], box_index);
        assert.equal(
            balance, 1,
            "MysteryBox transfer to user is NOT match."
        );
    });
    it("MysteryBox should transfer to contract.", async () => {
        let instance = await MysteryBox.deployed();
        let test = await TestRecv.deployed();
        let box_index = 1;
        await instance.safeTransferFrom(accounts[1], test.address, box_index, 1, "0x0", {from:accounts[1]});
        let balance = await instance.balanceOf(TestRecv.address, box_index);
        assert.equal(
            balance, 1,
            "MysteryBox transfer to contract is NOT match."
        );
    });
    it("MysteryBox should transfer from contract.", async () => {
        let instance = await MysteryBox.deployed();
        let test = await TestRecv.deployed();
        let box_index = 1;
        console.log(instance.address, accounts[0]);
        await test.sendTo(instance.address, accounts[0], box_index);
        let balance = await instance.balanceOf(accounts[0], box_index);
        assert.equal(
            balance, 1,
            "MysteryBox transfer from contract is NOT match."
        );
    });
})