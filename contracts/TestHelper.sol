pragma solidity ^0.6.0;

interface Token {
    function free(uint256 value) external returns (uint256);
    function freeUpTo(uint256 value) external returns (uint256);
    function freeFrom(address from, uint256 value) external returns (uint256);
    function freeFromUpTo(address from, uint256 value) external returns (uint256);
}

contract TestHelper {

    function dummy() public {
        assembly{
            invalid()
        }
    }

    // Burns at least burn gas by calling itself and throwing
    function burnGas(uint256 burn) public {
        // call self.dummy() to burn a bunch of gas
        assembly {
            mstore(0x0, 0x32e43a1100000000000000000000000000000000000000000000000000000000)
            let ret := call(burn, address(), 0, 0x0, 0x04, 0x0, 0)
        }
    }

    function burnGasAndFree(address gas_token, uint256 burn, uint256 free) public {
        burnGas(burn);
        require(Token(gas_token).free(free) > 0, "burnGasAndFree");
    }

    function burnGasAndFreeUpTo(address gas_token, uint256 burn, uint256 free) public {
        burnGas(burn);
        require(free == Token(gas_token).freeUpTo(free), "burnGasAndFreeUpTo");
    }

    function burnGasAndFreeFrom(address gas_token, uint256 burn, uint256 free) public {
        burnGas(burn);
        require(Token(gas_token).freeFrom(tx.origin, free) > 0, "burnGasAndFreeFrom");
    }

    function burnGasAndFreeFromUpTo(address gas_token, uint256 burn, uint256 free) public {
        burnGas(burn);
        require(free == Token(gas_token).freeFromUpTo(tx.origin, free), "burnGasAndFreeFromUpTo");
    }
}
