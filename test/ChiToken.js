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
        });

        it('Should mint', async function () {
            await this.chiToken.mint(1000);
            expect((await this.chiToken.totalSupply()).toString()).to.be.equal('1000');
            expect(await this.chiToken.computeAddress2(0)).to.be.equal('0x02743b329444162cbc3199958887a7C6294013c0');
            // expect(await this.chiToken.codeAt(await this.chiToken.computeAddress2(0))).to.be.equal('0x756d4946c0e9f43f4dee607b0ef1fa1c3318585733ff6000526016600af3');
            //
            // const code = await web3.eth.getCode(await this.chiToken.computeAddress2(0));
            // expect(code.toString('hex')).to.be.equal('0x756e4946c0e9f43f4dee607b0ef1fa1c3318585733ff6000526016600af3');
        });

        it('Should fail to free up', async function () {
            expectRevert(this.chiToken.free(100, {from: accounts[3]}), 'ERC20: burn amount exceeds balance');
        });

        it('Should free up', async function () {
            await this.chiToken.approve(this.testHelper.address, 200);
            await this.testHelper.burnGasAndFreeFrom(this.chiToken.address, 5000000, 200);
            // await this.chiToken.free(100);
            expect((await this.chiToken.totalSupply()).toString()).to.be.equal('800');
        });
    });
});
