package com.fisco.app.service.Impl;

import com.fisco.app.config.BcosConfig;
import com.fisco.app.contract.OrderTrading;
import com.fisco.app.entity.Order;
import com.fisco.app.entity.User;
import com.fisco.app.service.BcosSercive;
import org.fisco.bcos.sdk.v3.model.TransactionReceipt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigInteger;
import java.util.Arrays;

@Service
public class BcosSerciveImpl implements BcosSercive {

    @Autowired
    BcosConfig bcosConfig;

    @Override
    public TransactionReceipt register(User user) {
        return bcosConfig.orderTrading.registerNewUser(user.getName(),user.getPassword(),user.getEmail(),user.getPhone());
    }

    @Override
    public TransactionReceipt createOrder(Long _orderId, Long _orderStatus, String _owner) {
        return bcosConfig.orderTrading.createOrder(BigInteger.valueOf(_orderId),BigInteger.valueOf(_orderStatus),_owner);
    }

    @Override
    public Order getOrder(Long _orderId, String _owner) {
        try{
            OrderTrading.Orders res = bcosConfig.orderTrading.getOrder(_owner,BigInteger.valueOf(_orderId));
            return OrdersToOrder(res);
        }catch (org.fisco.bcos.sdk.v3.transaction.model.exception.ContractException e){
            System.out.println("aaaaa");
            return null;
        }
    }

    @Override
    public TransactionReceipt sign() {
        return bcosConfig.orderTrading.sign();
    }

    private Order OrdersToOrder(OrderTrading.Orders orders){
        Order order = new Order();
        order.setOrderId(orders.order_id.longValue());
        order.setOwner(orders.owner);
        order.setTradingHash(Arrays.toString(orders.tradingHash));
        order.setOrderStatus(orders.order_status.longValue());
        order.setTradingDate(orders.tradingDate.longValue());
        return order;
    }


}
