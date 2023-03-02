package com.fisco.app.entity;

import lombok.Data;


@Data
public class Order {
    private Long orderId;
    private Long orderStatus;
    private String owner;
    private String tradingHash;
    private Long tradingDate;
}
