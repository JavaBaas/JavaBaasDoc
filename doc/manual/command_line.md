# 命令行工具
命令行工具`JBShell`是JavaBaas的配套工具，可以使用JBShell对JavaBaas进行管理维护操作。包括应用的创建删除、类的创建删除、字段的创建删除、对象的增删改查等操作，以及一些便捷的辅助功能。

## 主要功能

* 应用管理(创建、删除、导入导出)
* 类管理(创建、删除、权限管理)
* 字段管理(创建、删除、权限管理)
* 数据操作(增删改查)
* 生成鉴权信息
* 获取数据源URL

## 安装
`JBShell`基于java编写，编译及运行需要安装JDK环境。

### Mac&Linux安装
在命令行中执行

```
curl -s "http://get.javabaas.com/jbshell.sh" | bash
```

安装成功后，打开一个新窗口，输入命令`JB`即可启动命令行工具。

### Windows安装
在[下载](/download.md)页面，下载JavaBaasShell(windows)命令行工具程序，启动执行即可。


## 启动
在命令行中使用以下命令启动`JBShell`工具：

```
jb
```

启动成功后显示以下信息

```
   ___                     ______
  |_  |                    | ___ \
    | |  __ _ __   __ __ _ | |_/ /  __ _   __ _  ___
    | | / _` |\ \ / // _` || ___ \ / _` | / _` |/ __|
