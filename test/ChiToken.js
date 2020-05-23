const { BN, expectRevert, send, ether } = require('@openzeppelin/test-helpers');
const ChiToken = artifacts.require('ChiToken');

contract('ChiToken', async accounts => {
    describe('ChiToken', async function() {
        before(async function() {
            await send.ether(accounts[0], '0x7E1E3334130355799F833ffec2D731BCa3E68aF6', ether('10'));
            this.chiToken = await ChiToken.new({from: '0x7E1E3334130355799F833ffec2D731BCa3E68aF6'});
        });

        it('Should have right contract address', async function () {
            expect(this.chiToken.address).to.be.equal('0x0000000000004946c0e9F43F4Dee607b0eF1fA1c');
        });

        it('Should mint', async function () {
            await this.chiToken.mint(100);
            expect((await this.chiToken.totalSupply()).toString()).to.be.equal('100');
        });

        it('Should fail to free up', async function () {
            expectRevert(this.chiToken.free(100, {from: accounts[3]}), 'ERC20: burn amount exceeds balance');
        });

        it('Should free up', async function () {
            await this.chiToken.free(100);
            expect((await this.chiToken.totalSupply()).toString()).to.be.equal('0');
        });
    });
});
