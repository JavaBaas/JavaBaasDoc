#REST API
REST API 可以让你用任何支持发送 HTTP 请求的设备来与 JavaBaas 进行交互，你可以使用 REST API 做很多事情，比如：

* 一个移动网站可以通过 JavaScript 来获取 JavaBaas 上的数据.
* 一个网站可以展示来自 JavaBaas 的数据。
* 你可以上传大量的数据，之后可以被一个移动 App 读取。
* 你可以下载最近的数据来进行你自定义的分析统计。
* 使用任何语言写的程序都可以操作 JavaBaas 上的数据。

##安全机制
###三级权限
所有的API请求都是在安全的鉴权机制下进行的，接口分为三级权限。分别为`admin`（超级）权限、`master`（管理）权限、`user`（普通）权限。每个接口都有其调用所需要的对应权限。无权限或使用错误的权限将调用失败。

####超级权限（admin）
`admin`权限为系统的超级权限，系统的核心管理接口需要使用此权限进行调用，如创建删除应用等。在`src/main/resources/application.properties`需要配置auth.admin.key，系统才能正常工作。如：

```
auth.admin.key = V1hwT1UyRkhUblZpUjNoclVWTlZlbEpEVlhwU1FTVXpSQ1V6UkElM0QlM0Qc3Rhc
```
其中key由用户自由生成。

####管理权限（master）
`master`权限为管理权限。对应用中`类`的管理、`字段`的管理、部署`云代码`等，均需要使用此权限进行调用。因此使用此权限需要指定被操作appId。同时此权限也可以进行无视ACL权限（表级和对象级）的`对象`增删改查操作。

####普通权限（user）
`user`权限为普通权限。可以进行`对象`的增删改查操作。适合在客户端调用时使用。

###接口调用鉴权方式
在所有的API请求头部（header）中，为了检查请求者的有效身份，需要添加以下信息：

名称|描述
------------ | ------------
Content-Type | 必须为 application/json
JB-Plat | 调用接口的平台 取值为js或android或ios
JB-Timestamp | 客户端产生本次请求的 unix 时间戳，精确到毫秒。
JB-AppId | 调用应用的AppId，用以表示正在操作哪一个应用。（当使用管理授权或普通授权时需要）
JB-AdminSign（三选一）|将adminKey加上":"再加上timestamp组成的字符串，再对它做 MD5 签名后的结果。
JB-MasterSign（三选一） | 将masterKey加上":"再加上timestamp组成的字符串，再对它做 MD5 签名后的结果。
JB-Sign（三选一） | 将key加上":"再加上timestamp组成的字符串，再对它做 MD5 签名后的结果。

其中`JB-AdminSign` `JB-MasterSign` `JB-Sign`为三选一。使用`JB-AdminSign`时为超级授权、使用`JB-MasterSign`时为管理授权、使用`JB-Sign`时为普通授权。使用管理授权或普通授权时为了指定被操作的App，因此必须有`JB-AppId`。

加密计算实现（Java）：

```java
public String encrypt(String key, String timeStamp) {
        return md5(key + ":" + timeStamp);
    }
```

其中`key`在不同的授权下、分别可以是`key` `masterKey` `adminKey`，`JB-timeStamp`为当前系统时间戳。返回结果为请求header中所需的`JB-Sign`或`JB-MasterSign`或`JB-AdminSign`。使用管理授权或普通授权时必须有`JB-AppId`

##响应格式
对于所有的请求的响应格式都是一个 JSON 对象.

一个请求是否成功是由 HTTP 状态码标明的。一个 200 的状态码表示成功，而一个 400 表示请求失败。当一个请求失败时响应的主体仍然是一个 JSON 对象，但是总是会包含`code`和`error`这两个字段，你可以用它们来进行调试。

##接口概览
每个接口都有其调用所需要的对应权限。无权限或使用错误的权限将调用失败。

###应用（超级权限）
URL|METHOD|描述
------------ | ------------ | ------------
/admin/app|POST|创建应用
/admin/app/{appId}|GET|获取应用
/admin/app |GET|列表
/admin/app/{appId}|DELETE|删除应用