/\__/ /| (_| | \ V /| (_| || |_/ /| (_| || (_| |\__ \
\____/  \__,_|  \_/  \__,_|\____/  \__,_| \__,_||___/
Version:2.0.0
Host:http://localhost:8080/api/
AdminKey:JavaBaas
BAAS>
```

## 命令
`JBShell`使命命令行交互方式进行操作。

### 内建命令
#### 帮助信息 help
查看帮助信息。

#### 版本号 version
查看`JBShell`版本号。

#### 清屏 cls
清空当前终端信息。

#### 退出 exit
退出`JBShell`命令行。

### 应用相关命令
#### 创建应用 app add {appName}
创建应用。

```bash
BAAS>app add Comic
应用创建成功
设置当前应用为 Comic
```

#### 显示应用列表 app
查询系统中所有的应用。如：

```bash
BAAS>apps
Comic
```

#### 设置当前应用 use {appName}
设置当前正在操作的应用 `appName`参数为应用名。设置成功后光标将变为 当前应用名。

```bash
BAAS>use Comic
设置当前应用为 Comic	
Comic>
```
设置当前应用为Comic。

#### 删除应用 app del {appName}
删除应用，`appName `参数为应用名。如：

```bash
BAAS>app del Comic
确认要删除应用?
(y/n)>y
删除成功
```

提示:删除应用时需要进行二次确认(输入y)

#### 显示鉴权信息 token
显示当前正在操作应用的鉴权信息。包括AppId、Key等信息。

```
Comic>token
Timestamp:  1510217270432
Nonce:  83ee9b42aba0455882f383fd03c3f860
AdminSign:  d0bdd0cb587f5b544a470f53491d5356
AppId:  5a040a88ae07be6f1fcfb98a
Key:  01bca9e5148e43458335e288468dff54
MasterKey:  433f4abc5b18470282daaac8e8bd272a
Sign:  d0bdd0cb587f5b544a470f53491d5356
MasterSign:  cd917d5a4729f24e0403646857d665a2
```

### 类相关命令
由于所有类操作都是针对某一个应用中的类进行的，因此类相关操作需先**设置当前应用**。

#### 添加类 class add {className}
为当前应用添加类，`className`参数为类名。
此方法必须在已经设置了当前应用时调用。
如：

```bash
Comic>class add Book
类创建成功
```
添加名称为Book的类

#### 显示类列表 class
查询当前应用中的所有类。此方法必须在已经设置了当前应用时调用。如：

```bash
Comic>class
_File(0)
_Installation(0)
_PushLog(0)
_SmsLog(0)
_User(0)
Book(0)
```
表示当前应用中有六个类，分别为内建类`_User` `_Installation` `_File` `_PushLog ` `_SmsLog `以及用户自建的`Book`。

#### 设置当前类 set {className}
设置当前正在操作的类`className`参数为类名。设置成功后光标将变为 当前应用名_当前类名。

```bash
BAAS>set Book
Set current class to Book
Comic Book>
```
设置当前类为Book。

#### 删除类 class del {className}
在当前应用中，删除类`className`参数为类名。此方法必须在已经设置了当前应用时调用。如：

```bash
BAAS>class del Book
是否确认删除类?
(y/n)>y
删除成功
```
删除名称为Book的类

提示:删除类时需要进行二次确认(输入y)

### 字段相关命令
由于所有字段操作都是针对某一个类进行的，因此字段操作需先**设置当前类**。

#### 添加字段 field add {fieldName}
在当前类中添加一个字段。其中`fieldName`为字段名，添加后，需要选择字段类型，参见[数据类型](/overview/object.md#数据类型)。如：

```bash
BAAS>set Book
Set current class to Book
Comic Book>field add name
请选择FieldType 默认为STRING
1 STRING
2 NUMBER
3 BOOLEAN
4 DATE
5 FILE
6 OBJECT
7 ARRAY
8 POINTER
0 取消
>1
创建字段成功
```

```
Comic Book>field add price
请选择FieldType 默认为STRING
1 STRING
2 NUMBER
3 BOOLEAN
4 DATE
5 FILE
6 OBJECT
7 ARRAY
8 POINTER
0 取消
>2
创建字段成功
```

在`Book`类中添加字符型字段`name`以及数值型字段`price`。

#### 显示字段列表 field
显示当前类的所有字段。如：

```bash
Comic>set Book
设置当前类为 Book
Comic Book>field
<STRING>  name
<NUMBER>  price
```
表示当前类`Book`中有两个字段、分别为字符型字段`name`以及数值型字段`price`。

#### 删除字段 field del {fieldName}
在当前类中删除一个字段。其中`fieldName`为字段名。如：

```bash
Comic Book>field del name
是否确认删除字段?
(y/n)>y
删除成功
```
在`Book`类中删除字段`name`。

提示:删除字段时需要进行二次确认(输入y)

#### 查看所有字段数据类型 field type
显示当前支持的字段类型及对应的值。参见[数据类型](/overview/object.md#数据类型)。

### 对象相关命令
在对对象进行操作前，需要先**设置当前类**。

#### 插入对象 add {body}
向当前类插入对象。如：

```bash
Comic Book>add {"name":"Three body","price":100}
对象创建.
Comic Book>add {"name":"Four body","price":20}
对象创建.
```
在`Book`类中添加一个对象。

#### 查询所有对象 list [{where}]
查询当前类的所有对象。参数`where`是查询条件，条件为空时显示所有对象。

```bash
Comic Book>list {"price":20}
{"className":"Book", "objectId":"963bc4856ee743038bf15d022e9b33f2", "updatedAt":"1510758374320", "createdAt":"1510758374320", "serverData":{"price":20,"name":"Four body"}}
```
查询`Book`类中所有`price`等于20的对象。请参阅查询条件相关文档。

#### 删除对象 del {id}
删除当前类中指定`id`的对象。如：

```bash
Comic Book>del 55f159f777c877a455248a24
对象删除.
```
删除`Book`类中`id`为55f159f777c877a455248a24的对象。

#### 查询对象个数 count [{where}]
查询当前类中对象的个数。参数`where`是查询条件，条件为空时则显示当前类中所有对象的个数。如：

```bash
Comic Book>count {"price":20}
1
```
查询`Book`类中所有`price`等于20的对象个数。请参阅查询条件相关文档。

#### 表格打印 table [{where}]
查询当前类的所有对象，并以表格形式打印，参数`where`是查询条件，条件为空时显示所有对象。

```
Comic Book>table
┌──────────────────────────────────┬────────────────────┬────────────────────┐
│ id                               │ name               │ price              │
│ <STRING>                         │ <STRING>           │ <NUMBER>           │
├──────────────────────────────────┼────────────────────┼────────────────────┤
│ e19a578647f24f76b8af4a54c6e2e4ee │ Four body          │ 20                 │
├──────────────────────────────────┼────────────────────┼────────────────────┤
│ 517c34501f8e4188b01223094dd56fa6 │ Three body         │ 100                │
└──────────────────────────────────┴────────────────────┴────────────────────┘
```
