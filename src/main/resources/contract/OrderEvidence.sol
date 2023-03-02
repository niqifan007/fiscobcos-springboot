// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.7;
import "./Role.sol";

struct Orders {
    bytes32 tradingHash; //交易哈希值
    uint256 tradingDate; //交易时间
    uint256 order_id; //订单单号
    uint256 order_status; //订单状态
    address owner; //订单所有者
}

contract OrderEvidence is Role {
    uint256 sumCount; //订单总数
    address[] blackList; //黑名单
    address admin; //管理员地址
    UserRole userRole;
    Orders[] orders;
    mapping(address => mapping(uint256 => Orders)) orderList; //已经存证的订单列表
    uint256[] idList; // 方便索引订单号列表

    event AddSignaturesEvidence(address _sender);

    constructor(address m_admin) {
        admin = m_admin;
    }

    //判断是不是在黑名单里面
    function judgeIsInBlackList(address m_user) public view returns (bool) {
        for (uint256 i = 0; i < blackList.length; i++) {
            if (blackList[i] == m_user) {
                return true;
            }
        }
        return false;
    }

    //单方签名
    function sign(address m_signer) external returns (bool) {
        require(isRole(userRole, m_signer), "the Signer is not existent!");
        //require(m_signer != admin, "the Signer is not valid!");
        require(!judgeIsSigned(m_signer), "the user has already signed!");

        userRole.isSigned.push(m_signer); //将公钥地址放入已签名列表
        emit AddSignaturesEvidence(m_signer);

        return true;
    }

    //判重
    function verify(address m_signer) internal view returns (bool) {
        for (uint256 i = 0; i < userRole.isSigned.length; i++) {
            if (userRole.isSigned[i] == m_signer) {
                return true;
            }
        }
        return false;
    }

    //判断订单号是否存在
    function verifyId(uint256 _orderId) internal view returns (bool) {
        for (uint256 i = 0; i < userRole.orders.length; i++) {
            if (userRole.orders[i] == _orderId) {
                return true;
            }
        }
        return false;
    }

    //判断是否已经签名
    function judgeIsSigned(address _useraddress) public view returns (bool) {
        for (uint256 i = 0; i < userRole.isSigned.length; i++) {
            if (userRole.isSigned[i] == _useraddress) {
                return true;
            }
        }

        return false;
    }

    //创建订单
    function createOrder(
        uint256 _orderId,
        uint256 _orderStatus,
        address owner
    ) public returns (bool) {
        require(!verifyId(_orderId), "Order number already exists!");
        if (judgeIsSigned(owner) && !userRole.islocked[owner]) {
            bytes32 _hash = keccak256(abi.encodePacked(owner, _orderId));
            Orders memory order = Orders(
                _hash,
                block.timestamp,
                _orderId,
                _orderStatus,
                owner
            );
            orderList[owner][_orderId] = order;
            userRole.orders.push(_orderId);
            userRole.user[owner].ordersId.push(_orderId);
            return true;
        } else {
            return false;
        }
    }

    //获取订单哈希
    function getHsah(address _owner, uint256 _orderId)
        external
        view
        returns (bytes32 h)
    {
        return orderList[_owner][_orderId].tradingHash;
    }

    //返回订单结构体
    function getOrder(address _owner, uint256 _orderId)
        public
        view
        returns (Orders memory order)
    {
        return orderList[_owner][_orderId];
    }

    // 返回某个用户的订单号列表
    function getOrderIdList(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        return userRole.user[_owner].ordersId;
    }

    //查找订单号并从订单号列表删除
    function deleteOrderId(address _owner, uint256 _orderId)
        public
        returns (bool)
    {
        uint256 _index = 999;
        for (uint256 i = 0; i < userRole.user[_owner].ordersId.length; i++) {
            if (userRole.user[_owner].ordersId[i] == _orderId) {
                _index = i;
            }
            if (_index == 999) {
                return false;
            }
        }
        for (
            uint256 i = _index;
            i < userRole.user[_owner].ordersId.length;
            i++
        ) {
            userRole.user[_owner].ordersId[i] = userRole.user[_owner].ordersId[
                i + 1
            ];
        }
        userRole.user[_owner].ordersId.pop();
        return true;
    }

    function deltwo(address _owner, uint256 _orderId) public returns (bool) {
        uint256 index;
        for (uint256 i = 0; i < userRole.user[_owner].ordersId.length; i++) {
            if (userRole.user[_owner].ordersId[i] == _orderId) {
                index = i;
            }
        }
        // if(userRole.user[_owner].ordersId.length == 1){
        //     userRole.user[_owner].ordersId.pop();
        //     return true;
        // }
        userRole.user[_owner].ordersId[index] = userRole.user[_owner].ordersId[
            userRole.user[_owner].ordersId.length - 1
        ];

        userRole.user[_owner].ordersId.pop();
        return true;
    }

    //交易订单(转移所有者)
    function trading(
        address _oldOwner,
        address _newOwner,
        uint256 _orderId
    ) public returns (bool) {
        orderList[_newOwner][_orderId] = orderList[_oldOwner][_orderId];
        delete orderList[_oldOwner][_orderId];
        orderList[_newOwner][_orderId].tradingDate = block.timestamp;
        if (!deltwo(_oldOwner, _orderId)) {
            revert("del error");
        }
        userRole.user[_newOwner].ordersId.push(_orderId);
        return true;
    }

    //拉黑
    function putIntoBlackList(address m_person) public {
        blackList.push(m_person);
    }

    //注册用户
    function registerUser(
        string memory _username,
        string memory _password,
        string memory _email,
        string memory _phone,
        address m_person
    ) public returns (bool) {
        return
            addRole(userRole, m_person, _username, _password, _email, _phone);
    }

    //注销用户
    function cancelUser(address m_person) public {
        removeRole(userRole, m_person);
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
        return (
            userRole.user[m_person].username,
            userRole.user[m_person].password,
            userRole.user[m_person].email,
            userRole.user[m_person].phone
        );
    }

    //查询已注册总人数
    function queryNoUser() public view returns (uint256) {
        return userRole.NoPerson;
    }
}
