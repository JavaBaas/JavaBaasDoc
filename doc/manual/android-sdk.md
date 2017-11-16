# 目录
## 一、SDK安装与初始化

#### Maven自动导入安装

``implementation 'com.javabaas:javasdk:+'``

#### SDK初始化：

在系统启动的地方，如自己的Application类中注册SDK：

```java
public class App extends Application {

    @Override
    public void onCreate() {
		super.onCreate();
		
		// 初始化参数依次为 后台服务器地址,AppId, AppKey
		JBConfig.init("http://139.198.5.252:9000/api","59f85aee12a0aa06cb8539a7","4a4b67e87db24adbabfc5c64c1343dd2");
    }
}
```

然后在`AndroidManifest.xml`中配置SDK所需的一些权限

```
<uses-permission android:name="android.permission.INTERNET" />
```

SDK配置完成，可以进行一些简单的访问测试：
确保服务器端已经创建一个表叫`Test`

```java
public void onSave(View view) {
   final JBObject testC = new JBObject("Test");
   testC.put("testA", "测试A");
   testC.put("testB", "测试B");
   testC.saveInBackground(new JBBooleanCallback() {
        @Override
        public void done(boolean success, JBException e) {
			if (success){
				Log.d(TAG,"保存成功");
			}else {
				Log.d(TAG,"保存失败");
			}
        }
    });
}
```

## 二、对象
### 32..1 JBObject
`JBOject`是JavaBaas中的基础对象，也可以理解为`JBOject`对应着数据库表中的一条信息。

假如你在云端数据库中使用`FoodLike`表来记录用户最喜欢的食物，那么表中至少会有`foodName`(食品名称)，`userName`(用户名称)属性，那么，你应该这样生成`JBOject`:

```java
JBObject jbObject = new JBObject("FoodLike");
jbObject.put("foodName","dumpling");
jbObject.put("userName","ZhangSan");
```
>有几点需要注意:

* 每个`JBOject`都必须在云端有对应的数据库表和相应的字段。
* 每个`JBOject`都有保留字段，分别为`_id``acl``createdPlat``updatedPlat``createdAt``updatedAt`等，这些字段由系统自动生成和修改，不需要开发者进行指定。

### 2.2 同步与异步
JavaBaas提供了数据检索，保存，更新，删除，查询的同步与异步的方法。  
  
注: 在Android UI主线程中调用同步的方法，可能会导致UI主线程阻塞。所以，在UI主线程中请使用异步的方式。
  

### 2.3 检索对象
如果你知道了云端中某条数据的`objectId`，那么可以通过以下代码获取此条数据对应的`JBOject`对象:

```java
1.同步检索:
JBQuery<JBObject> jbQuery = JBQuery.getInstance("FoodLike");
jbQuery.whereEqualTo("_id", objectID);
JBObject result;
try {
	List<JBObject> resultList = jbQuery.find();
	result = resultList.get(0);
} catch (JBException e) {
	e.printStackTrace();
}

2.异步检索:
JBQuery<JBObject> jbQuery = JBQuery.getInstance("FoodLike");
jbQuery.whereEqualTo("_id", objectID);
jbQuery.findInBackground(new JBFindCallBack<JBObject>() {
	@Override
	public void done(boolean success, List<JBObject> objects, JBException e) {
		if (success){
		Log.d(TAG,"查询成功");
		}else {
		Log.d(TAG,"查询失败");
		}
	}
});
```
      
### 2.4 保存对象
如2.1所示，假如你在本地生成一个`JBObject`之后，那么可以使用以下代码将其保存至云端:

```java
1.同步保存:
try {
	jbObject.save();
	Log.d(TAG , "保存成功");
} catch (JBException e) {
	e.printStackTrace();
}

2.异步保存:
jbObject.saveInBackground(new JBBooleanCallback() {
    @Override
    public void done(boolean b, JBException e) {
        if (b){
            Log.d(TAG , "保存成功");
        }else {
            Log.d(TAG , "保存失败");
        }
    }
});
```
 如需在保存成功后更新本地对象，可以调用
 
 `jbObject.setFetchWhenSave(true);` 

### 2.5 更新对象
如果你知道了云端中某条数据的`objectId`，那么可以通过以下代码更新云端对应的数据:

```java
1.同步更新:
JBObject jbObject = new JBObject("FoodLike");
jbObject.setId(objectId);
jbObject.put("foodName","hamburger");
try {
	jbObject.save();
	Log.d(TAG , "更新成功");
} catch (JBException e) {
	Log.d(TAG , "更新失败");
	e.printStackTrace();
}

2.异步更新:
JBObject jbObject = new JBObject("FoodLike");
jbObject.setId(objectId);
jbObject.put("foodName","hamburger");
jbObject.saveInBackground(new JBBooleanCallback() {
    @Override
    public void done(boolean b, JBException e) {
        if (b){
            Log.d(TAG , "更新成功");
        }else {
            Log.d(TAG , "更新失败");
        }
    }
});
```
### 2.6 删除对象
如果你知道了云端中某条数据的`objectId`，那么可以通过以下代码删除云端对应的数据:

```java
1.同步删除:
JBObject jbObject = new JBObject("FoodLike");
jbObject.setId(objectId);
try {
	jbObject.delete()
	Log.d(TAG, "删除成功");
} catch (JBException e) {
	e.printStackTrace();
}

2.异步删除:
JBObject jbObject = new JBObject("FoodLike");
jbObject.setId(objectId);

jbObject.deleteInBackground(new JBBooleanCallback() {
	@Override
	public void done(boolean success, JBException e) {
	   view.setClickable(true);
	   if (success) {
		   Log.d(TAG, "删除成功");
	   } else {
	       Log.d(TAG, "删除失败");
	   }
	}
});
```