###类（管理权限）
URL|METHOD|描述
------------ | ------------ | ------------
/master/clazz|POST|创建类
/master/clazz/{className}|GET|获取类
/master/clazz|GET|列表
/master/clazz/{className}|DELETE|删除类

###字段（管理权限）
URL|METHOD|描述
------------ | ------------ | ------------
/master/clazz/{className}/field|POST|创建字段
/master/clazz/{className}/field/{fieldName}|GET|获取字段
/master/clazz/{className}/field/{fieldName}|PUT|更新字段
/master/clazz/{className}/field|GET|字段列表
/master/clazz/{className}/field/{fieldName}|DELETE|删除字段

###对象（管理权限 普通权限）
URL|METHOD|描述
------------ | ------------ | ------------
/object/{className}|POST|创建对象
/object/{className}/{id}|GET|获取对象
/object/{className}/{id}|PUT|更新对象
/object/{className}|GET|查询对象
/object/{className}/{id}|DELETE|删除对象

###用户（管理权限 普通权限）
URL|METHOD|描述
------------ | ------------ | ------------
/user|POST|注册用户
/user/{id}|PUT|修改用户信息
/user/login|GET|用户登录

###设备（管理权限 普通权限）
URL|METHOD|描述
------------ | ------------ | ------------
/installation|POST|注册设备

##用户
用户系统是所有应用中最常见的子系统，为了避免重复建设，提高开发效率，`JavaBaas`内建了简单的用户系统。

用户类`User`的基本功能与其他的类是相同的。用户对象和其他对象不同的是，每个用户必须有用户名`username`和密码`password`，密码会被自动地加密和存储。JavaBaas强制要求`username`和`email`这两个字段必须是没有重复的。

###注册
注册一个新用户与创建一个新的普通对象之间的不同点在于`username`和`password`字段都是必需的。`password`字段会以和其他的字段不一样的方式处理，它在储存时会被加密而且永远不会被返回给任何来自客户端的请求。

为了注册一个新的用户，需要向`user`路径发送一个POST请求，且可以在创建时同时提交一个自定义字段。例如，创建一个有昵称的新用户（其中昵称为自定义字段）:

```
curl -X POST \
  -H "JB-Timestamp:(timestamp)" \
  -H "JB-AppId:(appId)" \
  -H "JB-Sign:(sign)" \
  -H "Content-Type: application/json" \
  -d '{"username":"codi","password":"123456","nickname":"Codi"}' \
	(host)/users
```

当创建成功时，会返回新创建的用户信息。
包含`_id` `createdAt` `sessionToken`等信息：

```
{
  "code": 0,
  "data": {
    "_id": "1c4978776f924fd48bd86905e21dd828",
    "createdAt": 1444962473797,
    "sessionToken": "2040f95a9a634e02aa9ae1e8bf6a0ea0"
  },
  "message": ""
}
```

###登录
用户注册成功后，可以使用用户名密码进行登录，登录成功后，会获得所有的用户信息。

```
curl -X GET \
  -H "JB-Timestamp:(timestamp)" \
  -H "JB-AppId:(appId)" \
  -H "JB-Sign:(sign)" \
  -H "Content-Type: application/json" \
  -G \
  --data-urlencode 'username=codi' \
  --data-urlencode 'password=123456' \
	(host)/user/login
```
其中：

* username:用户名
* password:密码

返回用户信息。

```
{
  "_id": "1c4978776f924fd48bd86905e21dd828",
  "createdAt": 1444962051055,
  "updatedAt": 1444962051055,
  "acl": {
    "*": {
      "read": true,
      "write": true
    }
  },
  "sessionToken": "2040f95a9a634e02aa9ae1e8bf6a0ea0",
  "username": "codi",
  "nickname": "Codi"
}
```

