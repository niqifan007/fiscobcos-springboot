package com.fisco.app.controller;

import com.fisco.app.config.BcosConfig;
import com.fisco.app.entity.Order;
import com.fisco.app.entity.ResponseData;
import com.fisco.app.entity.User;
import com.fisco.app.service.BcosSercive;
import org.fisco.bcos.sdk.v3.model.TransactionReceipt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin(origins = "*")
public class OrderTradingController {

    @Autowired
    private BcosSercive bcosSercive;

    @Autowired
    private BcosConfig bcosConfig;


    @PostMapping("/register")
    public ResponseData register(@RequestBody User user) {
        TransactionReceipt receipt = bcosSercive.register(user);
        return ResponseData.success("注册成功",receipt);
    }

    @PostMapping("/createOrder")
    public ResponseData createOrder(@RequestBody Order order){
        TransactionReceipt receipt = bcosSercive.createOrder(order.getOrderId(), order.getOrderStatus(), order.getOwner());
        return ResponseData.success("创建订单成功",receipt);
    }

    @GetMapping("/getOrder")
    public ResponseData getOrder(@RequestParam Long orderId,@RequestParam String owner){
        Order order = bcosSercive.getOrder(orderId,owner);
        return  ResponseData.success(order);
    }

    @GetMapping("/sign")
    public ResponseData sign(){
        TransactionReceipt receipt = bcosSercive.sign();
        return ResponseData.success(receipt);
    }
}
