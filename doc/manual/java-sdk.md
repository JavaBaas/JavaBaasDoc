# Java SDK
## SDK安装
### 获取SDK
获取 SDK 有多种方式，较为推荐的方式是通过包依赖管理工具下载最新版本。
#### 包依赖管理工具安装
通过maven配置相关依赖

```xml
  <dependencies>
    <dependency>
      <groupId>com.javabaas</groupId>
	  <artifactId>javasdk</artifactId>
	  <version>1.0.1</version>
    </dependency>
  </dependencies>
```

或者通过 gradle 配置相关依赖

```groovy
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

### 初始化 master 权限
在 `main` 函数中间调用 `JBConfig.init` 来设置你的 user 普通  权限初始化的信息：

``` java
  public static void main(String[] args) {
	// 参数依次为 请求地址（例如：http://127.0.0.1:8080/api）、appId("594895b0b55198292ae266f1")、key("a8c18441d7ab4dcd9ed78477015ab8b2")
    JBConfig.init("http://127.0.0.1:8080/api", "594895b0b55198292ae266f1","a8c18441d7ab4dcd9ed78477015ab8b2")
  }
```

## 对象
JavaSDK目前提供了包括` JBApp`、`JBClass`、`JBField`、`JBObject`、`JBUser`、`JBQuery`、`JBFile`等对象。

### JBApp
`JBApp`主要是处理在 admin 超级权限下对应用的管理。

>`JBApp`的一些重要的属性如下：

属性名|描述
------------ | ------------
id | 应用id 既 appId
name | 应用名称
key | 本应用普通权限的key
masterKey | 本应用的管理权限key
cloudSetting | 本应用相关的云方法和钩子设置

>`JBApp`提供的一些主要的方法为：

序号 | 方法 | 方法说明
--- | --- | ---
1 | save() | [创建或更新应用信息（同步）](java-sdk.md#创建或更新应用信息)
2 | saveInBackground(JBSaveCallback callback) | [创建或更新应用信息（异步）](java-sdk.md#)
3 | delete() | [删除应用（同步）](java-sdk.md#)
4 | deleteInBackground（JBDeleteCallback callback）|  [删除应用（异步）](java-sdk.md#)
5 | get(String appId) | [获取应用信息（同步）](java-sdk.md#)
6 | getInBackground(String appId, JBGetAppCallback callback) | [获取应用信息（异步）](java-sdk.md#)
7 | resetKey(int type) | [更新应用key或masterKey值（同步）](java-sdk.md#)
8 | resetKeyInBackground(int type, JBUpdateCallback callback) | [更新应用key或masterKey值（异步）](java-sdk.md#)
9 | list() | [获取应用列表（同步）](java-sdk.md#)
10 | listInBackground(JBAppListCallback callback) | [获取应用列表（异步）](java-sdk.md#)
11 | export(String appId) | [导出应用信息（同步）](java-sdk.md#)
12 | exportInBackground(String appId, JBAppExportCallback callback) | [导出应用信息（异步）](java-sdk.md#)
13 | importData(String data) | [导入应用信息（同步）](java-sdk.md#)
14 | importDataInBackground(String data, JBImportCallback callback) | [导入应用信息（异步）](java-sdk.md#)
15 | getApiStat(JBApiStat apiStat) | [获取应用api调用统计（同步）](java-sdk.md#)
16 | getApiStatInBackground(JBApiStat apiStat, JBApiStatListCallback callback) | [获取应用api调用统计（异步）](java-sdk.md#)
17 | updateAppConfig(JBAppConfig config) | [更新应用设置（同步）](java-sdk.md#)
18 | updateAppConfigInBackground(JBAppConfig config, JBUpdateCallback callback) | [更新应用设置（异步）](java-sdk.md#)
19 | getAppConfig(JBAppConfigKey appConfigKey) | [查看应用config信息（同步）](java-sdk.md#)
20 | getAppConfigInBackground(JBAppConfigKey appConfigKey, JBGetConfigCallback callback) | [查看应用config信息（异步）](java-sdk.md#)

#### 创建或更新应用信息