###SessionToken
在`JavaBaas`中，所有的请求通过添加请求头`JB-SessionToken`来表示当前请求的用户身份。因此，在注册或登录成功后，客户端需缓存用户的`SessionToken`作为之后请求的身份标识。同时，当用户密码信息变化时，之前获取的`SessionToken`将失效，需重新登录进行获取。

###修改密码
修改密码需要让用户输入一次旧密码做验证，旧密码正确才可以修改为新密码。同时，登录用户才可以修改自己的密码，因此调用修改密码接口需要在请求头中加入`JB-SessionToken`来表示当前请求的用户身份。

```
curl -X PUT \
  -H "JB-Timestamp:(timestamp)" \
  -H "JB-AppId:(appId)" \
  -H "JB-Sign:(sign)" \
  -H "JB-SessionToken:(sign)" \
  -H "Content-Type: application/json" \
  -d '{"oldPassword":"123456","newPassword":"654321"}' \
	(host)/{id}/updatePassword
```
其中：

* id:用户id
* old_password:用户的老密码
* new_password:用户的新密码

###绑定第三方平台
`JavaBaas`支持将系统用户与第三方平台用户进行绑定。如新浪微博、微信、qq等，这样就允许你的用户直接用第三方平台用户身份进行登录。关联完成后，authData将被存储到用户信息中，并通过登录即可重新获取。

首先使用第三方平台进行用户授权（或使用ShareSdk等工具），完成授权后第三方平台讲返回accessToken以及用户id等信息。客户端向`JavaBaas`提交此信息后，后台会进行授权检查，检查通过后完成绑定。

```
curl -X POST \
  -H "JB-Timestamp:(timestamp)" \
  -H "JB-AppId:(appId)" \
  -H "JB-Sign:(sign)" \
  -H "JB-SessionToken:(sessionToken)" \
  -H "Content-Type: application/json" \
  -d '{"accessToken":"69B307BA98F8C8D2455CC8D9040A6A96","uid":"AB782D5190C50B588B536145FEEF6A0F"}' \
	(host)/{id}/binding/{platform}
```

其中：

* id:用户id
* platform:第三方平台的名称，微博:weibo、qq:qq、微信:weixin。
* accessToken:使用第三方平台授权时获取的token
* uid:使用第三方平台授权时获取的用户身份表示，其中微博取uid字段，qq、微信取openId字段

###解绑第三方平台
使用此接口将用户与第三方平台解除绑定。

```
curl -X DELETE \
  -H "JB-Timestamp:(timestamp)" \
  -H "JB-AppId:(appId)" \
  -H "JB-Sign:(sign)" \
  -H "JB-SessionToken:(sessionToken)" \
  -H "Content-Type: application/json" \
	(host)/{id}/release/{platform}
```

其中：

* id:用户id
* platform:第三方平台的名称，微博:weibo、qq:qq、微信:weixin。

###使用第三方平台登录
用户于第三方平台绑定后，可以使用第三方平台授权信息进行登录操作。登录成功后，会获得所有的用户信息。

```
curl -X POST \
  -H "JB-Timestamp:(timestamp)" \
  -H "JB-AppId:(appId)" \
  -H "JB-Sign:(sign)" \
  -H "Content-Type: application/json" \
  -d '{"accessToken":"69B307BA98F8C8D2455CC8D9040A6A96","uid":"AB782D5190C50B588B536145FEEF6A0F"}'
	(host)/user/loginWithSns/{platform}
```

其中：

* platform:第三方平台的名称，微博:weibo、qq:qq、微信:weixin。
* accessToken:使用第三方平台授权时获取的token
* uid:使用第三方平台授权时获取的用户身份表示，其中微博取uid字段，qq、微信取openId字段

返回用户信息。

```
{
  "_id": "1c4978776f924fd48bd86905e21dd828",
  "createdAt": 1444962051055,
  "updatedAt": 1444962051055,
  "acl": {
    "*": {
      "read": true,
      "write": true
    }
  },
  "sessionToken": "2040f95a9a634e02aa9ae1e8bf6a0ea0",
  "username": "codi",
  "nickname": "Codi"
}
```
