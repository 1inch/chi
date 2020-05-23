pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/Math.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";


contract ChiToken is ERC20Burnable {

    uint256 public totalBurned;

    constructor () ERC20("Chi Token by 1inch", "CHI") public {

        _setupDecimals(0);
    }

    function mint(uint256 value) public {
        uint256 offset = totalSupply();
        assembly {
            mstore(0, 0x756e4946c0e9f43f4dee607b0ef1fa1c3318585733ff6000526016600af300)

            for {let i := div(value, 32)} i {i := sub(i, 1)} {
                pop(create2(0, 0, 29, add(offset, 0))) pop(create2(0, 0, 29, add(offset, 1)))
                pop(create2(0, 0, 29, add(offset, 2))) pop(create2(0, 0, 29, add(offset, 3)))
                pop(create2(0, 0, 29, add(offset, 4))) pop(create2(0, 0, 29, add(offset, 5)))
                pop(create2(0, 0, 29, add(offset, 6))) pop(create2(0, 0, 29, add(offset, 7)))
                pop(create2(0, 0, 29, add(offset, 8))) pop(create2(0, 0, 29, add(offset, 9)))
                pop(create2(0, 0, 29, add(offset, 10))) pop(create2(0, 0, 29, add(offset, 11)))
                pop(create2(0, 0, 29, add(offset, 12))) pop(create2(0, 0, 29, add(offset, 13)))
                pop(create2(0, 0, 29, add(offset, 14))) pop(create2(0, 0, 29, add(offset, 15)))
                pop(create2(0, 0, 29, add(offset, 16))) pop(create2(0, 0, 29, add(offset, 17)))
                pop(create2(0, 0, 29, add(offset, 18))) pop(create2(0, 0, 29, add(offset, 19)))
                pop(create2(0, 0, 29, add(offset, 20))) pop(create2(0, 0, 29, add(offset, 21)))
                pop(create2(0, 0, 29, add(offset, 22))) pop(create2(0, 0, 29, add(offset, 23)))
                pop(create2(0, 0, 29, add(offset, 24))) pop(create2(0, 0, 29, add(offset, 25)))
                pop(create2(0, 0, 29, add(offset, 26))) pop(create2(0, 0, 29, add(offset, 27)))
                pop(create2(0, 0, 29, add(offset, 28))) pop(create2(0, 0, 29, add(offset, 29)))
                pop(create2(0, 0, 29, add(offset, 30))) pop(create2(0, 0, 29, add(offset, 31)))
                offset := add(offset, 32)
            }
            for {let i := and(value, 0x1F)} i {i := sub(i, 1)} {
                pop(create2(0, 0, 29, add(offset, i)))
            }
        }
        _mint(msg.sender, value);
    }

    function computeAddress2(uint256 salt) public view returns (address) {
        return address(bytes20(keccak256(
                abi.encodePacked(
                    bytes1(0xff),
                    address(this),
                    salt,
                    bytes32(0x3e9c419d1edb630242ffd4382718b4a8e6c2c90ba801cca9e55f90b56af3bda0)
                ))));
    }

    function _destroyChildren(uint256 value) internal {
        uint256 _totalBurned = totalBurned;
        for (uint256 i = _totalBurned + 1; i <= _totalBurned + value; i++) {
            computeAddress2(i).call("");
        }
        totalBurned = _totalBurned + value;
    }

    function free(uint256 value) public {
        _burn(msg.sender, value);
        _destroyChildren(value);
    }

    function freeUpTo(uint256 value) public returns (uint256 amount) {
        amount = Math.min(value, balanceOf(msg.sender));
        _burn(msg.sender, amount);
        _destroyChildren(amount);
    }

    function freeFrom(address from, uint256 value) public {
        _burn(from, value);
        _destroyChildren(value);
    }

    function freeFromUpTo(address from, uint256 value) public returns (uint256 amount) {
        amount = Math.min(Math.min(value, balanceOf(from)), allowance(from, msg.sender));
        _burn(from, amount);
        _destroyChildren(amount);
    }
}
