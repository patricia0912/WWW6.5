// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title 以太小猪存钱罐 (EtherPiggyBank)
 * 这是一个简单的银行合约，涉及权限管理、账本记录和 ETH 处理。
 */
contract EtherPiggyBank {

    // --- 状态变量 (存储在区块链上) ---
    
    // 银行管理员地址
    address public bankManager;
    
    // 存储所有成员地址的数组 (建议加上 private 或 public 可见性)
    address[] private members;
    
    // 映射：记录地址是否已注册。 mapping(键类型 => 值类型)
    mapping(address => bool) public registeredMembers;
    
    // 映射：记录每个成员的余额 
    mapping(address => uint256) public balances;

    // --- 构造函数 (部署合约时仅运行一次) ---
    constructor() {
        bankManager = msg.sender; // msg.sender 是当前调用者的地址。谁部署合约，谁就是管理员
        members.push(msg.sender); // 初始化：将管理员也标记为已注册成员
    }

    modifier onlyBankManager(){
        require(msg.sender == bankManager, "Only bank manager can perform this action");
        _;
    }

    modifier onlyRegisteredMember() {
        require(registeredMembers[msg.sender], "Member not registered");
        _;
    }

    // 添加新成员
    function addMembers(address _member)public onlyBankManager{
        require(_member != address(0), "Invalid address");
        require(_member != msg.sender, "Bank Manager is already a member");
        require(!registeredMembers[_member], "Member already registered");
        registeredMembers[_member] = true;
        members.push(_member);
    }

    // 看成员列表
    function getMembers() public view returns(address[] memory){
        return members;
    }

    // 存款（模拟储蓄）
    function depositEther(uint256 _amount)public payable onlyRegisteredMember{
        require(_amount>0,"Invalid amount");
        balance[msg.sender]+=msg.value;
    }
    //如果想真正存入储蓄的写法：
    // function depositAmountEther() public payable onlyRegisteredMember {
    // require(msg.value > 0, "Invalid amount");
    // balance[msg.sender] += msg.value;
    // }  

    //取钱（模拟）    
    function withdraw(uint256 _amount) public onlyRegisteredMember{
        require(_amount>0,"Invalid amount");
        require(balance[msg.sender]>=_amount,"Insufficient funds");
        balance[msg.sender]-=_amount;
    }

    function getBalance(address _member)public view returns(uint256){
        require(_member!=address(0),"Invalid address");
        return balance[msg.sender];
    }
}