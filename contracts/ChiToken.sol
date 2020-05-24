pragma solidity ^0.5.0;

import "@openzeppelin/contracts/math/Math.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";


contract ChiToken is ERC20Burnable, ERC20Detailed {

    uint256 public totalBurned;

    constructor () ERC20Detailed("Chi Token by 1inch", "CHI", 0) public {

    }

    function mint(uint256 value) public {
        uint256 offset = totalSupply() + totalBurned;
        assembly {
            mstore(0, 0x756d4946c0e9f43f4dee607b0ef1fa1c3318585733ff6000526016600af30000)

            for {let i := div(value, 32)} i {i := sub(i, 1)} {
                pop(create2(0, 0, 30, add(offset, 0))) pop(create2(0, 0, 30, add(offset, 1)))
                pop(create2(0, 0, 30, add(offset, 2))) pop(create2(0, 0, 30, add(offset, 3)))
                pop(create2(0, 0, 30, add(offset, 4))) pop(create2(0, 0, 30, add(offset, 5)))
                pop(create2(0, 0, 30, add(offset, 6))) pop(create2(0, 0, 30, add(offset, 7)))
                pop(create2(0, 0, 30, add(offset, 8))) pop(create2(0, 0, 30, add(offset, 9)))
                pop(create2(0, 0, 30, add(offset, 10))) pop(create2(0, 0, 30, add(offset, 11)))
                pop(create2(0, 0, 30, add(offset, 12))) pop(create2(0, 0, 30, add(offset, 13)))
                pop(create2(0, 0, 30, add(offset, 14))) pop(create2(0, 0, 30, add(offset, 15)))
                pop(create2(0, 0, 30, add(offset, 16))) pop(create2(0, 0, 30, add(offset, 17)))
                pop(create2(0, 0, 30, add(offset, 18))) pop(create2(0, 0, 30, add(offset, 19)))
                pop(create2(0, 0, 30, add(offset, 20))) pop(create2(0, 0, 30, add(offset, 21)))
                pop(create2(0, 0, 30, add(offset, 22))) pop(create2(0, 0, 30, add(offset, 23)))
                pop(create2(0, 0, 30, add(offset, 24))) pop(create2(0, 0, 30, add(offset, 25)))
                pop(create2(0, 0, 30, add(offset, 26))) pop(create2(0, 0, 30, add(offset, 27)))
                pop(create2(0, 0, 30, add(offset, 28))) pop(create2(0, 0, 30, add(offset, 29)))
                pop(create2(0, 0, 30, add(offset, 30))) pop(create2(0, 0, 30, add(offset, 31)))
                offset := add(offset, 32)
            }

            for {let i := and(value, 0x1F)} i {i := sub(i, 1)} {
                pop(create2(0, 0, 30, add(offset, i)))
            }
        }

        _mint(msg.sender, value);
    }

    function computeAddress2(uint256 salt) public view returns (address) {
        bytes32 _data = keccak256(
            abi.encodePacked(bytes1(0xff), address(this), salt, bytes32(0xc5bc5cd87d59dc45033753f4f923401054da10c6d304da2848e2df1198fea79d))
        );
        return address(bytes20(_data << 96));
    }

    function _destroyChildren(uint256 value) internal {
        uint256 _totalBurned = totalBurned;
        for (uint256 i = _totalBurned; i < _totalBurned + value; i++) {
            computeAddress2(i).call("");
        }
        totalBurned = _totalBurned + value;
    }

    function free(uint256 value) public returns (uint256)  {
        burn(value);
        _destroyChildren(value);
        return value;
    }

    function freeUpTo(uint256 value) public returns (uint256) {
        return free(Math.min(value, balanceOf(msg.sender)));
    }

    function freeFrom(address from, uint256 value) public returns (uint256) {
        burnFrom(from, value);
        _destroyChildren(value);
        return value;
    }

    function freeFromUpTo(address from, uint256 value) public returns (uint256) {
        return freeFrom(from, Math.min(Math.min(value, balanceOf(from)), allowance(from, msg.sender)));
    }
}
