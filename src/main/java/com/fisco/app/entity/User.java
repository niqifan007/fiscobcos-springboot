package com.fisco.app.entity;

import lombok.Data;

@Data
public class User {
    private String name;
    private String password;
    private String email;
    private String phone;

    private String msgSender;
}