## 三、用户JBUser

### 3.1 JBUser
JavaBaas提供了JBUser类来处理用户相关的功能。

需要注意的是，JBUser继承了JBObject，并在JBObject的基础上增加了一些对用户账户操作的功能。

### 3.2 特殊属性
JBUser有几个特定的属性为:

* username:用户的用户名(必须)
* password:用户的密码(必须)
* email:用户的电子邮箱(可选)
* phone:用户的手机号码(可选)

设置属性的方法如下:

```
JBUser jbUser = new JBUser();
//设置用户名             
jbUser.setUsername("ZhangSan");        
//设置密码          
jbUser.setPassword("123456");
//设置手机号   
jbUser.setPhone("110");
```

### 3.3 注册
用户注册的示例代码如下:

```
1.同步注册
JBUser jbUser = new JBUser();             
jbUser.setUsername("ZhangSan");               
jbUser.setPassword("123456");
try {
	jbUser.signUp();
	Log.d(TAG, "注册成功");
} catch (JBException e) {
	e.printStackTrace();
}

2.异步注册
JBUser jbUser = new JBUser();
jbUser.setUsername("ZhangSan");
jbUser.setPassword("123456");
jbUser.signUpInBackground(new JBBooleanCallback() {
    @Override
    public void done(boolean success, JBException e) {
        if (success) {
            Log.d(TAG, "注册成功");
        } else {
            Log.d(TAG, "注册失败");
        }
    }
});
```

### 3.4 登录
当用户注册成功后，用户可以通过注册的用户名，密码登录到他们的账户。
用户登陆的示例代码如下:

```
//用户名、密码登录
String username = "ZhangSan";
String password = "123456";
JBUser.loginInBackground(username, password, new JBLoginCallback() {
    @Override
    public void done(boolean success, JBUser user, JBException e) {
		if (success) {
			Log.d(TAG, "登录成功");
		} else {
		   Log.d(TAG, "登录失败");
		}
    }
});

```
第三方授权登录,参考[这里](https://github.com/JavaBaas/JavaBaasDoc/blob/master/doc/manual/java-sdk.md#%E7%AC%AC%E4%B8%89%E6%96%B9%E7%A4%BE%E4%BA%A4%E5%B9%B3%E5%8F%B0%E6%B3%A8%E5%86%8C)
### 3.5 当前用户

当用户登陆成功后，本地会生成一个`currentUser`对象，你可以使用此对象来进行判断用户是否登陆:

```
//使用currentUser对象进行判断
JBUser jbUser = JBUser.getCurrentUser();
if (jbUser!=null){
	Log.d(TAG, "currentUser不为空，允许用户使用");
}else {
	Log.d(TAG, "currentUser为空，此时可打开用户注册/登陆的界面");
}

```
清除缓存的`currentUser`对象，即退出登录。

```
JBUser.updateCurrentUser(null);
```


### 3.6 修改密码
假如用户登录成功后，想改变自己的用户信息，可以通过以下代码来更新:

```
JBUser jbUser = JBUser.getCurrentUser();
if (jbUser!=null){
	jbUser.updatePassword("123456", "456789", new JBUpdatePasswordCallback() {
        @Override
        public void done(boolean success, String sessionToken, JBException e) {
			if (success) {
				Log.d(TAG, "修改成功");
			} else {
				Log.d(TAG, "修改失败");
			}
        }
    });
}
```
### 3.7 SessionToken介绍
`SessionToken`是`JBUser`的一个非常特殊的属性，是
`JBUser`的内建字段。当用户注册成功后，自动生成且唯一。

当用户更改重置密码后，`SessionToken`也会被重置。

`SessionToken`的作用主要有两个方面:

* 服务器用来校验用户登录与否
* 保证在多设备登录同一账号情况下，用户账号安全

## 四、设备与推送

`_Installation`是存在于云端的一个用来管理设备信息的默认表。

* `deviceToken` : 设备的唯一标示符
* `deviceType` :  对于Android设备来说，type就是"Android"

```java
JBInstallation.registerDeviceInBackground(deviceType, deviceToken, new JBInstallationCallback() {
    @Override
    public void done(boolean success, String installationId, JBException e) {
		if (success) {
			Log.d(TAG, "成功");
		} else {
			Log.d(TAG, "失败");
		}
	}
});
```

## 五、调用云方法

有些逻辑是无法通过普通的增删改查数据来实现的，比如记录所有用户打开某界面的次数openCount。这时候，服务端通过提供"云端方法"即可解决这些问题。

假如为了解决上述问题，服务端提供了一个"addOpenCount"云方法，当客户端调用此方法的时候，服务端则会把openCount数量加1。

调用云方法的代码非常简单:

```java
JBCloud.cloudInBackground("addOpenCount", null, new JBCloudCallback() {
	@Override
	public void done(boolean success, Map<String, Object> data, JBException e) {
		if (success) {
			Log.d(TAG, "成功");
		} else {
			Log.d(TAG, "失败");
		}
	}
});
```

有的时候调用云方法还需将参数传递上去，比如我们需要实现一个用户给某产品评分的需求，服务端提供一个"addProductScore"云方法，客户端就可以调用此方法并将所评的分数传上去。

代码如下:

```
HashMap<String, Object> params = new HashMap<>();
params.put("productScore",100);
        
JBCloud.cloudInBackground("addProductScore", params, new JBCloudCallback() {
	@Override
	public void done(boolean success, Map<String, Object> data, JBException e) {
		if (success) {
			Log.d(TAG, "成功");
		} else {
			Log.d(TAG, "失败");
		}
	}
});
```
