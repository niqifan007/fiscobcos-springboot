package com.fisco.app.service;

import com.fisco.app.entity.Order;
import com.fisco.app.entity.User;
import org.fisco.bcos.sdk.v3.model.TransactionReceipt;


public interface BcosSercive {

    TransactionReceipt register(User user);

    TransactionReceipt createOrder(Long _orderId, Long _orderStatus, String _owner);

    Order getOrder(Long _orderId,String _owner);

    TransactionReceipt sign();


}
