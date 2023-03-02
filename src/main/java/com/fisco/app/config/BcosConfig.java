package com.fisco.app.config;

import com.fisco.app.contract.OrderTrading;
import org.fisco.bcos.sdk.v3.BcosSDK;
import org.fisco.bcos.sdk.v3.client.Client;
import org.fisco.bcos.sdk.v3.crypto.CryptoSuite;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.math.BigInteger;

@Configuration
public class BcosConfig {

    private static String ORDER_TRADING_ADDRESS = "0x4721d1a77e0e76851d460073e64ea06d9c104194";
    private BcosSDK bcosSDK;
    public OrderTrading orderTrading;

    public BcosConfig(){
        ApplicationContext context = new ClassPathXmlApplicationContext("classpath:applicationContext.xml");
        bcosSDK = context.getBean(BcosSDK.class);
        // 为群组1初始化client
        Client client = bcosSDK.getClient();
        CryptoSuite cryptoSuite = client.getCryptoSuite();
        System.out.println("-----load account------"+cryptoSuite.getCryptoKeyPair().getAddress());
        System.out.println("-----load contract-formCurd------"+ORDER_TRADING_ADDRESS);
        orderTrading = OrderTrading.load(ORDER_TRADING_ADDRESS,client,cryptoSuite.getCryptoKeyPair());
    }
    public String getCurrentAccount(){
        return bcosSDK.getClient().getCryptoSuite().getCryptoKeyPair().getAddress();

    }

    public String getBlockNumber(){
        return bcosSDK.getClient().getBlockNumber().toString();
    }

    public String getBlockHashByNumber(BigInteger blockNumber){
        return bcosSDK.getClient().getBlockHashByNumber(blockNumber).toString();
    }




}
