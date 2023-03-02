// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.7;
import "./OrderEvidence.sol";

contract OrderTrading {
    OrderEvidence orderEvid;
    address admin;

    constructor() {
        admin = msg.sender;
        orderEvid = new OrderEvidence(admin);
    }

    // 签名 => 用户调用
    function sign() public returns (bool) {
        orderEvid.sign(msg.sender);
        return true;
    }

    // 创建订单存单
    function createOrder(
        uint256 _orderId,
        uint256 _orderStatus,
        address _owner
    ) public returns (bool) {
        return orderEvid.createOrder(_orderId, _orderStatus, _owner);
    }

    // 拉黑
    function putIntoBlackList(address m_person) public {
        orderEvid.putIntoBlackList(m_person);
    }

    // 查询哈希值
    function getHsah(address _owner, uint256 _orderId)
        public
        view
        returns (bytes32)
    {
        bytes32 hash = orderEvid.getHsah(_owner, _orderId);
        require(hash != bytes32(0), "invalid hash!");
        return hash;
    }

    // 注册用户
    function registerNewUser(
        string memory _username,
        string memory _password,
        string memory _email,
        string memory _phone
    ) public returns (bool) {
        return
            orderEvid.registerUser(
                _username,
                _password,
                _email,
                _phone,
                msg.sender
            );
    }

    //查询用户
    function queryUser(address m_person)
        public
        view
        returns (
            string memory,
            string memory,
            string memory,
            string memory
        )
    {
        return orderEvid.queryUser(m_person);
    }

    //查询已注册总人数
    function queryNoUser() public view returns (uint256) {
        return orderEvid.queryNoUser();
    }

    //注销用户
    function cancelUser(address m_person) public returns (bool) {
        orderEvid.cancelUser(m_person);
        return true;
    }

    // 查询订单详细
    function getOrder(address _owner, uint256 _orderId)
        public
        view
        returns (Orders memory order)
    {
        return orderEvid.getOrder(_owner, _orderId);
    }

    // 返回特定用户所持有的订单
    function getOrderIdList(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        return orderEvid.getOrderIdList(_owner);
    }

    // 订单转移/交易
    function Trading(
        address _oldOwner,
        address _newOwner,
        uint256 _orderId
    ) public returns (bool) {
        orderEvid.trading(_oldOwner, _newOwner, _orderId);
        return true;
    }

    // // 删除数组
    // function deltwo(address _owner, uint256 _orderId) public returns (uint) {
    //     return orderEvid.deltwo(_owner, _orderId);
    // }


}
