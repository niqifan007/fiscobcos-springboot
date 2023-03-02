# spring-boot-crud

本示例项目基于Java SDK + Maven + SpringBoot方式来调用智能合约。
本示例项目只适配3.0.x版本，如果需要别的版本的请修改pom.xml文件中的fisco-java-sdk版本号

## 前置条件

搭建FISCO BCOS 单群组区块链（Air版本），具体步骤[参考这里](https://fisco-bcos-doc.readthedocs.io/zh_CN/latest/docs/tutorial/air/build_chain.html) 。

**注意：** 节点rc4版本以后才支持Table的CRUD接口，之前的版本只能用KV接口的功能。

### 获取源码

### 配置节点证书

将节点所在目录`nodes/${ip}/sdk`下的ca.crt、sdk.crt和sdk.key文件拷贝到项目的`src/main/resources/conf`目录下供SDK使用(**FISCO BCOS 2.1以前，证书为ca.crt、node.crt和node.key**):

设节点路径为`~/fisco/nodes/127.0.0.1`，则可使用如下命令拷贝SDK证书:

```bash
# 进入项目路径
$ cd spring-boot-crud
# 创建证书存放路径
$ mkdir src/main/resources/conf
# 拷贝SDK证书
$ cp ~/fisco/nodes/127.0.0.1/sdk/* src/main/resources/conf/
```

### 设置配置文件

`spring-boot-crud`包括SDK配置文件（位于`src/main/resources/applicationContext.xml`路径）和WebServer配置文件(位于`src/main/resources/application.yml`路径)。

需要根据区块链节点的IP和端口相应配置`applicationContext.xml`的`network.peers`配置项，具体如下：

```xml
...
<property name="network">
    <map>
        <entry key="peers">
            <list>
                <value>127.0.0.1:20200</value>
                <value>127.0.0.1:20201</value>
            </list>
        </entry>
        <entry key="defaultGroup" value="group0" />
    </map>
</property>
...
```
### 同时要先生成密钥pem文件和修改配置
#### 在 'applicationContext.xml' 中修改账户地址配置
accountAddress和ccountFilePath换成自己的
```xml
...
<property name="account">
    <map>
        <entry key="keyStoreDir" value="account" />
        <entry key="accountAddress" value="0x36685008b15fdabdb9016562e21f6aa2af56d32d" />
        <entry key="accountFileFormat" value="pem" />
        <entry key="password" value="" />
        <entry key="accountFilePath" value="accounts/0x36685008b15fdabdb9016562e21f6aa2af56d32d.pem" />
    </map>
</property>
...
```

项目中关于SDK配置的详细说明请[参考这里](https://fisco-bcos-documentation.readthedocs.io/zh_CN/latest/docs/sdk/java_sdk/configuration.html)。

WebServer主要配置了监听端口，默认为`45000`，具体如下：

```yml
server:
  #端口号
  port: 45000
```

### 编译和安装项目

可以使用IDEA导入并编译并安装该项目，也可使用提供的`mvnw`脚本在命令行编译项目如下：

```shell
# 编译项目
$ bash mvnw compile

# 安装项目，安装完毕后，在target/目录下生成fisco-bcos-spring-boot-crud-0.0.1-SNAPSHOT.jar的jar包
$ bash mvnw install
```

### 启动spring-boot-crud服务

**方法一：**

打开IDEA导入并编译该项目，编译成功后，运行`AppApplication.java`即可启动spring boot服务。

**方法二：**

使用`bash mvnw install`生成的jar包`target/fisco-bcos-spring-boot-crud-0.0.1-SNAPSHOT.jar`启动spring-boot-crud服务：

```bash
# 启动spring-boot-crud(启动成功后会输出create client for group success的日志)
$ java -jar ./target/fisco-bcos-spring-boot-crud-0.0.1-SNAPSHOT.jar
```

## 访问spring boot web服务