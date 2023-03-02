// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.7;

//用户结构体
struct User {
    uint256 user_id;
    string username;
    string password;
    string email;
    string phone;
    uint256 creation_date;
    uint256 last_login_date;
    uint8 role;
    uint256[] ordersId;
}
enum usertype {
    admin,
    user
}
//角色结构体
struct UserRole {
    mapping(address => bool) isExistent; //当前用户是否存在(已经注册)
    mapping(address => User) user; //用户
    mapping(address => bool) islocked; //当前用户是否已经被锁定
    mapping(address => uint256) account; //每个人的独立账户 记录有多少金额
    address[] isSigned; //是否已经单方签名
    uint256[] orders;//订单号列表
    uint256 NoPerson;
}

contract Role {
    //角色是否存在
    function isRole(UserRole storage m_role, address m_person)
        internal
        view
        returns (bool)
    {
        if (m_person == address(0)) {
            return false;
        }
        return m_role.isExistent[m_person];
    }

    //添加角色 用户前端发起注册后，后端触发合约执行，系统完成角色信息填充
    function addRole(
        UserRole storage m_role,
        address m_person,
        string memory _username,
        string memory _password,
        string memory _email,
        string memory _phone
    ) internal returns (bool) {
        if (isRole(m_role, m_person)) {
            return false;
        }
        m_role.isExistent[m_person] = true;
        m_role.user[m_person].username = _username;
        m_role.user[m_person].password = _password;
        m_role.user[m_person].email = _email;
        m_role.user[m_person].phone = _phone;
        m_role.user[m_person].creation_date = block.timestamp;
        m_role.user[m_person].role = uint8(usertype.user);
        m_role.islocked[m_person] = false;
        m_role.account[m_person] = 0;
        m_role.NoPerson += 1;
        return true;
    }

    //删除角色 用户前端发起注销账户后，后端触发合约执行，系统完成角色信息清除
    function removeRole(UserRole storage m_role, address m_person)
        internal
        returns (bool)
    {
        if (!isRole(m_role, m_person)) {
            return false;
        }
        //清空信息
        delete m_role.isExistent[m_person];
        delete m_role.user[m_person];
        delete m_role.islocked[m_person];
        delete m_role.account[m_person];
        m_role.NoPerson -= 1;
        return true;
    }
}
