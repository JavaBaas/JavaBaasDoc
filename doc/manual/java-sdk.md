# Java SDK
## SDK安装
### 获取SDK
获取 SDK 有多种方式，较为推荐的方式是通过包依赖管理工具下载最新版本。
#### 包依赖管理工具安装
通过maven配置相关依赖

```
<dependencies>
	<dependency>
		<groupId>com.javabaas</groupId>
		<artifactId>javasdk</artifactId>
		<version>1.0.1</version>
	</dependency>
</dependencies>
```

或者通过 gradle 配置相关依赖

```
dependencies {
	compile("com.javabaas:javasdk:1.0.1")
}
```

#### 手动安装
[Java_SDK 源码（gitee）](https://gitee.com/javabaas/JavaBaas_SDK_Java.git)
[Java_SDK 源码（github）](https://github.com/JavaBaas/JavaBaas_SDK_Java.git)

## 初始化
JavaSDK提供三种权限的初始化方法，使用者可以根据实际情况使用相应的JavaSDK初始化方法：
### 初始化 admin 权限
在 `main` 函数中间调用 `JBConfig.initAdmin` 来设置你的 admin 超级权限初始化的信息：

``` java
  public static void main(String[] args) {
	// 参数依次为 请求地址（"例如："http://127.0.0.1:8080/api"）、adminKey("JavaBaas")
    JBConfig.initAdmin("http://127.0.0.1:8080/api", "JavaBaas")
  }
```

### 初始化 master 权限
在 `main` 函数中间调用 `JBConfig.initAdmin` 来设置你的 master 管理权限初始化的信息：

``` java
  public static void main(String[] args) {
	// 参数依次为 请求地址（例如：http://127.0.0.1:8080/api）、appId("594895b0b55198292ae266f1")、masterKey("cebde78a2d2d48c9870cf4887cbb3eb1")
    JBConfig.initMaster("http://127.0.0.1:8080/api", "594895b0b55198292ae266f1","cebde78a2d2d48c9870cf4887cbb3eb1")
  }
```

### 初始化 应用普通 权限
在 `main` 函数中间调用 `JBConfig.init` 来设置你的应用普通权限初始化的信息：

``` java
  public static void main(String[] args) {
	// 参数依次为 请求地址（例如：http://127.0.0.1:8080/api）、appId("594895b0b55198292ae266f1")、key("a8c18441d7ab4dcd9ed78477015ab8b2")
    JBConfig.init("http://127.0.0.1:8080/api", "594895b0b55198292ae266f1","a8c18441d7ab4dcd9ed78477015ab8b2")
  }
```

## 对象列表
JavaSDK目前提供了包括`JBApp`、`JBClazz`、`JBField`、`JBObject`、`JBUser`、`JBQuery`、`JBFile`等主要对象（除了这些主要的对象外，JavaSDK中还有一些内部类、工具类等，不再详细介绍）。

对象|描述
--- | ---
JBApp | [应用对象](java-sdk.md#JBApp-应用)
JBClazz | [表对象，通常一个JBClazz对应一个mongoDB中的Collection](java-sdk.md#JBClazz-表)
JBField | 字段对象，对应mongoDB中的文档的key
JBObject | 文档对象
JBUser | 用户
JBQuery | 查询对象
JBFile | 文件对象

## JBApp-应用

`JBApp`主要是处理在 admin 超级权限或者当前应用的 master 管理权限下对应用的管理。

>`JBApp`的一些重要的属性如下：

属性名|描述
------------ | ------------
id | 应用id 既 appId
name | 应用名称
key | 本应用普通权限的key
masterKey | 本应用的管理权限key
cloudSetting | 本应用相关的云方法和钩子设置

>`JBApp`提供的一些主要的方法为：

序号| 方法 | 方法说明
--- | --- | ---
1| save() | [创建或更新应用信息（同步）](java-sdk.md#创建或更新应用信息)
2| saveInBackground(JBSaveCallback callback) | [创建或更新应用信息（异步）](java-sdk.md#创建或更新应用信息)
3| delete() | [删除应用（同步）](java-sdk.md#删除应用)
4| deleteInBackground（JBDeleteCallback callback）|  [删除应用（异步）](java-sdk.md#删除应用)
5| get(String appId) | [获取应用信息（同步）](java-sdk.md#获取应用信息)
6| getInBackground(String appId, JBGetAppCallback callback) | [获取应用信息（异步）](java-sdk.md#获取应用信息)
7| resetKey(int type) | [更新应用key或masterKey值（同步）](java-sdk.md#更新应用key或masterKey值)
8| resetKeyInBackground(int type, JBUpdateCallback callback) | [更新应用key或masterKey值（异步）](java-sdk.md#更新应用key或masterKey值)
9| list() | [获取应用列表（同步）](java-sdk.md#获取应用列表)
10| listInBackground(JBAppListCallback callback) | [获取应用列表（异步）](java-sdk.md#获取应用列表)
11| export(String appId) | [导出应用信息（同步）](java-sdk.md#导出应用信息)
12| exportInBackground(String appId, JBAppExportCallback callback) | [导出应用信息（异步）](java-sdk.md#导出应用信息)
13| importData(String data) | [导入应用信息（同步）](java-sdk.md#导入应用信息)
14| importDataInBackground(String data, JBImportCallback callback) | [导入应用信息（异步）](java-sdk.md#导入应用信息)
15| getApiStat(JBApiStat apiStat) | [获取应用api调用统计（同步）](java-sdk.md#获取应用api调用统计)
16| getApiStatInBackground(JBApiStat apiStat, JBApiStatListCallback callback) | [获取应用api调用统计（异步）](java-sdk.md#获取应用api调用统计)
17| updateAppConfig(JBAppConfig config) | [更新应用设置（同步）](java-sdk.md#更新应用设置)
18| updateAppConfigInBackground(JBAppConfig config, JBUpdateCallback callback) | [更新应用设置（异步）](java-sdk.md#更新应用设置)
19| getAppConfig(JBAppConfigKey appConfigKey) | [查看应用config信息（同步）](java-sdk.md#)
20| getAppConfigInBackground(JBAppConfigKey appConfigKey, JBGetConfigCallback callback) | [查看应用config信息（异步）](java-sdk.md#)

### 创建或更新应用信息
使用者可以在设置了`admin`超级权限后可以通过调用创建或更新应用信息方法创建或者更新应用：

``` java
try {
	JBApp app = new JBApp();
	app.setName("应用名称");
	app.save();
	System.out.println("创建应用成果");
} catch (JBException e) {
	System.out.println(e.getMessage());
}
```

### 删除应用
使用者拥有了`admin`超级权限后可以通过调用删除应用方法删除应用：

``` java
JBApp app = new JBApp();
app.setId("appId");
app.deleteInBackground(new JBDeleteCallback() {
	@Override
	public void done(boolean success, JBException e) {
		if (success) {
			System.out.println("应用删除成功");
		} else {
			System.out.println(e.getMessage());
		}
	}
});
```

### 获取应用信息
使用者拥有了`admin`超级权限后可以通过调用获取应用信息的方法获取应用信息

``` java
try {
	JBApp app = JBApp.get("appId");
	System.out.println(app);
} catch (JBException e) {
	System.out.println(e.getMessage());
}
```

### 更新应用key或masterKey值
使用者拥有了`admin`超级权限后可以更新应用`key`或`masterKey`值，需要注意的是，一旦更新了应用`key`或`masterKey`值，之前的`key`或`masterKey`立即不能使用，可能会影响之前已经上线的应用的请求。

``` java
app.resetKeyInBackground(1, new JBUpdateCallback() {
	@Override
	public void done(boolean success, JBException e) {
		if (success) {
			System.out.println("更改应用key成功");
		} else {
			System.out.println(e.getMessage());
		}
	}
});
```

### 获取应用列表
使用者拥有了`admin`超级权限后可以获取应用列表，查看所有应用信息

``` java
try {
	List<JBApp> list = JBApp.list();
	list.forEach(app -> System.out.println(app.getId() + " : " + app.getName()));
} catch (JBException e) {
	System.out.println(e.getMessage());
}
```

结果如下：

```
59dc970bce69f81448a2a119 : NewApp
59f0173012a0aa06cb853985 : TestApp
```

### 导出应用信息
使用者拥有了`admin`超级权限后可以使用应用信息导出方法备份应用的结构信息，需要注意的是导出的时候结构信息，不含表中数据。

``` java
JBApp app = new JBApp();
app.setId("59dc970bce69f81448a2a119");
JBApp.exportInBackground("59dc970bce69f81448a2a119", new JBAppExportCallback() {
	@Override
	public void done(boolean success, JBApp.JBAppExport appExport, JBException e) {
		if (success) {
			System.out.println(appExport);
		}
	}
});
```

结果如下：

```
{
    "id":"59dc970bce69f81448a2a119",
    "name":"NewApp",
    "key":"cde5b8c5e097436aafe6377e33eeb003",
    "masterKey":"c57cd396c2034ef6a6ae1c74b7596730",
    "clazzs":[
        Object{...},
        Object{...},
        Object{...},
        Object{...},
        Object{...},
        {
            "id":"59dc9869ce69f81448a2a13e",
            "name":"Test",
            "acl":{
                "*":{
                    "find":true,
                    "get":true,
                    "insert":true,
                    "update":true,
                    "delete":true
                }
            },
            "internal":false,
            "fields":[
                {
                    "id":"59dc9869ce69f81448a2a13f",
                    "name":"count",
                    "type":2,
                    "internal":false,
                    "security":false,
                    "required":false
                },
                {
                    "id":"59e970a212a0aa7f91bb0487",
                    "name":"name",
                    "type":1,
                    "internal":false,
                    "security":false,
                    "required":false
                },
                Object{...}
            ]
        }
    ]
}
```

### 导入应用信息
使用者拥有了`admin`超级权限后可以使用导入应用信息回复应用结构信息， 需要注意的是导入的只是应用结构信息，包括应用信息、表信息、字段信息等，不含表中文档内容。

``` java
try {
	String data = "{\"id\":\"59dc970bce69f81448a2a119\",\"name\":\"NewApp\",\"key\":\"cde5b8c5e097436aafe6377e33eeb003\",\"masterKey\":\"c57cd396c2034ef6a6ae1c74b7596730\",\"clazzs\":[{\"id\":\"59dc9869ce69f81448a2a13e\",\"name\":\"Test\",\"acl\":{\"*\":{\"find\":true,\"get\":true,\"insert\":true,\"update\":true,\"delete\":true}},\"internal\":false,\"fields\":[{\"id\":\"59dc9869ce69f81448a2a13f\",\"name\":\"count\",\"type\":2,\"internal\":false,\"security\":false,\"required\":false},{\"id\":\"59e970a212a0aa7f91bb0487\",\"name\":\"name\",\"type\":1,\"internal\":false,\"security\":false,\"required\":false}]}]}";
	JBApp.importData(data);
	System.out.println("导入应用成功");
} catch (JBException e) {
	System.out.println(e.getMessage());
}
```

### 获取应用api调用统计
使用者拥有了当前应用的`master`管理权限后，使用该方法可以获取当前应用api的调用统计，下面的查询是查询昨天和今天两天，来之`web端`（plat为js）的有关`_User` 的 `insert` 操作请求的统计：

``` java
JBApp app = new JBApp();
app.setId("59dc970bce69f81448a2a119");
SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd");
Calendar calendar = new GregorianCalendar();
// 今天 例如20171106
Date to = calendar.getTime();
calendar.add(Calendar.DAY_OF_YEAR, -1);
// 昨天 例如20171105
Date from = calendar.getTime();
String fromString = simpleDateFormat.format(from);
String toString = simpleDateFormat.format(to);
JBApp.JBApiStat apiStat = new JBApp.JBApiStat("js", "_User", JBApp.JBApiMethod.INSERT, fromString, toString);
app.getApiStatInBackground(apiStat, new JBApiStatListCallback() {
	@Override
	public void done(boolean success, List<Long> list, JBException e) {
		if (success) {
			System.out.println(list);
		}
	}
});
```

### 更新应用设置
使用者拥有了当前应用的`master`管理权限后，使用该方法可以对当前应用的config信息进行修改：

``` java
try {
	JBApp.JBAppConfig config = new JBApp.JBAppConfig();
	config.setAppConfigKey(JBApp.JBAppConfigKey.PUSH_HANDLER_JPUSH_KEY);
	config.setValue("jpushKey");
	JBApp.updateAppConfig(config);
	System.out.println("设置成功");
} catch (JBException e) {
	System.out.println(e.getMessage());
}
```

### 查看应用config信息
使用者拥有了当前应用的`master`管理权限后，使用该方法可以查看当前应用的一些config信息：

``` java
try {
	String value = JBApp.getAppConfig(JBApp.JBAppConfigKey.PUSH_HANDLER_JPUSH_KEY);
	System.out.println(value);
} catch (JBException e) {
	System.out.println(e.getMessage());
}
```

## JBClazz-表
`JBClazz`主要处理在当前应用的`master`权限下，和表有关的操作。

>`JBClazz`的一些重要的属性如下：

属性名|描述
------------ | ------------
id | 表id
app | 应用信息
name | 表名称
acl | 表级权限
internal | 是否是内部类
count | 当前表中文档数据量

>`JBClazz`提供的一些主要的方法为：

序号| 方法 | 方法说明
--- | --- | ---
1 | save() | [创建或更新表信息（同步）](java-sdk.md#创建或更新表信息)
2 | saveInBackdround(JBSaveCallback callback) | [创建或更新表信息（异步）](java-sdk.md#创建或更新表信息)
3 | delete() | [删除表信息（同步）](java-sdk.md#删除表信息)
4 | deleteInBackground(JBDeleteCallback callback) | [删除表信息（异步）](java-sdk.md#删除表信息)
5 | get(String name) | [获取表信息（同步）](java-sdk.md#获取表信息)
6 | getInBackground(String name, JBGetClazzCallback callback) | [获取表信息（异步）](java-sdk.md#获取表信息)
7 | updateClazzAcl() | [更新表级acl（同步）](java-sdk.md#更新表级acl)
8 | updateClazzAclInBackground(JBUpdateCallback callback) | [更新表级acl（异步）](java-sdk.md#更新表级acl)
9 | list() | [获取表列表信息（同步）](java-sdk.md#获取表列表信息)
10 | listInBackground(JBClazzListCallback callback) | [获取表列表信息（异步）](java-sdk.md#获取表列表信息)
11 | export(String className) | [导出表结构信息（同步）](java-sdk.md#导出表结构信息)
12 | exportInBackground(String className, JBClazzExportCallback callback) | [导出表结构信息（异步）](java-sdk.md#导出表结构信息)
13 | importData(String data) | [导入表结构信息（同步）](java-sdk.md#导入表结构信息)
14 | importDataInBackground(String data, JBImportCallback callback) | [导入表结构信息（异步）](java-sdk.md#导入表结构信息)

### 创建或更新表信息
使用者拥有了当前应用的`master`管理权限后，可以创建或更新表信息。

``` java
try {
	JBClazz clazz = new JBClazz("Sound");
	// 创建clazz的时候可以通过设置JBClazzAcl加强对clazz的控制，如果不设置，默认clazz的所有acl为public true
	JBClazz.JBClazzAcl acl = new JBClazz.JBClazzAcl();
	acl.setAccess(JBClazz.ClazzAclMethod.DELETE, "userId", true);
	acl.setPublicAccess(JBClazz.ClazzAclMethod.FIND, true);
	acl.setPublicAccess(JBClazz.ClazzAclMethod.GET, true);
	clazz.setAcl(acl);
	clazz.save();
} catch (JBException e) {
	System.out.println(e.getMessage());
}
```

我们在mongo中可以查看到新建的clazz数据：

```json
{
    "_id" : ObjectId("5a015ad3fa0a5737c68c1c9d"),
    "_class" : "com.javabaas.server.admin.entity.Clazz",
    "name" : "Sound",
    "acl" : {
        "userId" : {
            "delete" : true
        },
        "*" : {
            "find" : true,
            "get" : true
        }
    },
    "internal" : false,
    "count" : NumberLong(0),
    "app" : {
        "$ref" : "app",
        "$id" : ObjectId("594895b0b55198292ae266f1")
    }
}
```

### 删除表信息
使用者拥有了当前应用的`master`管理权限后，可以删除表信息。

``` java
JBClazz clazz = new JBClazz("Sound");
clazz.deleteInBackground(new JBDeleteCallback() {
	@Override
	public void done(boolean success, JBException e) {
		// code
	}
});
```

### 获取表信息
使用者拥有了当前应用的`master`管理权限后，可以根据表名称获取表结构信息。

``` java
JBClazz.getInBackground("Sound", new JBGetClazzCallback() {
	@Override
	public void done(boolean success, JBClazz clazz, JBException e) {
		// code
	}
});
```
### 更新表级acl
使用者拥有了当前应用的`master`管理权限后，可以更新表级acl。表级acl包括对表的`insert`新增文档，`update`修改文档，`get`获取单个文档信息，`find`查询表文档，`delete`删除文档等，如果没有单独设置表级acl，则表级acl所有权限均为public true。而如果五个权限中只设置了其中的一些，则未设置的权限为public false。另外，每次更新标记acl，新的acl会替换旧的acl，而不是对旧的acl进行补充设置（类似于求并集），所以比如，即使你只是想改变`insert`的权限，而不想改变之前其他四种权限的设置，你也需要在更新时候对其他权限进行重新设置。

``` java
JBClazz clazz = new JBClazz("Sound");
JBClazz.JBClazzAcl acl = new JBClazz.JBClazzAcl();
acl.setPublicAccess(JBClazz.ClazzAclMethod.INSERT, false);
acl.setPublicAccess(JBClazz.ClazzAclMethod.UPDATE, true);
acl.setPublicAccess(JBClazz.ClazzAclMethod.GET, true);
acl.setPublicAccess(JBClazz.ClazzAclMethod.FIND, true);
acl.setPublicAccess(JBClazz.ClazzAclMethod.DELETE, true);
clazz.setAcl(acl);
clazz.updateClazzAclInBackground(new JBUpdateCallback() {
	@Override
	public void done(boolean success, JBException e) {
		// code
	}
});
```

### 获取表列表信息
使用者拥有了当前应用的`master`管理权限后，可以查询全部表的列表信息。

```java
JBClazz.listInBackground(new JBClazzListCallback() {
	@Override
	public void done(boolean success, List<JBClazz> list, JBException e) {
		// code
	}
});
```

### 导出表结构信息
使用者拥有了当前应用的`master`管理权限后，可以导出表结构信息，需要注意的是只是导出表结构信息，不含表中文档内容。

```java
try {
	JBClazz.JBClazzExport export = JBClazz.export("Sound");
	// JBUtils.writeValueAsString是JavaSDK提供的工具类的方法
	System.out.println(JBUtils.writeValueAsString(export));
} catch (JBException e) {
	System.out.println(e.getMessage());
}
```

导出结果为：

```json
{
    "id":"5a015ad3fa0a5737c68c1c9d",
    "name":"Sound",
    "acl":{
        "userId":{
            "delete":true
        },
        "*":{
            "find":true,
            "get":true
        }
    },
    "internal":false,
    "fields":[
        {
            "id":"5a016241fa0a5737c68c1c9e",
            "name":"title",
            "type":1,
            "internal":false,
            "security":false,
            "required":false
        }
    ]
}
```

### 导入表结构信息
使用者拥有了当前应用的`master`管理权限后，可以导入表结构信息，需要注意的是只是导入表结构信息，不含表中文档内容。

```java
String data = "{\"id\":\"5a015ad3fa0a5737c68c1c9d\",\"name\":\"Sound\",\"acl\":{\"userId\":{\"delete\":true},\"*\":{\"find\":true,\"get\":true}},\"internal\":false,\"fields\":[{\"id\":\"5a016241fa0a5737c68c1c9e\",\"name\":\"title\",\"type\":1,\"internal\":false,\"security\":false,\"required\":false}]}";
JBClazz.importDataInBackground(data, new JBImportCallback() {
	@Override
	public void done(boolean success, JBException e) {
		//code
	}
});
```


## JBField-字段
`JBField`主要处理在当前应用的 master权限下，和字段有关的操作。

>`JBField`的一些重要的属性如下：

属性名|描述
------------ | ------------
id | 表id
clazz | 表信息
name | 字段名称
type | 字段类型（详见 [字段类型说明](java-sdk.md#字段类型说明)）
internal | 是否是内建字段，内建字段不能进行删除字段操作
security | 是否是安全字段，安全字段必须需要 master 管理权限才可以修改
required | 是否是必填字段

>`JBField`提供的一些主要的方法为：

序号| 方法 | 方法说明
--- | --- | ---
1 | save() | [创建或更新字段信息（同步）](java-sdk.md#创建或更新字段信息)
2 | saveInBackground(JBSaveCallback callback) | [创建或更新字段信息（异步）](java-sdk.md#创建或更新字段信息)
3 | delete() | [删除字段信息（同步）](java-sdk.md#删除字段信息)
4 | deleteInBackground(JBDeleteCallback callback) | [删除字段信息（异步）](java-sdk.md#删除字段信息)
5 | update() | [更新字段信息（同步）](java-sdk.md#更新字段信息)
6 | updateInBackground(JBUpdateCallback callback) | [更新字段信息（异步）](java-sdk.md#更新字段信息)
7 | get(String className, String fieldName) | [获取字段信息（同步）](java-sdk.md#获取字段信息)
8 | getInBackground(String className, String fieldName, JBGetFieldCallback callback) | [获取字段信息（异步）](java-sdk.md#获取字段信息)
9 | list(String className) | [获取字段列表信息（同步）](java-sdk.md#获取字段列表信息)
10 | listInBackground(String className, JBFieldListCallback callback) | [获取字段列表信息（异步）](java-sdk.md#获取字段列表信息)

### 创建或更新字段信息
使用者拥有了当前应用的`master`管理权限后，可以创建或者更新字段信息，JavaSDK 目前提供N种字段类型：

序号| 字段类型 | 说明
--- | --- | ---
1 | String | 字符串
2 | Number | 数字
3 | Boolean | 布尔型
4 | Date | 日期
5 | File | 文件
6 | Object | 对象
7 | Array | 数组
8 | Pointer | 指针

```java
try {
	// type 为字段类型的序号
	JBField field = new JBField(1, "title");
	field.setClazz(new JBClazz("Sound"));
	// 是否必填，默认为false
	field.setRequired(true);
	// 是否内建，默认为false
	field.setInternal(true);
	// 是否为安全字段，安全字段信息在获取数据时不会带出，默认为false
	field.setSecurity(true);
	field.save();
} catch (JBException e) {
	System.out.println(e.getMessage());
}
```

### 删除字段信息
使用者拥有了当前应用的`master`管理权限后，可以删除字段信息，需要注意的是，因为mongo本身没有字段概念，只有key，本方法只是删除了javabaas中的字段的定义，不会删除文档中相关的key和对应的value，但是在用户查询过程中，该key和对应的value不在对用户展示。

```java
try {
	JBField field  = new JBField();
	field.setName("Sound");
	field.delete();
} catch (JBException e) {
	System.out.println(e.getMessage());
}
```

### 更新字段信息
使用者拥有了当前应用的`master`管理权限后，可以对字段信息进行更新，目前更新字段信息只限于更新字段的`security`，`required`属性。

```java
try {
	JBField field  = new JBField();
	field.setName("Sound");
	field.setSecurity(false);
	field.update();
} catch (JBException e) {
	System.out.println(e.getMessage());
}
```

### 获取字段信息
使用者拥有了当前应用的`master`管理权限后，可以查询字段信息。

```java
try {
	// 两个参数分别为表名和字段名
	JBField field  = JBField.get("Sound", "title");
} catch (JBException e) {
	System.out.println(e.getMessage());
}
```

### 获取字段列表信息
使用者拥有了当前应用的`master`管理权限后，可以查看某个表中所有字段信息。

```java
JBField.listInBackground("Sound", new JBFieldListCallback() {
	@Override
	public void done(boolean success, List<JBField> list, JBException e) {
		// code
	}
});
```

## JBObject-文档
`JBObject`是对`JavaBaas`对复杂对象的封装，通常一个`JBObject`对应一条文档数据。

>`JBObject `的一些主要的属性如下：

属性名|描述
--- | ---
objectId | 文档id
className | 文档对应的表名
createdAt | 文档创建时间
updatedAt | 文档更新时间
acl | 文档级acl
serverData | 文档非内建字段数据
query | JBQuery，查询条件，在findAndModify操作时候会用到
fetchWhenSave | 保存成功后是否更新数据
operationQueue | 所有字段待操作队列

>`JBObject `提供的一些主要的方法为：

序号| 方法 | 方法说明
--- | --- | ---
1 | save() | [创建或者更新文档信息（同步)](java-sdk.md#创建或者更新文档信息)
2 | saveInBackground(JBSaveCallback callback) | [创建或者更新文档信息（异步）](java-sdk.md#创建或者更新文档信息)
3 | delete() | [删除文档信息（同步)](java-sdk.md#删除文档信息)
4 | deleteInBackground(JBDeleteCallback callback) | [删除文档信息（异步）](java-sdk.md#删除文档信息)

### 创建或者更新文档信息
### 删除文档信息

## JBUser-用户
`JBUser`是`JBObject`子类，主要处理和用户有关的操作。

>`JBUser`的一些主要的属性如下(除了父类`JBObject`属性外)：

属性名|描述
--- | ---
sessionToken | 用户身份鉴权
username | 用户名
email | 邮箱
password | 密码
phone | 电话
auth | 第三方登录信息

>`JBUser `提供的一些主要的方法为：

序号| 方法 | 方法说明
--- | --- | ---
1 | signUp() | [用户名密码注册（同步)](java-sdk.md#用户名密码注册)
2 | signUpInBackground(JBSignUpCallback callback) | [用户名密码注册（异步）](java-sdk.md#用户名密码注册)
3 | getSmsCode(String phone) | [获取短信验证码（同步)](java-sdk.md#获取短信验证码)
4 | getSmsCodeInBackground(String phone, JBGetSmsCodeCallback callback) | [获取短信验证码（异步）](java-sdk.md#获取短信验证码)
5 | signUpWithSns(JBAuth auth, JBSnsType type) | [第三方社交平台注册（同步)](java-sdk.md#第三方社交平台注册)
6 | signUpWithSnsInBackground(JBAuth auth, JBSnsType type, JBSignUpCallback callback) | [第三方登录注册（异步）](java-sdk.md#第三方社交平台注册)
7 | login(String username, String password) | [用户名密码登录（同步)](java-sdk.md#用户名密码登录)
8 | loginInBackground(String username, String password, JBLoginCallback callback) | [用户名密码登录（异步）](java-sdk.md#用户名密码登录)
9 | loginWithPhone(String phone, String code) | [手机号验证码登录（同步)](java-sdk.md#手机号验证码登录)
10 | loginWithPhoneInBackground(String phone, String code, JBLoginCallback callback) | [手机号验证码登录（异步）](java-sdk.md#手机号验证码登录)
11 | loginWithSns(JBAuth auth, JBSnsType type) | [第三方社交平台登录（同步)](java-sdk.md#第三方社交平台登录)
12 | loginWithSnsInBackground(JBAuth auth, JBSnsType type, JBLoginCallback callback) | [第三方社交平台登录（异步）](java-sdk.md#第三方社交平台登录)
13 | updatePassword(String oldPassword, String newPassword) | [修改登录密码（同步)](java-sdk.md#修改登录密码)
14 | updatePasswordInBackground(String oldPassword, String newPassword, JBUpdatePasswordCallback callback) | [修改登录密码（异步）](java-sdk.md#修改登录密码)
15 | update() | [更新用户信息（同步)](java-sdk.md#更新用户信息)
16 | updateInBackground(JBUpdateCallback callback) | [更新用户信息（异步）](java-sdk.md#更新用户信息)
17 | resetSessionToken(String userId) | [重置用户sessionToken（同步)](java-sdk.md#重置用户sessionToken)

### 用户名密码注册
### 获取短信验证码
### 第三方社交平台注册
### 用户名密码登录
### 手机号验证码登录
### 第三方社交平台登录
### 修改登录密码
### 更新用户信息
### 重置用户sessionToken

## JBQuery-查询
`JBQuery`主要处理和查询有关的操作。

>`JBQuery`的一些主要的属性如下：

属性名|描述
--- | ---
className | 类名
whereSting | 查询语句(json串)
isRunning | 是否正在查询
conditions | 查询条件

>`JBUser `提供的一些主要的方法为：

序号| 方法 | 方法说明
--- | --- | ---
1 | get(String objectId) | [根据objectId获取对象（同步)](java-sdk.md#根据objectId获取对象)
2 | getInBackground(String objectId, JBGetCallback<T> callback) | [根据objectId获取对象（异步）](java-sdk.md#根据objectId获取对象)
3 | find() | [数据查询（同步)](java-sdk.md#数据查询)
4 | findInBackground(JBFindCallBack<T> callBack) | [数据查询（异步）](java-sdk.md#数据查询)
5 | count() | [简单统计查询（同步)](java-sdk.md#简单统计查询)
6 | countInBackground(JBCountCallback callback) | [简单统计查询（异步）](java-sdk.md#简单统计查询)
7 | deleteByQuery() | [批量删除（同步)](java-sdk.md#批量删除)
8 | deleteByQueryInBackground(JBDeleteCallback callback) | [批量删除（异步）](java-sdk.md#批量删除)

### 根据objectId获取对象
### 数据查询
### 简单统计查询
### 批量删除

## JBFile-文件

