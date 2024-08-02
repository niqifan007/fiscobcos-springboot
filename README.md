# FISCO BCOS 基于 Spring Boot 的 CRUD 示例项目

本示例项目基于 Java SDK + Maven + Spring Boot 来调用智能合约。该项目仅适配 FISCO BCOS 3.0.x 版本，如果需要适配其他版本，请修改 `pom.xml` 文件中的 `fisco-java-sdk` 版本号。

## 前置条件

搭建 FISCO BCOS 单群组区块链（Air 版本），具体步骤请[参考这里](https://fisco-bcos-doc.readthedocs.io/zh_CN/latest/docs/tutorial/air/build_chain.html)。

**注意：** 节点 rc4 版本以后才支持 Table 的 CRUD 接口，之前的版本只能用 KV 接口的功能。

### 获取源码

克隆仓库：

```bash
$ git clone https://github.com/your-repo/spring-boot-crud.git
$ cd spring-boot-crud
```

### 配置节点证书

将节点目录 `nodes/${ip}/sdk` 下的 `ca.crt`、`sdk.crt` 和 `sdk.key` 文件拷贝到项目的 `src/main/resources/conf` 目录下供 SDK 使用（FISCO BCOS 2.1 以前，证书为 `ca.crt`、`node.crt` 和 `node.key`）。

假设节点路径为 `~/fisco/nodes/127.0.0.1`，可使用以下命令拷贝 SDK 证书：

```bash
# 创建证书存放路径
$ mkdir -p src/main/resources/conf

# 拷贝 SDK 证书
$ cp ~/fisco/nodes/127.0.0.1/sdk/* src/main/resources/conf/
```

### 设置配置文件

项目包含 SDK 配置文件（位于 `src/main/resources/applicationContext.xml` 路径）和 WebServer 配置文件（位于 `src/main/resources/application.yml` 路径）。

#### SDK 配置

根据区块链节点的 IP 和端口相应配置 `applicationContext.xml` 的 `network.peers` 配置项：

```xml
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
```

在 `applicationContext.xml` 中更新账户地址和密钥路径：

```xml
<property name="account">
    <map>
        <entry key="keyStoreDir" value="account" />
        <entry key="accountAddress" value="0x36685008b15fdabdb9016562e21f6aa2af56d32d" />
        <entry key="accountFileFormat" value="pem" />
        <entry key="password" value="" />
        <entry key="accountFilePath" value="accounts/0x36685008b15fdabdb9016562e21f6aa2af56d32d.pem" />
    </map>
</property>
```

关于 SDK 配置的详细说明请[参考这里](https://fisco-bcos-documentation.readthedocs.io/zh_CN/latest/docs/sdk/java_sdk/configuration.html)。

#### WebServer 配置

在 `application.yml` 中更新 WebServer 的监听端口（默认为 `45000`）：

```yml
server:
  port: 45000
```

### 编译和安装项目

可以使用 IntelliJ IDEA 导入并编译和安装该项目，也可使用提供的 `mvnw` 脚本在命令行编译项目：

```bash
# 编译项目
$ bash mvnw compile

# 安装项目，安装完毕后，在 target/ 目录下生成 fisco-bcos-spring-boot-crud-0.0.1-SNAPSHOT.jar 的 JAR 包
$ bash mvnw install
```

### 启动 Spring Boot CRUD 服务

**方法一：使用 IntelliJ IDEA**

导入项目至 IntelliJ IDEA，编译并运行 `AppApplication.java` 启动 Spring Boot 服务。

**方法二：使用命令行**

使用生成的 JAR 包启动服务：

```bash
# 启动 Spring Boot CRUD 服务
$ java -jar ./target/fisco-bcos-spring-boot-crud-0.0.1-SNAPSHOT.jar
```

## 访问 Spring Boot Web 服务

服务启动后，可以通过配置的端口（默认是 `45000`）进行访问。

---

此 README 提供了设置和运行基于 Spring Boot 的 CRUD 项目的简要指南。
