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

> 注意，本文档中给的所有例子均为编者在本地搭建的环境中实测的数据，其中

```
Server-IP: http://127.0.0.1:8080/
JB-AppId:  56cd5194c6db7c372fd1563f
key:  8fdd2c7fad56430688f192ca835b524b
masterKey:  53a0b6967e2f4ac399341c4ac93f2db3
```

##响应格式
对于所有的请求的响应格式都是一个 JSON 对象.

一个请求是否成功是由 HTTP 状态码标明的。一个 200 的状态码表示成功，而一个 400 表示请求失败。当一个请求失败时响应的主体仍然是一个 JSON 对象，但是总是会包含`code`和`error`这两个字段，你可以用它们来进行调试。

##接口概览
每个接口都有其调用所需要的对应权限。无权限或使用错误的权限将调用失败。

###对象（管理权限 普通权限）
URL|METHOD|描述
------------ | ------------ | ------------
/object/{className}|POST|[创建对象](#CreateObject)
/object/{className}/{id}|GET|[获取对象](#GetObject)
/object/{className}/{id}|PUT|[更新对象](#UpdateObject)
/object/{className}/{id}/inc|PUT|[对象原子操作](#TomicOperations)
/object/{className}|GET|[查询对象](#QueryObjects)
/object/{className}/count|GET|[查询对象个数](#QueryObjectsCount)
/object/{className}/{id}|DELETE|[删除对象](#DeleteObject)
/object/{className}/deleteByQuery|DELETE|[批量删除对象](#DeleteObjectsByQuery)

###应用（超级权限）
URL|METHOD|描述
------------ | ------------ | ------------
/admin/app|POST|[创建应用](#CreateApp)
/admin/app |GET|[应用列表](#GetAppList)
/admin/app/{appId}|GET|[获取应用](#GetApp)
/admin/app/{appId}|DELETE|[删除应用](#DeleteApp)
/admin/app/{appId}/resetKey|PUT|[重置应用key](#ResetAppKey)
/admin/app/{appId}/resetMasterKey|PUT|[重置应用masterKey](#ResetAppMasterKey)
/admin/app/{appId}/export|GET|[导出应用数据](#ExportAppData)
/admin/app/{appId}/import|POST|[导入应用数据](#ImportAppData)

###类（管理权限）
URL|METHOD|描述
------------ | ------------ | ------------
/master/clazz|POST|[创建类](#CreateClass)
/master/clazz|GET|[类列表](#GetClassList)
/master/clazz/{className}|GET|[获取类](#GetClass)
/master/clazz/{className}|DELETE|[删除类](#DeleteClass)
/master/clazz/{className}/export|GET|[导出类数据](#ExportClassData)
/master/clazz/{className}/import|POST|[导入类数据](#ImportClassData)
/master/clazz/{className}/acl|POST|[设置类的acl](#SetClassACL)

###字段（管理权限）
URL|METHOD|描述
------------ | ------------ | ------------
/master/clazz/{className}/field|POST|[创建字段](#CreateFiled)
/master/clazz/{className}/field|GET|[字段列表](#GetFieldList)
/master/clazz/{className}/field/{fieldName}|GET|[获取字段](#GetFiled)
/master/clazz/{className}/field/{fieldName}|PUT|[更新字段](#UpdateField)
/master/clazz/{className}/field/{fieldName}|DELETE|[删除字段](#DeleteFiled)

###用户（管理权限 普通权限）
URL|METHOD|描述
------------ | ------------ | ------------
/user|POST|[注册用户](#RegUser)
/user/{id}/binding/{platform}|POST|[绑定社交平台](#BindPlatform)
/user/{id}/release/{platform}|DELETE|[解绑社交平台](#ReleasePlatform)
/user/{id}|PUT|[修改用户信息](#UpdateUser)
/user/{id}/updatePassword|PUT|[修改用户密码](#UpdatePassword)
/user/login|GET|[用户登录](#UserLogin)
/user/loginWithSns/{platform}|POST|[第三方登录](#UserLoginWithSNS)
/user/{id}/resetSessionToken|PUT|[重置用户SessionToken](#ResetSessionToken)

###文件（管理权限 普通权限）
URL|METHOD|描述
------------ | ------------ | ------------
/file|POST|[创建文件](#CreateFile)
/file/getToken|GET|[请求文件上传所需要的鉴权信息](#GetFileAuthentication)
/file/callback|POST|[文件上传后的回调](#FileCallback)
/file/notify/qiniu|POST|[七牛的异步操作通知](#NotifyQiniu)
/file/master/process|POST|[文件处理](#ProcessFile)

###云代码和钩子（管理权限 普通权限）
URL|METHOD|描述
------------ | ------------ | ------------
/master/cloud|POST|[部署云代码(含钩子)相关配置](#DeployCloud)
/master/cloud|DELETE|[删除云代码(含钩子)相关配置](#UnDeployCloud)
/cloud|Get|[调用云方法](#RequestCloud)

###设备（管理权限 普通权限）
URL|METHOD|描述
------------ | ------------ | ------------
/matser/push|POST|[推送消息](#PushInfo)
/matser/push/setPushAccount|PUT|[设置推送账号信息](#SetPushAccount)

###推送（管理权限）
URL|METHOD|描述
------------ | ------------ | ------------
/installation|POST|[注册设备](#RegDevice)

###API统计和日志（管理权限 超级权限）
URL|METHOD|描述
------------ | ------------ | ------------
/master/apiStat|GET|[API统计](#GetApiStatistics)
/admin/log|GET|[获取日志信息](#GetAppLog)

##对象
###对象格式
 REST API 是基于JSON对象的数据编码存储，数据是无模式化的（Schema Free），这意味着你不需要提前标注每个对象上有哪些 key，你只需要随意设置 key-value 对就可以，后端会保存它。<br />
例如，我们需要实音频现一个多媒体播放器类型的App，一个音频可能包含下面几个属性:

```
{
    "title":"音频名称",
    "length":300,
    "content":"音频的描述"
}    
```
Key（属性名）必须是字母和数字组成的字符串，Value（属性值）可以是任何可以 JSON 编码的数据。<br />
每个对象都有一个类名，你可以通过类名来区分不同的数据。例如，我们可以把音频对象称之为Sound。我们建议将类和属性名分别按照 `NameYourClassesLikeThis` 和 `nameYourKeysLikeThis` 这样的惯例来命名，即区分第一个字母的大小写，这样可以提高代码的可读性和可维护性。<br />
当你从 JavaBaas 中获取对象时，一些字段会被自动加上，如 `createdAt`(创建时间)、`updatedAt`(更新时间)、`createdPlat`(创建平台)、`updatedPlat`(更新平台)、`acl`(ACL权限) 和 `_id`(对象id，对象的唯一标识)。这些字段的名字是保留的，值也不允许修改(`acl`除外)。我们上面设置的对象在获取时应该是下面的样子：

```
{
	"_id":"6e929370b8674fd885a191052a34c259",
    "title":"音频名称",
    "length":300,
    "content":"音频的描述",
    "createdAt":1452062982269,
    "updatedAt":1458716442552,
    "createdPlat":"js",
    "updatedPlat":"cloud",
    "acl":{
        "*":{
            "read":true,
            "write":true
        }
    }
}    
```
createdAt和updatedAt都是对象操作时的时间戳，_id是一个字符串，在类中可以唯一标识一个对象。在 REST API 中，class 级的操作都是通过一个带类名的资源路径（URL）来标识的。例如，如果类名是 Sound，那么 class 的 URL 就是：

```
http://127.0.0.1:8080/api/object/Sound
```

针对于一个特定的对象的操作可以通过组织一个 URL 来做。例如，对 Sound 中的一个 _id 为 6e929370b8674fd885a191052a34c259 的对象的操作应使用如下 URL：

```
http://127.0.0.1:8080/api/object/Sound/6e929370b8674fd885a191052a34c259
```

acl的详见 [ACL](#ACL)

> 注意：createdPlat和updatedPlat是指创建或者更新该对象的请求是哪个平台发的，目前只有 `android` 、 `ios` 、 `js` 、 `cloud` 、 `shell` 和 `admin` 六种.

> `_User` 、 `Installation` 、 `_File` 等一些内建类，class级别的操作跟普通的class资源路径用法有些区别，下面会有具体说明。

>"http://127.0.0.1:8080/"为请求的BaseUrl地址，"api/"代表是访问 REST API 的请求。

###<span id="CreateObject">创建对象</span><a name="CreateObject" />
为了在 JavaBaas 上创建一个新的对象，应该向 class 的 URL 发送一个 POST 请求，其中应该包含对象本身。例如，要创建如上所说的对象:

```
curl -X POST \
  -H "JB-Timestamp:1458726351581" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:4bf9845332d1f6256341abcd269b074e" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -d '{"title":"音频名称","length":300,"content":"音频的描述"}' \
	http://127.0.0.1:8080/api/object/Sound
```

当创建成功时，返回HTTP状态码为200，响应的主体是一个JSON对象：

```
{
    "code":0,
    "data":{
        "_id":"b54aa8a1ab5945649c628b63b65c1db9"
    },
    "message":""
}
```

> 注意：一般JavaBaas处理请求成功，返回的HTTP状态码均为200（后面的例子不再单独说明），如果请求失败，或者请求处理失败返回的HTTP状态会根据错误或者失败情况放回不同值。

> 对于成功的请求，响应主体中一般含有 `code` , `data` 和 `message` 信息（后面的例子不再单独说明）

  *  `POST`、`PUT`和`DELETE`请求，请求成功后响应主体格式同本例子中的响应主体格式，`GET`请求，如果请求成功，响应主体为请求的结构化数据，例如 [获取对象](#GetObject);
  * `code` 值为 0 表示业务处理成功，1 表示业务处理失败。（目前，JavaBaas成功的请求响应中， `code` 值多数为 0 ，仅在云方法请求的响应中会出现 `code` 为 0 的情况）；
  * `data` 内容为请求响应的数据信息；
  * `message` 为响应的一些附加说明。
 
###<span id="GetObject">获取对象</span>
当你创建了一个对象时，你可以通过发送一个 GET 请求, 以获取它的内容。例如，为了得到我们上面创建的对象

```
curl -X GET \
  -H "JB-Timestamp:1458726351581" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:4bf9845332d1f6256341abcd269b074e" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
	http://127.0.0.1:8080/api/object/Sound/b54aa8a1ab5945649c628b63b65c1db9
```

当获取成功时，HTTP返回：

```
{
    "_id":"b54aa8a1ab5945649c628b63b65c1db9",
    "createdAt":1458726631609,
    "updatedAt":1458726631609,
    "createdPlat":"js",
    "updatedPlat":"js",
    "acl":{
        "*":{
            "read":true,
            "write":true
        }
    },
    "content":"音频的描述",
    "length":300,
    "title":"音频名称"
}
```

###<span id="UpdateObject">更新对象</span>
为了更改一个对象已经有的数据，你可以发送一个 PUT 请求到对象相应的 URL 上，任何你未指定的 key 都不会更改，所以你可以只更新对象数据的一个子集。例如，我们来更改我们对象的一个 title 字段：

```
curl -X PUT \
  -H "JB-Timestamp:1458726351581" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:4bf9845332d1f6256341abcd269b074e" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -d '{"title":"修改后的音频名称"}' \
	http://127.0.0.1:8080/api/object/Sound/b54aa8a1ab5945649c628b63b65c1db9
```

更新成功后，HTTP返回：

```
{
    "code":0,
    "data":{},
    "message":""
}
```

此时，通过 [获取对象](#GetObject) 可以看到之前创建的一条Sound对象中 `title` 字段已经被修改:

```
{
    "_id":"b54aa8a1ab5945649c628b63b65c1db9",
    "createdAt":1458726631609,
    "updatedAt":1458727021776,
    "createdPlat":"js",
    "updatedPlat":"js",
    "acl":{
        "*":{
            "read":true,
            "write":true
        }
    },
    "content":"音频的描述",
    "length":300,
    "title":"修改后的音频名称"
}
```

###<span id="TomicOperations">对象原子操作</span>
对于Nuber类型的字段，例如我们需要记录某个音频的打开次数(readCount)，然而对于一个热门音频，可能会有很多并发打开音频操作，如果每次我们都是通过请求获取改音频目前的readCount，然后加1后再通过请求写到后台，那么这极容易造成数据脏读，引发冲突和覆盖，最终导致结果不准。对于这种场景，JavaBaas提供了对象的原子操作:

```
curl -X PUT \
  -H "JB-Timestamp:1458726351581" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:4bf9845332d1f6256341abcd269b074e" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -d '{"readCount":1}' \
	http://127.0.0.1:8080/api/object/Sound/b54aa8a1ab5945649c628b63b65c1db9/inc
```

请求成功后，通过 [获取对象](#GetObject) 可以看到之前创建的一条Sound对象中 `readCount` 字段已经被加1：

```
{
    "_id":"b54aa8a1ab5945649c628b63b65c1db9",
    "createdAt":1458726631609,
    "updatedAt":1458728247311,
    "createdPlat":"js",
    "updatedPlat":"js",
    "acl":{
        "*":{
            "read":true,
            "write":true
        }
    },
    "content":"音频的描述",
    "length":300,
    "readCount":1,
    "title":"修改后的音频名称"
}
```

###<span id="QueryObjects">查询对象</span>
我们通过发送一个 GET 请求到类的 URL 上，从而一次获取多个对象：

```
curl -X GET \
  -H "JB-Timestamp:1458726351581" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:4bf9845332d1f6256341abcd269b074e" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
	http://127.0.0.1:8080/api/object/Sound

```

结果为：

```
[
    {
        "_id":"8cc807e29f6944a6adc27096e81a5dbe",
        "createdAt":1458729109967,
        "updatedAt":1458729109967,
        "createdPlat":"js",
        "updatedPlat":"js",
        "acl":{
            "*":{
                "read":true,
                "write":true
            }
        },
        "content":"音频的描述3",
        "length":222,
        "title":"音频名称3"
    },
    {
        "_id":"6edf648eab504864a3235e28d89c3196",
        "createdAt":1458729031833,
        "updatedAt":1458729031833,
        "createdPlat":"js",
        "updatedPlat":"js",
        "acl":{
            "*":{
                "read":true,
                "write":true
            }
        },
        "content":"音频的描述2",
        "length":300,
        "title":"音频名称2"
    },
    {
        "_id":"b54aa8a1ab5945649c628b63b65c1db9",
        "createdAt":1458726631609,
        "updatedAt":1458728247311,
        "createdPlat":"js",
        "updatedPlat":"js",
        "acl":{
            "*":{
                "read":true,
                "write":true
            }
        },
        "content":"音频的描述",
        "length":300,
        "readCount":1,
        "title":"修改后的音频名称"
    }
]
```
通常，我们需要根据一些条件查询对象，从而获取需要的数据结果集，这时候，我们需要添加一些查询条件，因为有关查询的内容涉及内容较多，因此我们单拿出一章来讲查询，详见 [查询](#Search)。

###<span id="QueryObjectsCount">查询对象个数</span>
通常，我们需要需要查询某个条件下(关于查询条件的更多介绍详见 [查询](#Search) )的对象个数，例如，统计时长 `length` 大于等于 300 的音频个数：

```
curl -X GET \
  -H "JB-Timestamp:1458726351581" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:4bf9845332d1f6256341abcd269b074e" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -G \
  --data-urlencode 'where={"length":{"$gte":300}}' \
	http://127.0.0.1:8080/api/object/Sound/count
```

查询结果：

```
{
    "code":0,
    "data":{
        "count":2
    },
    "message":""
}
```

###<span id="DeleteObject">删除对象</span>
如果我们需要删除一个对象，可以通过：

```
curl -X DELETE \
  -H "JB-Timestamp:1458726351581" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:4bf9845332d1f6256341abcd269b074e" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
	http://127.0.0.1:8080/api/object/Sound/b54aa8a1ab5945649c628b63b65c1db9
```

删除成功：

```
{
    "code":0,
    "data":{},
    "message":""
}
```

> 注意，删除对象

###<span id="DeleteObjectsByQuery">批量删除对象</span>
同样，我们也能根据查询条件(关于查询条件的更多介绍详见 [查询](#Search) )，例如删除所有时长 `length` 小于 200 或者音频名称 `title` 为 `音频的名称`，执行批量删除操作：

```
curl -X DELETE \
  -H "JB-Timestamp:1458726351581" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:4bf9845332d1f6256341abcd269b074e" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -G \
  --data-urlencode 'where={"$or":[{"length":{"$lt":200}},{"title":"音频的名称"}]}' \
	http://127.0.0.1:8080/api/object/Sound/deleteByQuery
```

##查询
###<span id="Search">基础查询</span>
通过发送一个 GET 请求到类的 URL 上，不需要任何 URL 参数，如上文 [查询对象](#QueryObjects) 中给出的例子。

> 需要注意的是，JavaBaas中，考虑到HTTP请求对 body 内容大小的限制，如果不加条件限制，默认一次请求最多返回 100 条数据的结构化数据。当然你也可以通过指定 `limit` 一次获取更多的数据，`limit` 默认值为100，任何 1 到 1000 之间的值都是可选的，`limit` 如果值小于等于 0 会强制转成100，大于 1000 的值都强制转成 1000。

###查询约束
通过 where 参数的形式可以对查询对象做出约束。<br />
`where` 参数的值应该是JSON编码过的。就是说，如果你查看真正被发出的 URL 请求，它应该是先被 JSON 编码过，然后又被 URL 编码过。最简单的使用 where 参数的方式就是包含应有的 key 和 value。例如，如果我们想要查询音频名称 `title` 中含有 `音频` 字符串并且音频时长 `length` 大于等于 300 的所有音频：

```
curl -X GET \
  -H "JB-Timestamp:1458726351581" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:4bf9845332d1f6256341abcd269b074e" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -G \
  --data-urlencode 'where={"length":{"$lte":300},"title":{"$regex":".*音频.*"}}' \
	http://127.0.0.1:8080/api/object/Sound
```

查询结果：

```
[
    {
        "_id":"62873a95570c429aaadb971e0d2dea25",
        "createdAt":1458788680705,
        "updatedAt":1458788680705,
        "createdPlat":"js",
        "updatedPlat":"js",
        "acl":Object{...},
        "content":"音频的描述5",
        "length":80,
        "title":"音频名称5"
    },
    {
        "_id":"6edf648eab504864a3235e28d89c3196",
        "createdAt":1458729031833,
        "updatedAt":1458729031833,
        "createdPlat":"js",
        "updatedPlat":"js",
        "acl":Object{...},
        "content":"音频的描述2",
        "length":300,
        "title":"音频名称2"
    }
]
```

`where` 参数支持下面一些选项：<br />

Key | Operation 
--- | ---
$lt | 小于
$lte | 小于等于
$gt	| 大于
$gte | 大于等于
$ne	 | 不等于
$in	 | 包含
$nin | 不包含
$exists | 这个Key有值
$regex | 正则匹配
$options | 和 `$regex` 配合使用
$and | 并且
$or | 或
$all | 数组查询用到
$sub | 子查询


> 除了上述选项外，JavaBaas还能支持其他 MongoDB 支持的查询操作符，详见 [MongoDB官网](https://www.mongodb.org)。


例如，我们想要查询音频被打开次数 `readCount` 小于 5 的音频，我们应该这样请求：

```
curl -X GET \
  -H "JB-Timestamp:1458726351581" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:4bf9845332d1f6256341abcd269b074e" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -G \
  --data-urlencode 'where={"readCount":{"$lt":5}}' \
	http://127.0.0.1:8080/api/object/Sound
```
结果为：

```
[
    {
        "_id":"9d4846e0f90e4cc4bec6dca31c3af2b4",
        "createdAt":1458794913872,
        "updatedAt":1458794913872,
        "createdPlat":"js",
        "updatedPlat":"js",
        "acl":Object{...},
        "content":"描述",
        "length":190,
        "readCount":2,
        "title":"名称"
    }
]
```

> 需要注意的是，无论是使用大于还是小于操作符，如果某个对象的该字段为空，即不存在，则该对象不会进入查询结果集，但是如果该对象的该字段值为0，即被赋过值，则会进入上面的查询结果集。

如果我们想要查询音频被打开次数 `readCount` 小于 5 的音频，包含未被打开过的音频，我们应该这样请求：

```
curl -X GET \
  -H "JB-Timestamp:1458726351581" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:4bf9845332d1f6256341abcd269b074e" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -G \
  --data-urlencode 'where={"$or":[{"readCount":{"$lt":5}},{"readCount":{"$exists":false}}]}' \
	http://127.0.0.1:8080/api/object/Sound
```
结果为：

```
[
    {
        "_id":"9d4846e0f90e4cc4bec6dca31c3af2b4",
        "createdAt":1458794913872,
        "updatedAt":1458794913872,
        "createdPlat":"js",
        "updatedPlat":"js",
        "acl":Object{...},
        "content":"描述",
        "length":190,
        "readCount":2,
        "title":"名称"
    },
    {
        "_id":"4dbdb910ef7d444b9659353faf138a63",
        "createdAt":1458793213415,
        "updatedAt":1458793213415,
        "createdPlat":"js",
        "updatedPlat":"js",
        "acl":Object{...},
        "content":"这是描述",
        "length":390,
        "title":"这是一个名称"
    }
]
```

如果我们查询音频名称 `title` 为 `音频名称` 或 `名称` 的所有音频，我们可以使用 `$or` 操作符，也可以这样请求：

```
curl -X GET \
  -H "JB-Timestamp:1458726351581" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:4bf9845332d1f6256341abcd269b074e" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -G \
  --data-urlencode 'where={"title":{"$in":["音频名称","名称"]}}' \
	http://127.0.0.1:8080/api/object/Sound
```

如果我们希望查询的是个有序的结果集，我们可以通过使用order参数来指定一个或者几个字段排序，例如，我们查询音频打开次数 `readCount` 为 5 的所有音频，查询结果按着音频创建时间 `createdAt` 倒序排序，我们可以这样请求：

```
curl -X GET \
  -H "JB-Timestamp:1458726351581" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:4bf9845332d1f6256341abcd269b074e" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -G \
  --data-urlencode 'where={"readCount":5}' \
  --data-urlencode 'order={"createdAt":-1}' \
	http://127.0.0.1:8080/api/object/Sound
```

结果为：

```
[
    {
        "_id":"62873a95570c429aaadb971e0d2dea25",
        "createdAt":1458788680705,
        "updatedAt":1458804782388,
        "createdPlat":"js",
        "updatedPlat":"js",
        "acl":Object{...},
        "content":"音频的描述5",
        "length":80,
        "readCount":5,
        "title":"音频名称5"
    },
    {
        "_id":"6edf648eab504864a3235e28d89c3196",
        "createdAt":1458729031833,
        "updatedAt":1458804796857,
        "createdPlat":"js",
        "updatedPlat":"js",
        "acl":Object{...},
        "content":"音频的描述2",
        "length":300,
        "readCount":5,
        "title":"音频名称2"
    }
]
```

> 如果查询的请求没有指定 `order` JavaBaas会默认按 `updatedAt` 倒序排序。
> 使用 `order` 设置字段排序时， `-1` 代表倒序排序， `1` 代表正序排序

同理如果根据两个或以上字段多复合排序，例如上面的查询改成按时长 `length` 倒序并且按创建时间正序排序的话，请求为：

```
curl -X GET \
  -H "JB-Timestamp:1458726351581" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:4bf9845332d1f6256341abcd269b074e" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -G \
  --data-urlencode 'where={"readCount":5}' \
  --data-urlencode 'order={"length":-1,"createdAt":1}' \
	http://127.0.0.1:8080/api/object/Sound
```

###数组查询
如果查询的字段是个数据，例如 `Sound` 类中有个数组字段标签 `tag` ,里面记录了音频对象的一些标签信息，如果我们想查询标签含有 `经典` 的音频，我们可以通过发送请求：

```
curl -X GET \
  -H "JB-Timestamp:1458726351581" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:4bf9845332d1f6256341abcd269b074e" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -G \
  --data-urlencode 'where={"tag":"经典"}' \
	http://127.0.0.1:8080/api/object/Sound
```

结果为：

```
[
    {
        "_id":"62873a95570c429aaadb971e0d2dea25",
        "createdAt":1458788680705,
        "updatedAt":1458810339735,
        "createdPlat":"js",
        "updatedPlat":"js",
        "acl":Object{...},
        "content":"音频的描述5",
        "length":80,
        "readCount":5,
        "tag":[
            "大陆",
            "爵士",
            "李四",
            "经典"
        ],
        "title":"音频名称5"
    },
    {
        "_id":"4dbdb910ef7d444b9659353faf138a63",
        "createdAt":1458793213415,
        "updatedAt":1458810281527,
        "createdPlat":"js",
        "updatedPlat":"js",
        "acl":Object{...},
        "content":"这是描述",
        "length":390,
        "tag":[
            "流行",
            "经典",
            "张三"
        ],
        "title":"这是一个名称"
    }
]
```

当然如果查询标签 `tag` 中同时含有 `经典`、`流行`和`张三`，可以使用 `$all` 操作符发送请求：

```
curl -X GET \
  -H "JB-Timestamp:1458726351581" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:4bf9845332d1f6256341abcd269b074e" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -G \
  --data-urlencode 'where={"tag":{"$all":["经典","流行","张三"]}}' \
	http://127.0.0.1:8080/api/object/Sound
```

###关系查询
JavaBaas提供了一种字段类型 `Pointer` ，`Pointer` 类型是用来设定某类的一个对象作为另一个对象(可以是来自相同或者不同的类)的值使用的，它包含了 `className` 、 `__type` 和 `_id` 属性值，用来提取目标对象：

```
{
    "__type":"Pointer",
    "className":"_User",
    "_id":"fae4e8b7f8d14f3fadd49f3cbb1ca29a"
}
```

上面的 `Pointer` 类型的字段内容指向 `_User` 类中 `_id` 为 `fae4e8b7f8d14f3fadd49f3cbb1ca29a` 的对象。<br />
需要注意的是,同一个类的同一个 `Pointer` 类型的字段，可以指向不同的类，例如有评论 `Comment` 类，包含一个 `Pointer` 类型字段评论主体 `entity` ，该字段既可以指向 `Sound`， 也可以指向 `Album`，即评论表里即能记录音频评论信息，也能记录专辑评论信息。<br />

对于涉及对象之间的关系数据查询，假如你想获取对象，而这个对象的一个字段对应了另一个对象，例如，音频 `Sound` 类中有一个字段作者 `user` 是一个 `Pointer` 字段，它指向 `_User` 表，现在需要查询作者的用户id `_id` 为 `a6159350c5964cebbe523d679b9889ae` 的所有音频，你可以通过请求：

```
curl -X GET \
  -H "JB-Timestamp:1458726351581" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:4bf9845332d1f6256341abcd269b074e" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -G \
  --data-urlencode 'where={"user":{"__type":"Pointer","className":"_User","_id":"a6159350c5964cebbe523d679b9889ae"}}' \
	http://127.0.0.1:8080/api/object/Sound
```

结果为：

```
[
    {
        "_id":"62873a95570c429aaadb971e0d2dea25",
        "createdAt":1458788680705,
        "updatedAt":1458812607645,
        "createdPlat":"js",
        "updatedPlat":"js",
        "acl":Object{...},
        "content":"音频的描述5",
        "length":80,
        "readCount":5,
        "tag":Array[4],
        "title":"音频名称5",
        "user":{
            "__type":"Pointer",
            "className":"_User",
            "_id":"a6159350c5964cebbe523d679b9889ae"
        }
    }
]
```

如果想在查询结果将 `Pointer` 指向的对象信息包含进来，可以在请求中添加 `include` 参数：

```
curl -X GET \
  -H "JB-Timestamp:1458726351581" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:4bf9845332d1f6256341abcd269b074e" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -G \
  --data-urlencode 'where={"user":{"__type":"Pointer","className":"_User","_id":"a6159350c5964cebbe523d679b9889ae"}}' \
  --data-urlencode 'include=user' \
	http://127.0.0.1:8080/api/object/Sound
```

结果为：

```
[
    {
        "_id":"62873a95570c429aaadb971e0d2dea25",
        "createdAt":1458788680705,
        "updatedAt":1458812607645,
        "createdPlat":"js",
        "updatedPlat":"js",
        "acl":Object{...},
        "content":"音频的描述5",
        "length":80,
        "readCount":5,
        "tag":Array[4],
        "title":"音频名称5",
        "user":{
            "__type":"Pointer",
            "className":"_User",
            "_id":"a6159350c5964cebbe523d679b9889ae",
            "createdAt":1458812568918,
            "updatedAt":1458812568918,
            "createdPlat":"admin",
            "updatedPlat":"admin",
            "acl":Object{...},
            "username":"xiaoming"
        }
    }
]
```

如果某个对象有两个或者连个以上的 `Pointer` 字段，而你希望查询时把两个或者两个以上的 `Pointer` 类型字段都包含进来，可以在请求中加入多个字段名，用 `,` 隔开，例如上面的例子中，假设 `Sound` 类中还有一个字段专辑 `album` 指向的是 `Album` 类，查询时希望将 `album` 的相关数据也包含进来，可以这样请求：

```
curl -X GET \
  -H "JB-Timestamp:1458726351581" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:4bf9845332d1f6256341abcd269b074e" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -G \
  --data-urlencode 'where={"user":{"__type":"Pointer","className":"_User","_id":"a6159350c5964cebbe523d679b9889ae"}}' \
  --data-urlencode 'include=user,album' \
	http://127.0.0.1:8080/api/object/Sound
```

假如我们遇到这样的需求，接着上面的例子，假设 `Album` 类中也有一个 `Pointer` 类型字段 `user` 指向 `_User` 类，代表创建专辑的用户。现在我们需要查询结果中将 `album` 中的 `user` 信息也包含进来，可以这样请求：

```
curl -X GET \
  -H "JB-Timestamp:1458726351581" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:4bf9845332d1f6256341abcd269b074e" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -G \
  --data-urlencode 'where={"user":{"__type":"Pointer","className":"_User","_id":"a6159350c5964cebbe523d679b9889ae"}}' \
  --data-urlencode 'include=user,album.user' \
	http://127.0.0.1:8080/api/object/Sound
```

> 可以看到我们的请求中，`include` 的参数值是 `user,album.user` ，而不是 `user,ablum,album.user` ，这是因为 JavaBaas 在处理含有 `include` 的请求时，会逐层添加相关数据，即对于 `album.user`， JavaBaas 会先在查询结果中添加 `album` 数据，再遍历添加 `album.user` 数据。

> 需要注意的是，对于 `Pointer` 类型的字段指向不同的类时，例如上文关于评论 `Comment`的例子，`entity` 字段即指向 `Sound` 类，也指向 `Album` 类，那么对于一个查询，查询的结果中同时含有指向 `Sound` 类和指向 `Album` 类的数据，这个时候即使 `include` 的参数值是 `entity.user` ，而你仅仅是想把 `Album` 类中的 `user` 信息包含进去 ，但是因为 `Sound` 类中也有 `user` 字段，查询结果中，也会把指向 `Sound` 类中的 `user` 信息包含进去。而且即使 `Sound ` 类中的 `user` 字段指向的不是 `_User` ，只要是个 `Pointer` 类型的字段，也会包含进去。就是这么任性，好吧，其实是为了兼顾性能，不得已而为之。

###子查询
当我们需要构建这样一个查询，它的查询条件需要另个一查询的结果，这个时候我们就需要用到子查询 操作符 `$sub` ， 例如，音频 `Sound` 类中有一个字段作者 `user` 是一个 `Pointer` 字段，它指向 `_User` 类，现在我们要查询用户的昵称 `nickname` 中含有 `ABC` 字符串的用户发布的所有音频，要求查询结果包含用户信息，你可以通过请求：

```
curl -X GET \
  -H "JB-Timestamp:1458726351581" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:4bf9845332d1f6256341abcd269b074e" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -G \
  --data-urlencode 'where={"user":{"$sub":{"where":{"nickname":{"$regex":".*ABC.*"}},"searchClass":"_User"}}}' \
  --data-urlencode 'include=user' \
	http://127.0.0.1:8080/api/object/Sound
```
> 在使用子查询的过程中需要注意的是，子查询部分的结果集，默认且最大为 1000 条，如果大于 1000 条，多余的数据会被忽略，可能会造成查询结果与预想有差异，例如上面的查询，如果用户昵称 `nickname` 中含有 `ABC` 字符串的用户数大于 1000 个的话，那么查询的结果将是不准确的，这个可能需要在表结构设计的时候避免出现这样的情况。

除了上面这种场景的子查询，还有另一种场景的子查询。例如 音频 `Sound` 类中有一个字段专辑 `album` 是一个 `Pointer` 字段，指向 `Album` 类，专辑订阅信息 `SubscriptionAlbum` 类中有两个 `Pointer` 类型字段订阅者 `user` 和专辑 `subsAlbum` (为了跟 `Sound` 中的 `album` 区分，这个字段名称命名为 `subsAlbum` ) ，分别指向 `_User` 和 `Album` 类，现知道用户 A ，其 `_id` 为 `a6159350c5964cebbe523d679b9889ae` ，要查询用户 A 订阅的专辑的所有音频数据，且查询结果按音频创建时间倒序排序，同时查询结果要包含 `album` 数据，我们可以这样请求：

```
curl -X GET \
  -H "JB-Timestamp:1458726351581" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:4bf9845332d1f6256341abcd269b074e" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -G \
  --data-urlencode 'where={"album":{"$sub":{"where":{"user":{"__type":"Pointer","className":"_User","_id":"a6159350c5964cebbe523d679b9889ae"}},"searchClass":"SubscriptionAlbum","searchKey":"subsAlbum","targetClass":"Album"}}}' \
  --data-urlencode 'include=album' \
  --data-urlencode 'order={"createdAt":-1}' \
	http://127.0.0.1:8080/api/object/Sound
```

##应用
你可以查看、创建和编辑你的应用通过 REST API ，需要注意的是，有关应用的所有 REST API 都需要超级权限 `adminKey` 。
###<span id="CreateApp">创建应用</span>
你可以通过发送一个请求去创建一个新的应用：

```
curl -X POST \
  -H "JB-Timestamp:1459134010861" \
  -H "JB-AdminSign:984df38bc629c55aade4b1951631f6b9" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -d '{"name":"NewApp"}' \
	http://127.0.0.1:8080/api/admin/app
```
创建成功后返回:

```
{
    "code":0,
    "data":{
        "app":{
            "id":"56f89eb7ffe4f21c3d3e8f5e",
            "name":"NewApp",
            "key":"d12f7db3058048938f2ac3e8e4cab78e",
            "masterKey":"5ea66ffe4f304336ac9cf8da5846deab",
            "cloudSetting":null,
            "pushAccount":null
        }
    },
    "message":""
}
```
###<span id="GetAppList">获取应用列表</span>
你可以查看你的应用列表通过下面的请求：

```
curl -X GET \
  -H "JB-Timestamp:1459134010861" \
  -H "JB-AdminSign:984df38bc629c55aade4b1951631f6b9" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
	http://127.0.0.1:8080/api/admin/app
```
返回应用列表：

```
[
    {
        "id":"56cd5194c6db7c372fd1563f",
        "name":"FirstApp",
        "key":"8fdd2c7fad56430688f192ca835b524b",
        "masterKey":"53a0b6967e2f4ac399341c4ac93f2db3",
        "cloudSetting":null,
        "pushAccount":null,
        "userCount":1,
        "yesterday":0,
        "currentMonth":0
    },
    {
        "id":"56f89eb7ffe4f21c3d3e8f5e",
        "name":"NewApp",
        "key":"d12f7db3058048938f2ac3e8e4cab78e",
        "masterKey":"5ea66ffe4f304336ac9cf8da5846deab",
        "cloudSetting":null,
        "pushAccount":null,
        "userCount":0,
        "yesterday":0,
        "currentMonth":0
    }
]
```
###<span id="GetApp">获取应用</span>
如果你已经知道某个应用的id，你也可以通过下面的请求获取：

```
curl -X GET \
  -H "JB-Timestamp:1459134010861" \
  -H "JB-AdminSign:984df38bc629c55aade4b1951631f6b9" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
	http://127.0.0.1:8080/api/admin/app/56f89eb7ffe4f21c3d3e8f5e
```
###<span id="DeleteApp">删除应用</span>
你可以通过下面的请求删除某个应用：

```
curl -X DELETE \
  -H "JB-Timestamp:1459134010861" \
  -H "JB-AdminSign:984df38bc629c55aade4b1951631f6b9" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
	http://127.0.0.1:8080/api/admin/app/56f89eb7ffe4f21c3d3e8f5e
```
###<span id="ResetAppKey">重置应用key</span>
有时候因为应用 `key` 泄露或者其他原因，我们可以修改应用的 `key` 通过下面的请求：

```
curl -X PUT \
  -H "JB-Timestamp:1459134010861" \
  -H "JB-AdminSign:984df38bc629c55aade4b1951631f6b9" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
	http://127.0.0.1:8080/api/admin/app/56cd5194c6db7c372fd1563f/resetKey
```

###<span id="ResetAppMasterKey">重置应用masterKey</span>
有时候因为应用 `masterKey` 泄露或者其他原因，我们可以修改应用的 `masterKey` 通过下面的请求：

```
curl -X PUT \
  -H "JB-Timestamp:1459134010861" \
  -H "JB-AdminSign:984df38bc629c55aade4b1951631f6b9" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
	http://127.0.0.1:8080/api/admin/app/56cd5194c6db7c372fd1563f/resetMasterKey
```

###<span id="ExportAppData">导出应用数据</span>
业务数据备份是每个应用都会考虑的问题，JavaBaas 提供了应用结构数据导出的接口，你可以发送请求：

```
curl -X GET \
  -H "JB-Timestamp:1459134010861" \
  -H "JB-AdminSign:984df38bc629c55aade4b1951631f6b9" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
	http://127.0.0.1:8080/api/admin/app/56cd5194c6db7c372fd1563f/export
```
返回值为：

```
{
    "id":"56cd5194c6db7c372fd1563f",
    "name":"BUU",
    "key":"c3c5f4c63c5740aabdb04a28d5be636a",
    "masterKey":"c5814e5f593742bcb3c206041bea8c36",
    "cloudSetting":null,
    "clazzs":[
        Object{...},
        Object{...},
        Object{...},
        Object{...},
        {
            "id":"56f263aeffe4f20928f56ae4",
            "name":"Sound",
            "acl":Object{...},
            "internal":false,
            "fields":[
                {
                    "id":"56f4ffa0ffe4f2186e7f2b50",
                    "name":"album",
                    "type":8,
                    "internal":false,
                    "security":false,
                    "required":false
                },
                Object{...},
                Object{...},
                Object{...},
                Object{...},
                Object{...},
                Object{...}
            ]
        },
        Object{...}
    ],
    "pushAccount":null
}
```

> 需要注意的是,导出应用数据导出的是一个 json 串，而且这里导出的不是 App 的所有结构化数据，只是 App 相关信息和类结构等相关数据。

###<span id="ImportAppData">导入应用数据</span>
有了备份，就需要备份恢复，JavaBaas 提供了应用数据导入的接口，你可以发送请求：

```
curl -X POST \
  -H "JB-Timestamp:1459134010861" \
  -H "JB-AdminSign:984df38bc629c55aade4b1951631f6b9" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -d '{这里是应用备份数据的 json 串}' \
	http://127.0.0.1:8080/api/admin/app/56cd5194c6db7c372fd1563f/import
```

##类
你可以查看、创建和编辑你的类通过 REST API ，需要注意的是，有关类的所有 REST API 都需要管理权限 `masterKey` 。
###<span id="CreateClass">创建类</span>
你可以通过发送请求，来完成创建一个新的类的操作：

```
curl -X POST \
  -H "JB-Timestamp:1459137092965" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-MasterSign:a869a91a43496ae3a16d8e9b07cf8b69" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -d '{"name":"NewClass"}' \
	http://127.0.0.1:8080/api/master/clazz
```
###<span id="GetClassList">获取类列表</span>
你可以查看你的类列表通过下面的请求：

```
curl -X GET \
  -H "JB-Timestamp:1459137092965" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-MasterSign:a869a91a43496ae3a16d8e9b07cf8b69" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
	http://127.0.0.1:8080/api/master/clazz
```
返回：

```
[
    {
        "id":"56cd5194c6db7c372fd1564b",
        "app":Object{...},
        "name":"_File",
        "acl":Object{...},
        "internal":true,
        "count":0
    },
    {
        "id":"56cd5194c6db7c372fd15647",
        "app":Object{...},
        "name":"_Installation",
        "acl":Object{...},
        "internal":true,
        "count":0
    },
    {
        "id":"56cd5194c6db7c372fd15653",
        "app":Object{...},
        "name":"_PushLog",
        "acl":Object{...},
        "internal":true,
        "count":0
    },
    {
        "id":"56cd5194c6db7c372fd15640",
        "app":Object{...},
        "name":"_User",
        "acl":Object{...},
        "internal":true,
        "count":1
    },
    {
        "id":"56f8abc9ffe4f21c3d3e8f7a",
        "app":Object{...},
        "name":"NewClass",
        "acl":Object{...},
        "internal":false,
        "count":0
    },
    {
        "id":"56f263aeffe4f20928f56ae4",
        "app":Object{...},
        "name":"Sound",
        "acl":Object{...},
        "internal":false,
        "count":6
    },
    {
        "id":"56f4ff4effe4f2186e7f2b4c",
        "app":Object{...},
        "name":"SubscriptionAlbum",
        "acl":Object{...},
        "internal":false,
        "count":0
    }
]
```
###<span id="GetClass">获取类</span>
如果你已经知道类的名称 ，你可以通过下面的请求获得类的相关信息：

```
curl -X GET \
  -H "JB-Timestamp:1459137092965" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-MasterSign:a869a91a43496ae3a16d8e9b07cf8b69" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
	http://127.0.0.1:8080/api/master/clazz/Sound
```
###<span id="DeleteClass">删除类</span>
对于不再使用的类，我们可以通过下面的请求删除它：

```
curl -X DELETE \
  -H "JB-Timestamp:1459137092965" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-MasterSign:a869a91a43496ae3a16d8e9b07cf8b69" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
	http://127.0.0.1:8080/api/master/clazz/_User
```
> 需要说明的是 JavaBaas 内建类是不允许删除的，比如 `_User`、`_File`、`_Installation`、`_PushLog` 等。

###<span id="ExportClassData">导出类数据</span>

```
curl -X GET \
  -H "JB-Timestamp:1459137092965" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-MasterSign:a869a91a43496ae3a16d8e9b07cf8b69" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
	http://127.0.0.1:8080/api/master/clazz/Sound/export
```
返回为：

```
{
    "id":"56f263aeffe4f20928f56ae4",
    "name":"Sound",
    "acl":{
        "*":{
            "find":true,
            "insert":true,
            "update":true,
            "delete":true
        }
    },
    "internal":false,
    "fields":[
        {
            "id":"56f4ffa0ffe4f2186e7f2b50",
            "name":"album",
            "type":8,
            "internal":false,
            "security":false,
            "required":false
        },
        Object{...},
        Object{...},
        Object{...},
        Object{...},
        Object{...},
        Object{...}
    ]
}
```
###<span id="ImportClassData">导入类数据</span>
通过下面的请求你可以执行导入类数据操作：

```
curl -X POST \
  -H "JB-Timestamp:1459137092965" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-MasterSign:a869a91a43496ae3a16d8e9b07cf8b69" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -d '{这里是类结构化数据的 json 串}' \
	http://127.0.0.1:8080/api/master/clazz/Sound/export
```
###<span id="SetClassACL">设置类的acl</span>
你可以通过下面的请求设置类级别的acl：

```
curl -X POST \
  -H "JB-Timestamp:1459137092965" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-MasterSign:a869a91a43496ae3a16d8e9b07cf8b69" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -d '{"a6159350c5964cebbe523d679b9889ae":{"find":true,"insert":true}}' \
	http://127.0.0.1:8080/api/master/clazz/NewClass/acl
```
> 补充说明，类级别的acl的优先级大于字段级别的acl优先级

##字段
你可以查看、创建和编辑你的字段通过 REST API ，需要注意的是，有关字段的所有 REST API 都需要管理权限 `masterKey` 。（以下所有有关字段的例子都是在 `Sound` 类中操作）
###<span id="CreateFiled">创建字段</span>
你可以通过下面的请求创建一个新的字段：

```
curl -X POST \
  -H "JB-Timestamp:1459137092965" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-MasterSign:a869a91a43496ae3a16d8e9b07cf8b69" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -d '{"name":"newFiled","type":1}' \
	http://127.0.0.1:8080/api/master/clazz/Sound/field
```
###<span id="GetFieldList">字段列表</span>
你可以通过下面的请求获取字段列表：

```
curl -X GET \
  -H "JB-Timestamp:1459137092965" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-MasterSign:a869a91a43496ae3a16d8e9b07cf8b69" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
	http://127.0.0.1:8080/api/master/clazz/Sound/field
```
返回：

```
[
    {
        "id":"56f8d825ffe4f21c3d3e8f7d",
        "clazz":{
            "id":"56f263aeffe4f20928f56ae4",
            "app":Object{...},
            "name":"Sound",
            "acl":Object{...},
            "internal":false,
            "count":0
        },
        "name":"newFiled",
        "type":1,
        "internal":false,
        "security":false,
        "required":false
    },
    {
        "id":"56f263b9ffe4f20928f56ae5",
        "clazz":Object{...},
        "name":"title",
        "type":1,
        "internal":false,
        "security":false,
        "required":false
    },
    {
        "id":"56f3b671ffe4f215113d7604",
        "clazz":Object{...},
        "name":"user",
        "type":8,
        "internal":false,
        "security":false,
        "required":false
    }
]
```
###<span id="GetFiled">获取字段</span>
你可以通过下面的请求获取一个字段的信息：

```
curl -X GET \
  -H "JB-Timestamp:1459137092965" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-MasterSign:a869a91a43496ae3a16d8e9b07cf8b69" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
	http://127.0.0.1:8080/api/master/clazz/Sound/field/newFiled
```
###<span id="UpdateField">更新字段</span>
你可以通过下面的请求更新一个字段的信息：

```
curl -X PUT \
  -H "JB-Timestamp:1459137092965" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-MasterSign:a869a91a43496ae3a16d8e9b07cf8b69" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -d '{"security":true}' \
	http://127.0.0.1:8080/api/master/clazz/Sound/field/newFiled
```
> 目前 JavaBaas 只支持修改字段的是否必填 `required ` 和客户端是否可见 `security ` 属性。

###<span id="DeleteFiled">删除字段</span>
你可以通过下面的请求删除一个的字段：

```
curl -X DELETE \
  -H "JB-Timestamp:1459137092965" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-MasterSign:a869a91a43496ae3a16d8e9b07cf8b69" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
	http://127.0.0.1:8080/api/master/clazz/Sound/field/newFiled
```

##用户
用户系统是所有应用中最常见的子系统，为了避免重复建设，提高开发效率，`JavaBaas`内建了简单的用户系统。

用户类`User`的基本功能与其他的类是相同的。用户对象和其他对象不同的是，每个用户必须有用户名`username`和密码`password`，密码会被自动地加密和存储。JavaBaas强制要求`username`和`email`这两个字段必须是没有重复的。

###<span id="RegUser">注册用户</span>
注册一个新用户与创建一个新的普通对象之间的不同点在于`username`和`password`字段都是必需的。`password`字段会以和其他的字段不一样的方式处理，它在储存时会被加密而且永远不会被返回给任何来自客户端的请求。

为了注册一个新的用户，需要向`user`路径发送一个POST请求，且可以在创建时同时提交一个自定义字段。例如，创建一个有昵称的新用户（其中昵称为自定义字段）:

```
curl -X POST \
  -H "JB-Timestamp:1459823352367" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:3f0473567b1635a0b83648a75e895ff7" \
  -H "Content-Type: application/json" \
  -d '{"username":"codi","password":"123456","nickname":"Codi"}' \
	http://127.0.0.1:8080/api/users
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

> SessionToken。在`JavaBaas`中，所有的请求通过添加请求头`JB-SessionToken`来表示当前请求的用户身份。因此，在注册或登录成功后，客户端需缓存用户的`SessionToken`作为之后请求的身份标识。同时，当用户密码信息变化时，之前获取的`SessionToken`将失效，需重新登录进行获取。

###<span id="UserLogin">用户登录</span>
用户注册成功后，可以使用用户名密码进行登录，登录成功后，会获得所有的用户信息。

```
curl -X GET \
  -H "JB-Timestamp:1459823352367" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:3f0473567b1635a0b83648a75e895ff7" \
  -H "Content-Type: application/json" \
  -G \
  --data-urlencode 'username=codi' \
  --data-urlencode 'password=123456' \
	http://127.0.0.1:8080/api/user/login
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

###<span id="BindPlatform">绑定社交平台</span>
`JavaBaas`支持将系统用户与第三方平台用户进行绑定。如新浪微博、微信、qq等，这样就允许你的用户直接用第三方平台用户身份进行登录。关联完成后，authData将被存储到用户信息中，并通过登录即可重新获取。

首先使用第三方平台进行用户授权（或使用ShareSdk等工具），完成授权后第三方平台讲返回accessToken以及用户id等信息。客户端向`JavaBaas`提交此信息后，后台会进行授权检查，检查通过后完成绑定。

```
curl -X POST \
  -H "JB-Timestamp:1459823352367" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:3f0473567b1635a0b83648a75e895ff7" \
  -H "JB-SessionToken:9ce57fb007544d318b642d084989bc40" \
  -H "Content-Type: application/json" \
  -d '{"accessToken":"69B307BA98F8C8D2455CC8D9040A6A96","uid":"AB782D5190C50B588B536145FEEF6A0F"}' \
	http://127.0.0.1:8080/api/a6159350c5964cebbe523d679b9889ae/binding/{platform}
```

其中：

* id:用户id
* platform:第三方平台的名称，微博:weibo、qq:qq、微信:weixin。
* accessToken:使用第三方平台授权时获取的token
* uid:使用第三方平台授权时获取的用户身份表示，其中微博取uid字段，qq、微信取openId字段

###<span id="ReleasePlatform">解绑社交平台</span>
使用此接口将用户与第三方平台解除绑定。

```
curl -X DELETE \
  -H "JB-Timestamp:1459823352367" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:3f0473567b1635a0b83648a75e895ff7" \
  -H "JB-SessionToken:9ce57fb007544d318b642d084989bc40" \
  -H "Content-Type: application/json" \
	http://127.0.0.1:8080/api/a6159350c5964cebbe523d679b9889ae/release/{platform}
```

其中：

* id:用户id
* platform:第三方平台的名称，微博:weibo、qq:qq、微信:weixin。

###<span id="UpdateUser">修改用户信息</span>
你可以通过发送请求修改用户信息：
```
curl -X PUT \
  -H "JB-Timestamp:1459823352367" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:3f0473567b1635a0b83648a75e895ff7" \
  -H "JB-SessionToken:9ce57fb007544d318b642d084989bc40" \
  -H "Content-Type: application/json" \
  -d '{"oldPassword":"123456","newPassword":"654321"}' \
	http://127.0.0.1:8080/api/a6159350c5964cebbe523d679b9889ae/updatePassword
```

###<span id="UpdatePassword">修改用户密码</span>
修改密码需要让用户输入一次旧密码做验证，旧密码正确才可以修改为新密码。同时，登录用户才可以修改自己的密码，因此调用修改密码接口需要在请求头中加入`JB-SessionToken`来表示当前请求的用户身份。

```
curl -X PUT \
  -H "JB-Timestamp:1459823352367" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:3f0473567b1635a0b83648a75e895ff7" \
  -H "JB-SessionToken:9ce57fb007544d318b642d084989bc40" \
  -H "Content-Type: application/json" \
  -d '{"oldPassword":"123456","newPassword":"654321"}' \
	http://127.0.0.1:8080/api/a6159350c5964cebbe523d679b9889ae/updatePassword
```
其中：

* id:用户id
* old_password:用户的老密码
* new_password:用户的新密码

###<span id="UserLoginWithSNS">第三方登录</span>
用户于第三方平台绑定后，可以使用第三方平台授权信息进行登录操作。登录成功后，会获得所有的用户信息。

```
curl -X POST \
  -H "JB-Timestamp:1459823352367" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:3f0473567b1635a0b83648a75e895ff7" \
  -H "Content-Type: application/json" \
  -d '{"accessToken":"69B307BA98F8C8D2455CC8D9040A6A96","uid":"AB782D5190C50B588B536145FEEF6A0F"}' \
	http://127.0.0.1:8080/api/user/loginWithSns/{platform}
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

##文件
JavaBaas 目前的文件系统使用第三方的 [七牛云存储](http://www.qiniu.com) 。

###<span id="CreateFile">创建文件</span>
###<span id="GetFileAuthentication">请求文件上传所需要的鉴权信息</span>
在往七牛上传物理文件前，需要先获取一个鉴权信息，通过下面的请求:

```
curl -X GET \
  -H "JB-Timestamp:1459137092965" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:a869a91a43496ae3a16d8e9b07cf8b69" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
	http://127.0.0.1:8080/api/file/getToken?fileName=filename&platform=qiniu
```

返回：

```
{
    "code":0,
    "data":{
        "name":"56308742a290aa5006f2b0d6/74d0d53359a242489763b8d5990cd186",
        "token":"DH6c4OqGiKWajTqMFqkdmvNbn-53q50iMw1hCslZ:GEWTSt3Y6YdjOt0ceD27eJXXK8g=:eyJwZXJzaXN0ZW50UGlwZWxpbmUiOiJKYXZhQmFhc0ZpbGUiLCJzY29wZSI6ImphdmFiYWFzLXBybzo1NjMwODc0MmEyOTBhYTUwMDZmMmIwZDYvNzRkMGQ1MzM1OWEyNDI0ODk3NjNiOGQ1OTkwY2QxODYiLCJwZXJzaXN0ZW50Tm90aWZ5VXJsIjoiaHR0cDovLzExOS4yNTQuOTcuMjA2OjgwODAvYXBpL2ZpbGUvbm90aWZ5L3Fpbml1IiwicmV0dXJuQm9keSI6InBsYXRmb3JtXHUwMDNkcWluaXVcdTAwMjZrZXlcdTAwM2Q3NGQwZDUzMzU5YTI0MjQ4OTc2M2I4ZDU5OTBjZDE4Nlx1MDAyNnNvdXJjZVx1MDAzZGZpbGVuYW1lXHUwMDI2YXBwXHUwMDNkNTYzMDg3NDJhMjkwYWE1MDA2ZjJiMGQ2XHUwMDI2cGxhdFx1MDAzZGpzXHUwMDI2bWltZVR5cGVcdTAwM2QkKG1pbWVUeXBlKVx1MDAyNnNpemVcdTAwM2QkKGZzaXplKVx1MDAyNmR1cmF0aW9uXHUwMDNkJChhdmluZm8uZm9ybWF0LmR1cmF0aW9uKVx1MDAyNmF2aW5mb1x1MDAzZCQoYXZpbmZvKVx1MDAyNnBlcnNpc3RlbnRJZFx1MDAzZCQocGVyc2lzdGVudElkKSIsImNhbGxiYWNrVXJsIjoiaHR0cDovLzExOS4yNTQuOTcuMjA2OjgwODAvYXBpL2ZpbGUvY2FsbGJhY2siLCJkZWFkbGluZSI6MTQ1OTg4NjIxMSwiY2FsbGJhY2tCb2R5IjoicGxhdGZvcm1cdTAwM2RxaW5pdVx1MDAyNmtleVx1MDAzZDc0ZDBkNTMzNTlhMjQyNDg5NzYzYjhkNTk5MGNkMTg2XHUwMDI2c291cmNlXHUwMDNkZmlsZW5hbWVcdTAwMjZhcHBcdTAwM2Q1NjMwODc0MmEyOTBhYTUwMDZmMmIwZDZcdTAwMjZwbGF0XHUwMDNkanNcdTAwMjZtaW1lVHlwZVx1MDAzZCQobWltZVR5cGUpXHUwMDI2c2l6ZVx1MDAzZCQoZnNpemUpXHUwMDI2ZHVyYXRpb25cdTAwM2QkKGF2aW5mby5mb3JtYXQuZHVyYXRpb24pXHUwMDI2YXZpbmZvXHUwMDNkJChhdmluZm8pXHUwMDI2cGVyc2lzdGVudElkXHUwMDNkJChwZXJzaXN0ZW50SWQpIn0="
    },
    "message":""
}
```

###<span id="FileCallback">文件上传后的回调</span>
这个接口是提供给七牛处理完文件上传后回调的。
###<span id="NotifyQiniu">七牛的异步操作通知</span>
这个接口是提供给七牛异步操作异步处理文件后通知JavaBaas的。
###<span id="ProcessFile">文件处理</span>
该接口实现为七牛处理文件时添加一些上传策略。例如，我们要对某个视频文件做 `M3U8` 分割：

```
curl -X POST \
  -H "JB-Timestamp:1459137092965" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-MasterSign:a869a91a43496ae3a16d8e9b07cf8b69" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
	http://127.0.0.1:8080/api/file/master/process?fileId=481&a91a43496ae3a16d8e9457cf8n90&platform=qiniu
```

##云代码和钩子
JavaBaas 提供的接口能解决大部分简单的业务需求，但是对于一些复杂一些或者有关联性的需求，比如，当我们删除一个用户，希望把该用户的相关数据给清除，例如该用户发的作品，该用户发的评论等信息；再比如，当我们执行一个操作，对一个音频点赞或者取消点赞操作，这个操作需要判断当前用户是否已经对该音频点过赞，并且如果点赞或者取消点赞成后需要对音频的点赞数做响应的修改。这些需求如果都在客户端处理，会导致客户端相关逻辑异常复杂。对于这些需求的处理，JavaBaas提供了云方法和钩子的接口。

###<span id="DeployCloud">部署云代码(含钩子)相关配置</span>
你可以通过下面的请求部署云代码(含钩子)：

```
curl -X POST \
  -H "JB-Timestamp:1459829784178" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-MasterSign:8a1afca2fbd8ef89e52211cbcf799812" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -d '{"cloudFunctions":["cloudMethod1","cloudMethod2"],"hookSettings":{"Sound":{"afterInsert":true,"afterDelete":true}}}' \
	http://127.0.0.1:8080/api/master/cloud
```

###<span id="UnDeployCloud">删除云代码(含钩子)相关配置</span>
如果云方法或者钩子不再使用，可以通过下面的请求删除（需要注意的是，这里的删除会删除所有的云方法和钩子的配置）：

```
curl -X DELETE \
  -H "JB-Timestamp:1459829784178" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-MasterSign:8a1afca2fbd8ef89e52211cbcf799812" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \ 
	http://127.0.0.1:8080/api/master/cloud
```

###<span id="RequestCloud">调用云方法</span>
我们可以通过下面的请求调用我们配置好的云方法：

```
curl -X GET \
  -H "JB-Timestamp:1459829784178" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-MasterSign:8a1afca2fbd8ef89e52211cbcf799812" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \ 
	http://127.0.0.1:8080/api/cloud/cloudMethod1
```
##设备
JavaBaas提供了接口，供注册和记录设备，从而用于消息推送活着其他用途。
###<span id="RegDevice">注册设备</span>
下面的请求可以注册设备信息：

```
curl -X POST \
  -H "JB-Timestamp:1459137092965" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-Sign:a869a91a43496ae3a16d8e9b07cf8b69" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \
  -d '{"deviceType":"ios","deviceToken":"72383872abb322122ba7788999b8839"}' \
	http://127.0.0.1:8080/api/installation
```

##推送
目前，JavaBaas没有推送系统，使用的是第三方消息推送系统。

###<span id="PushInfo">推送消息</span>
通过下面请求，我们可以发送消息推送：

```
curl -X POST \
  -H "JB-Timestamp:1459829784178" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-MasterSign:8a1afca2fbd8ef89e52211cbcf799812" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \ 
  -d '{"type":4,"objectId":"62873a95570c429aaadb971e0d2dea25"}' \
	http://127.0.0.1:8080/api/matser/push?where={"_id":"78392a67429c234loih635e0d2kld45"}
```

>这里需要注意的是，如果 where 没有参数值，JavaBaas 会给所有设备进行推送。

###<span id="SetPushAccount">设置推送账号信息</span>
可以通过下面的请求设置第三方推送的账号信息：

```
curl -X PUT \
  -H "JB-Timestamp:1459829784178" \
  -H "JB-AppId:56cd5194c6db7c372fd1563f" \
  -H "JB-MasterSign:8a1afca2fbd8ef89e52211cbcf799812" \
  -H "JB-Plat:js" \
  -H "Content-Type: application/json" \ 
  -d '{"key":"ahsfh392223jjk49034kjh98","secret":"kskhhhj987663902"}' \
	http://127.0.0.1:8080/api/matser/push/setPushAccount
```
