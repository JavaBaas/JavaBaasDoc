#命令行工具
命令行工具`BaasShell`是JavaBaas的配置工具，使用`BaasShell`可以完成类的创建及删除、字段的创建删除、对象的增删改查等操作，以及系统初始化等工作。

`BaasShell`基于java编写，编译及运行需要安装JDK环境。

##运行
使用以下命令启动命令行工具

```
java -jar BaasShell.jar
```

启动成功后显示以下信息

```
         _-----_
        |       |    .--------------------------.
        |--(o)--|    | Let's play with JavaBaas |
       `---------´   |       application!       |
        ( _´U`_ )    '--------------------------'
        /___A___\
         |  ~  |
       __'.___.'__
     ´   `  |° ´ Y `
Version:1.0.0
Host:http://127.0.0.1:8080/
AdminKey:123456
BAAS>
```

###启动参数
`BaasShell`有两个启动参数，分别为`服务器地址`和`adminKey`，启动时附加在启动命令之后。如：
```bash
java -jar 182.92.237.224:8080 Vm0weGQxSXhWWGhWV0d4VlYwZDRWMWxyWkZOalZsWnpXa2M1YVUxWVFsaFdNbmhy
```

`服务器地址`默认值为127.0.0.1:8080
`adminKey`默认值为123456

##命令
###内建命令
####帮助信息 help
查看帮助信息。

####版本号 version
查看`BaasShell`版本号。

####清屏 cls
清空当前终端信息。

####退出 exit
退出`BaasShell`命令行。

###应用相关命令
####创建应用 app add {appName}
创建应用。

```bash
BAAS>app add Comic
App added.
```

####显示应用列表 apps
查询系统中所有的应用。如：

```bash
BAAS>apps
Comic
```

####删除应用 app del {appName}
删除类`appName `参数为应用名。如：

```bash
BAAS>app del Comic
App deleted.
```

<span id="setAppNow"></span>

####设置当前应用 use {appName}
设置当前正在操作的应用 `appName`参数为应用名。设置成功后光标将变为 当前应用名。

```bash
BAAS>use Comic
Set current app to Comic
Comic>
```
设置当前应用为Comic。

###类相关命令
由于所有类操作都是针对某一个应用进行的，因此类操作需先**设置当前应用**。

####添加类 class add {className}
为当前应用添加类`className`参数为类名。
此方法必须在已经设置了当前应用时调用。
如：

```bash
Comic>class add Book
Class added.
```
添加名称为Book的类

####显示类列表 classes
查询当前应用中的所有类。此方法必须在已经设置了当前应用时调用。如：

```bash
Comic>classes
_User
_Installation
_File
Book
Page
Category
```
表示当前应用中有六个表，分别为内建类`_User` `_Installation` `_File`以及用户自建的`Book` `Page` `Category`。

####删除类 class del {className}
在当前应用中，删除类`className`参数为类名。此方法必须在已经设置了当前应用时调用。如：

```bash
BAAS>class del Book
Class deleted.
```
删除名称为Book的类

<span id="setClassNow"></span>

####设置当前类 set {className}
设置当前正在操作的类`className`参数为类名。设置成功后光标将变为 当前应用名_当前类名。

```bash
BAAS>set Book
Set current class to Book
Comic Book>
```
设置当前类为Book。

###字段相关命令
由于所有字段操作都是针对某一个类进行的，因此字段操作需先**设置当前类**。

####显示字段列表 fields
显示当前类的所有字段。如：

```bash
BAAS>set Book
Set current class to Book
Comic Book>field
<STRING>  name
<NUMBER>  price
```
表示当前类`Book`中有两个字段、分别为字符型字段`name`以及数值型字段`price`。

####添加字段 field add {fieldName} [--type {typeId}]
在当前类中添加一个字段。其中`fieldName`为字段名，`typeId`为可选参数，参数值为字段的[数据类型](/overview/object.md#数据类型)。如：

```bash
BAAS>set Book
Set current class to Book
Comic Book>field add name
Field added.
Comic Book>field add price --type 2
Field added.
```
在`Book`类中添加字符型字段`name`以及数值型字段`price`。

####删除字段 field del {fieldName}
在当前类中删除一个字段。其中`fieldName`为字段名。如：

```bash
Comic Book>field del name
Field deleted.
```
在`Book`类中删除字段`name`。

####查看所有字段数据类型 field type
显示当前支持的字段类型及对应的值。参见[数据类型](/overview/object.md#数据类型)。

###对象相关命令
在对对象进行操作前，需要先**设置当前类**。

####查询所有对象 list [{where}]
查询当前类的所有对象。参数`where`是查询条件，条件为空时显示所有对象。

```bash
Comic Book>list {price:20}
{"createdAt":1441880564365,"price":20,"name":"b","id":"55f159f477c877a455248a23","acl":{"*":{"read":true,"write":true}},"updatedAt":1441880564365}
{"createdAt":1441880561707,"price":20,"name":"a","id":"55f159f177c877a455248a22","acl":{"*":{"read":true,"write":true}},"updatedAt":1441880561707}
```
查询`Book`类中所有`price`等于20的对象。

####插入对象 add {body}
向当前类插入对象。如：

```bash
Comic Book>add {name:"Three body",price:100}
Object added.
```
在`Book`类中添加一个对象。

####删除对象 del {id}
删除当前类中指定`id`的对象。如：

```bash
Comic Book>del 55f159f777c877a455248a24
Object deleted.
```
删除`Book`类中`id`为55f159f777c877a455248a24的对象。

####查询对象个数 count [{where}]
查询当前类中对象的个数。参数`where`是查询条件，条件为空时则显示当前类中所有对象的个数。如：

```bash
Comic Book>count {price:20}
2
```
查询`Book`类中所有`price`等于20的对象个数。
