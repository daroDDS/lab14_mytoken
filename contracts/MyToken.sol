// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;
import "./MyTokenBase.sol";

contract MyToken is MyTokenBase {
    string public name;
    string public symbol;
    address public owner;
    bool public paused;

    constructor(string memory _name, string memory _symbol, uint256 initialSupply) {
        name = _name;
        symbol = _symbol;
        owner = msg.sender;
        paused = false;
        balances[msg.sender] = initialSupply;
    }

    function _calculateFee(uint256 amount) internal pure override returns (uint256) {
        return amount / 100; // 1% fee logic
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    // Owner functions to control the emergency brake
    function pause() public onlyOwner {
        paused = true;
        emit Paused(msg.sender);
    }

    function unpause() public onlyOwner {
        paused = false;
        emit Unpaused(msg.sender);
    }

    // Overriding transfers to apply the pause security check
    function transfer(address to, uint256 amount) public override whenNotPaused {
        super.transfer(to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) public override whenNotPaused {
        super.transferFrom(from, to, amount);
    }
}