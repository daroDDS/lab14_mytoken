// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;
import "./IMyToken.sol";

abstract contract MyTokenBase is IMyToken {
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowances;

    function getBalance(address user) public view override returns (uint256) {
        return balances[user];
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return allowances[owner][spender];
    }

    function _calculateFee(uint256 amount) internal virtual pure returns (uint256);

    function transfer(address to, uint256 amount) public virtual override {
        uint256 fee = _calculateFee(amount);
        require(balances[msg.sender] >= amount + fee, "Insufficient balance");
        
        balances[msg.sender] -= (amount + fee);
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }

    function approve(address spender, uint256 amount) public override {
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override {
        uint256 fee = _calculateFee(amount);
        require(allowances[from][msg.sender] >= amount + fee, "Allowance exceeded");
        require(balances[from] >= amount + fee, "Insufficient balance");

        balances[from] -= (amount + fee);
        balances[to] += amount;
        allowances[from][msg.sender] -= (amount + fee);
        emit Transfer(from, to, amount);
    }
}