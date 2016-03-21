
# JavaBaas
**JavaBaas** 是基于Java语言开发的后台服务框架，其核心设计目标是实现移动客户端的后台结构化数据存储、物理文件存储、消息推送等功能。极大的降低移动客户端的后台开发难度，实现快速开发。

项目地址：[GitHub](https://github.com/JavaBaas/JavaBaasServer)
技术讨论群：479167886

Note: [JavaBaas稳定版下载地址](http://7xr649.dl1.z0.glb.clouddn.com/JavaBaas.zip)

## 主要功能
* 结构化数据存储
* 物理文件存储
* ACL权限管理机制
* 用户系统
* 消息推送

##快速上手
###配置文件
`JavaBaas.jar`为程序唯一执行文件。同目录下的`application.properties`为配置文件。

###相关环境
####JDK
JavaBaas基于JDK1.8编写，编译及运行需要安装JDK1.8环境。

####MongoDB
JavaBaas使用MongoDB作为存储数据库，请先正确安装MongoDB数据库。

在`application.properties`中配置MongoDB数据库连接信息。

```
spring.data.mongodb.host = 127.0.0.1 //MongoDB数据库地址 默认为127.0.0.1
spring.data.mongodb.database = baas //用于存储数据的数据库名称 默认为baas
spring.data.mongodb.username = baas //用户名 不填写为无身份校验
spring.data.mongodb.password = baas //密码 不填写为无身份校验
spring.data.mongodb.authentication-database = admin //用于校验身份的数据库
```

####Redis
JavaBaas使用Redis作为缓存引擎，请先正确安装Redis数据库。

在`application.properties`中配置Redis数据库连接信息。

```
spring.redis.host = 127.0.0.1 //Redis数据库地址
```

###启动
系统依赖环境配置正确后，使用以下命令启动系统：

`java -jar JavaBaas.jar`
看到以下信息，表明系统启动成功。

```
[main] s.b.c.e.t.TomcatEmbeddedServletContainer : Tomcat started on port(s): 8080 (http)
[main] c.s.b.c.l.ApplicationEventListener       : JavaBaasServer started.
[main] com.staryet.baas.Main                    : Started Main in 2.653 seconds (JVM running for 3.232)
```

###JavaBaas自定义配置
####监听端口
在`application.properties`中配置监听端口，不设置默认为8080。

```
server.port = 8080
```

####服务器地址
JavaBaas需要接收外部系统回调请求，因此需要配置系统部署服务器的ip地址。（本地测试时可使用127.0.0.1代替，生产环境需配置公网ip地址。）

例如，在`application.properties`中配置当前服务器ip信息。

```
host = http://58.132.171.126/
```

####七牛云存储
为了使用七牛云存储作为物理文件存储引擎，需要配置七牛云存储相关信息。
在`src/main/resources/application.properties`中配置以下信息。

```
qiniu.ak = 七牛云存储的帐号ak
qiniu.sk = 七牛云存储的帐号sk
qiniu.bucket = bucket名称
qiniu.file.host = bucket的存储域名
```

###创建应用
`JavaBaas`系统成功启动后，默认将在http8080端口监听所有用户请求。此时首先要使用命令行工具`JBShell`创建应用。请参见[命令行工具](/manual/command_line.md)。

##常见问题解决