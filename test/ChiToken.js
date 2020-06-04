const { BN, expectRevert, send, ether } = require('@openzeppelin/test-helpers');
const ChiToken = artifacts.require('ChiToken');
const TestHelper = artifacts.require('TestHelper');

contract('ChiToken', async accounts => {
    describe('ChiToken', async function() {
        before(async function() {
            await send.ether(accounts[0], '0x7E1E3334130355799F833ffec2D731BCa3E68aF6', ether('10'));
            this.chiToken = await ChiToken.new({from: '0x7E1E3334130355799F833ffec2D731BCa3E68aF6'});
            this.testHelper = await TestHelper.new();
        });

        it('Should have right contract address', async function () {
            expect(this.chiToken.address).to.be.equal('0x0000000000004946c0e9F43F4Dee607b0eF1fA1c');
            // expect(this.chiToken.address).to.be.equal('0x000000000097f1f995665BE2191193a57c68992C');
        });

        it('Should mint', async function () {
            await this.chiToken.mint(200);
            expect((await this.chiToken.totalSupply()).toString()).to.be.equal('200');
            expect(await this.chiToken.computeAddress2(0)).to.be.equal('0x78D8a376e10F1098d9025A50B0fdAC3954572c8A');
        });

        it('Should fail to free up', async function () {
            expectRevert(this.chiToken.free(100, {from: accounts[3]}), 'ERC20: burn amount exceeds balance');
        });

        it('Should burnGasAndFreeFrom', async function () {
            await this.chiToken.mint(100);
            await this.chiToken.approve(this.testHelper.address, 50);
            await this.testHelper.burnGasAndFreeFrom(this.chiToken.address, 5000000, 50);
            expect((await this.chiToken.totalSupply()).toString()).to.be.equal('250');
        });

        it('Should burnGasAndFree', async function () {
            await this.chiToken.transfer(this.testHelper.address, 75);
            await this.testHelper.burnGasAndFree(this.chiToken.address, 5000000, 75);
            expect((await this.chiToken.totalSupply()).toString()).to.be.equal('175');
        });

        it('Should burnGasAndFreeUpTo', async function () {
            await this.chiToken.mint(75);
            await this.chiToken.transfer(this.testHelper.address, 75);
            await this.testHelper.burnGasAndFreeUpTo(this.chiToken.address, 5000000, 75);
            expect((await this.chiToken.totalSupply()).toString()).to.be.equal('175');
        });

        it('Should burnGasAndFreeFromUpTo', async function () {
            await this.chiToken.mint(100);
            await this.chiToken.approve(this.testHelper.address, 70);
            await this.testHelper.burnGasAndFreeFromUpTo(this.chiToken.address, 5000000, 70);
            expect((await this.chiToken.totalSupply()).toString()).to.be.equal('205');
        });
    });
});
