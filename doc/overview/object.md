#数据存储
数据存储作为JavaBaas的最核心功能，实现了结构化数据的存储，并提供API以及客户端SDK供用户调用。在不编写后台代码的情况下，实现移动客户端产品（或富客户端网页）的开发运行。

##对象存储
JavaBaas使用MongoDB作为数据存储数据库。虽然MongoDB为无模式数据库，但是使用JavaBaas存储数据时，我们需要先设计类及字段，且每个字段都有其指定的数据类型（字符型、数值型等），存储数据时必须遵从其数据类型。

###对象
对象是JavaBaas中最基本的数据存储单元。所有的对象必须为某一个类的实例。

###类
在JavaBaas中，数据使用类进行组织。用户可以自己创建类，类名需使用英文字母开头且名称中只能包含数字与英文字母。同时、系统初始化后会自动创建用户类、设备类、文件类等系统内建类，内建类名使用下划线_开头，系统内建类禁止删除或修改。

####系统内建类
|名称|描述
|--- | ---
|_User|用户
|_Installation|设备
|_File|文件

###字段
在类中创建字段以存储数据。字段的名称必须使用英文字母开头且名称中只能包含数字与英文字母。每个字段在创建时，必须选择一个取值类型，值的类型可以是字符串、数字、日期等类型（参见`数据类型`），字段类型一旦设置无法更改。每个类在创建后，系统会自动创建`id` `createdAt` `updatedAt` `acl`四个内建字段，系统内建字段禁止删除。
####系统内建字段

名称|描述
--- | ---
id|唯一标识
createdAt|创建时间
updatedAt|更新时间
acl|权限


<span id="fieldType"/>
####数据类型

名称|编号|描述
--- | --- | ----
String |1 | 字符串
Number |2 | 数字
Boolean |3 | 布尔类型
Date |4 | 日期
File |5 | 文件
Object |6 | 对象
Array |7 | 数组
Pointer|8 | 指针
GeoPointer |9 | 地理坐标

###数据关联
JavaBaas中，使用Pointer类型字段建立对象之间的关联。

##文件存储
文件存储用以存储类似图片、音频、视频等物理文件。`JavaBaas`的文件存储使用七牛云存储实现。

###直接使用url创建文件
当文件已经存在于互联网可以访问的服务器中，且已经获得到一个公网可以访问的url时，可以使用已有的url直接创建文件对象（此时将只记录文件的url地址，而不会为文件创建拷贝）。
如，现在有地址为 https://www.baidu.com/img/baidu_jgylogo1.gif 的图片，为它创建文件对象。

```bash
curl --request POST \
  --url http://127.0.0.1:8080/file \
  --header 'content-type: application/json' \
  --header 'JB-AppId: 56026b5f25ac90b6c1bdb7f2' \
  --header 'JB-Sign: e79208bee1819873bb7e58ba44bc9a4c' \
  --header 'JB-Timestamp: 1443002520836' \
  --data '{"url":"https://www.baidu.com/img/baidu_jgylogo1.gif"}'
```
其中`JB-AppId`为应用id、`JB-Sign`为签名、`JB-Timestamp`为时间戳，请自行修改。

上传成功后，将返回新创建的文件对象id。

```
{
  "code": 0,
  "data": {
    "id": "560278db25ac60143281619a"
  },
  "message": ""
}
```

###使用七牛SDK存储文件
