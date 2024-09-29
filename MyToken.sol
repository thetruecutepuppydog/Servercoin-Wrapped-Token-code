// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyToken {
    string public name = "MyToken";
    string public symbol = "MTK";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    address public owner;
    bytes32 private passwordHash;

    mapping(address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Mint(address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);

    constructor(bytes32 _passwordHash) {
        owner = msg.sender;
        totalSupply = 1050000 * (10 ** uint256(decimals));
        balanceOf[msg.sender] = totalSupply;
        passwordHash = _passwordHash;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // Add this mapping if it's not already in your contract
    mapping(address => mapping(address => uint256)) private _allowances;
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function mint(address _to, uint256 _value, string memory _password) public onlyOwner returns (bool success) {
        require(keccak256(abi.encodePacked(_password)) == passwordHash, "Invalid password");
        totalSupply += _value;
        balanceOf[_to] += _value;
        emit Mint(_to, _value);
        return true;
    }
    function changePassword(string memory _newPassword) public onlyOwner returns (bool success) {
      

       bytes32 newPasswordHash = keccak256(abi.encodePacked(_newPassword));
       if (newPasswordHash != passwordHash) {
           passwordHash = newPasswordHash;
           return true; // Password changed successfully
       } else {
           return false; // New password is the same as the old password
       }
    }


    function burn(address _Truesender,uint256 _value, string memory _password) public returns (bool success) {
        require(keccak256(abi.encodePacked(_password)) == passwordHash, "Invalid password");
        require(balanceOf[_Truesender] >= _value, "Insufficient balance to burn");

        balanceOf[_Truesender] -= _value;
        totalSupply -= _value;
        emit Burn(_Truesender, _value);
        return true;
    }
    function approve(address _spender, uint256 _value) public returns (bool success) {
        _allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // Allowance function
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return _allowances[_owner][_spender];
    }

    // TransferFrom function
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
     require(balanceOf[_from] >= _value, "Insufficient balance");
     require(_allowances[_from][msg.sender] >= _value, "Allowance exceeded");
    
     balanceOf[_from] -= _value;
     balanceOf[_to] += _value;
     _allowances[_from][msg.sender] -= _value;
     emit Transfer(_from, _to, _value);
     return true;
    }  
}