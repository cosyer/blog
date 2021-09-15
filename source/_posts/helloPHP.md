---
title: helloPHP
tags:
  - PHP
copyright: true
comments: true
date: 2018-11-26 14:30:10
categories: PHP
photos:
top: 126
---

1年以前我就浅学过PHP，用`thinkPHP`框架开发起来确实比较轻松快捷流水化。最近闲来无事，再次回顾学习下这个世界上最好的语言。

## 简介
PHP 是一种创建动态交互性站点的强有力的服务器端脚本语言。

## 语法
PHP 脚本在服务器上执行，然后将纯 HTML 结果发送回浏览器。

PHP 脚本可以放在文档中的任何位置。

PHP 脚本以 <?php 开始，以 ?> 结束。很多语言的语法都相类似。

```php
<!DOCTYPE html> 
<html> 
<body> 
<?php 
echo "Hello World!";
// 单行注释
/*
多行注释
*/
?> 
</body> 
</html>
```

---
<!-- more -->

### 变量
- 变量以 $ 符号开始，后面跟着变量的名称

- 变量名必须以字母或者下划线字符开始

- 变量名只能包含字母数字字符以及下划线（A-z、0-9 和 _ ）

- 变量名不能包含空格

- 变量名是区分大小写的（$y 和 $Y 是两个不同的变量）

> 同js一样PHP也是弱类型脚本语言不需要声明变量的数据类型

### 作用域
1. local 局部
2. global 全局
3. static 静态
4. parameter 参数

```php
<?php 
$x=5; // 全局变量 
$z=5;
function myTest() 
{ 
    $y=10; // 局部变量 
    global $x,$z; // 函数内部访问全局变量需要加global关键字
    $z=$x+$z;
    // 一样的效果$GLOBALS['z']=$GLOBALS['x']+$GLOBALS['z'];
}  

myTest(); 
echo "<p>测试函数外变量:<p>"; 
echo "变量 x 为: $x"; 
echo "<br>"; 
echo "变量 y 为: $y"; 
echo $z; // 10
?>
```

当一个函数完成时，它的所有变量通常都会被删除。所以当需要时可以声明静态变量

```php
<?php
function myTest($y)
{
    static $x=0;
    echo $x,$y; // 参数变量
    $x++;
}
 
myTest(1);
myTest(2);
myTest(3);
?>
```

### 输出echo和print
echo 和 print 区别:
- echo - 可以输出一个或多个字符串
- print - 只允许输出一个字符串，返回值总为 1
> echo 输出的速度比 print 快， echo 没有返回值，print有返回值1。

### 语句加分号

### 数据类型
1. String（字符串）

```php
<?php 
$txt1="Hello"; 
$txt2="World"; 
echo $txt1 . " " . $txt2;  // "Hello world"
echo strlen("Hello World!"); // 返回长度
echo strpos("Hello World!","World"); // 返回索引和js indexOf很像
?>
```

2. Integer（整型）
3. Float（浮点型）
4. Boolean（布尔型）
5. Array（数组）
```php
<?php
$cars=array("Volvo","BMW","Toyota");
echo count($cars);
?>
// 数组遍历
<?php
$cars=array("Volvo","BMW","Toyota");
$arrlength=count($cars);
 
for($x=0;$x<$arrlength;$x++)
{
    echo $cars[$x];
    echo "<br>";
}
?>
// 关联数组 object？
<?php
$age=array("Peter"=>"35","Ben"=>"37","Joe"=>"43");
echo "Peter is " . $age['Peter'] . " years old.";
?>
// 遍历关联数组
<?php
$age=array("Peter"=>"35","Ben"=>"37","Joe"=>"43");
 
foreach($age as $x=>$x_value)
{
    echo "Key=" . $x . ", Value=" . $x_value;
    echo "<br>";
}
?>
```
数组排序函数
- sort() - 对数组进行升序排列
- rsort() - 对数组进行降序排列
- asort() - 根据关联数组的值，对数组进行升序排列
- ksort() - 根据关联数组的键，对数组进行升序排列
- arsort() - 根据关联数组的值，对数组进行降序排列
- krsort() - 根据关联数组的键，对数组进行降序排列

6. Object（对象）
使用class关键字声明类对象。类是可以包含属性和方法的结构。

```php
<?php
class Car
{
  var $color;
  function __construct($color="green") {
    $this->color = $color;
  }
  function what_color() {
    return $this->color;
  }
}
?>
```

7. NULL（空值）
> PHP var_dump() 函数返回变量的数据类型和值：
### 常量的声明
define()函数 
> define("slogan", "hello");
该函数有三个参数:
- name：必选参数，常量名称，即标志符。
- value：必选参数，常量的值。
- case_insensitive ：可选参数，如果设置为 TRUE，该常量则大小写不敏感。默认是大小写敏感的。

### if...elseif....else 语句
```php
<?php
$t=date("H");
if ($t<"10")
{
    echo "Have a good morning!";
}
elseif ($t<"20")
{
    echo "Have a good day!";
}
else
{
    echo "Have a good night!";
}
?>
```

### 超级全局变量
- $GLOBALS(超级全局变量组)
- $_SERVER(包含了诸如头信息(header)、路径(path)、以及脚本位置(script locations)等等信息的数组)
- $_REQUEST(用于收集HTML表单提交的数据)
- $_POST(用于收集HTML表单提交的数据,method设置为post)
- $_GET(用于收集HTML表单提交的数据,method设置为get,也可以收集URL中发送的数据)
- $_FILES
- $_ENV
- $_COOKIE
- $_SESSION

```php
<?php
$x=array("one","two","three");
foreach ($x as $value)
{
    echo $value . "<br>";
}
?>
```

### 魔术常量(预定义常量)
- __LINE__(当前行号)
- __FILE__(文件的完整路径和文件名)
- __DIR__(文件所在目录)
- __FUNCTION__(函数内部返回函数名)
- __CLASS__(类内部返回类名)
- __TRAIT__(Trait 名包括其被声明的作用区域)
从基类继承的成员被插入的 SayWorld Trait 中的 MyHelloWorld 方法所覆盖。
其行为 MyHelloWorld 类中定义的方法一致。优先顺序是当前类中的方法会覆盖 trait 方法，而 trait 方法又覆盖了基类中的方法。

```php
<?php
class Base {
    public function sayHello() {
        echo 'Hello ';
    }
}
 
trait SayWorld {
    public function sayHello() {
        parent::sayHello();
        echo 'World!';
    }
}
 
class MyHelloWorld extends Base {
    use SayWorld;
}
 
$o = new MyHelloWorld();
$o->sayHello(); // Hello World
?>
```

- __METHOD__(返回方法定义时的名称)
- __NAMESPACE__(当前的命名空间名称)
1. 用户编写的代码与PHP内部的类/函数/常量或第三方类/函数/常量之间的名字冲突。
2. 为很长的标识符名称(通常是为了缓解第一类问题而定义的)创建一个别名（或简短）的名称，提高源代码的可读性。

### php获取下拉菜单的数据
```php
<?php
$q = isset($_GET['q'])? htmlspecialchars($_GET['q']) : '';
if($q) {
        if($q =='BAIDU') {
                echo '百度<br>http://www.baidu.com';
        } else if($q =='GOOGLE') {
                echo 'Google 搜索<br>http://www.google.com';
        } else if($q =='TAOBAO') {
                echo '淘宝<br>http://www.taobao.com';
        }
} else {
?>
<form action="" method="get"> 
    <select name="q">
    <option value="">选择一个站点:</option>
    <option value="BAIDU">Runoob</option>
    <option value="GOOGLE">Google</option>
    <option value="TAOBAO">Taobao</option>
    </select>
    <input type="submit" value="提交">
    </form>
<?php
}
?>
```

### 获取当前时间
```php
<?php
//设置默认当前时区
date_default_timezone_set('PRC');
echo date('Y-m-d H:i:s',time());
?>
```

### 文件引入
> include 和 require 的区别
- require 一般放在 PHP 文件的最前面，程序在执行前就会先导入要引用的文件；
- include 一般放在程序的流程控制中，当程序执行时碰到才会引用，简化程序的执行流程。
- require 引入的文件有错误时，执行会中断，并返回一个致命错误；
- include 引入的文件有错误时，会继续执行，并返回一个警告。

### 打开文件
```php
$file = fopen("test.txt","r");

// 读取文件每一行，直到文件结尾
while(!feof($file))
{
    echo fgets($file). "<br>";
    //  逐个字符echo fgetc($file);
}

fclose($file);
```

### 文件上传
```html
<form action="upload_file.php" method="post" enctype="multipart/form-data">
    <label for="file">文件名：</label>
    <input type="file" name="file" id="file"><br>
    <input type="submit" name="submit" value="提交">
</form>
```

```php
<?php
header("Content-Type: text/html;charset=utf-8");
// 允许上传的图片后缀
$allowedExts = array("gif", "jpeg", "jpg", "png", "PNG");
$temp = explode(".", $_FILES["file"]["name"]);
echo $_FILES["file"]["size"];
$extension = end($temp);     // 获取文件后缀名
if ((($_FILES["file"]["type"] == "image/gif")
|| ($_FILES["file"]["type"] == "image/jpeg")
|| ($_FILES["file"]["type"] == "image/jpg")
|| ($_FILES["file"]["type"] == "image/pjpeg")
|| ($_FILES["file"]["type"] == "image/x-png")
|| ($_FILES["file"]["type"] == "image/png"))
&& ($_FILES["file"]["size"] < 204800)   // 小于 200 kb
&& in_array($extension, $allowedExts))
{
    if ($_FILES["file"]["error"] > 0)
    {
        echo "错误：: " . $_FILES["file"]["error"] . "<br>";
    }
    else
    {
        echo "上传文件名: " . $_FILES["file"]["name"] . "<br>";
        echo "文件类型: " . $_FILES["file"]["type"] . "<br>";
        echo "文件大小: " . ($_FILES["file"]["size"] / 1024) . " kB<br>";
        echo "文件临时存储的位置: " . $_FILES["file"]["tmp_name"] . "<br>";
        
        // 判断当期目录下的 upload 目录是否存在该文件
        // 如果没有 upload 目录，你需要创建它，upload 目录权限为 777
        if (file_exists("upload/" . $_FILES["file"]["name"]))
        {
            echo $_FILES["file"]["name"] . " 文件已经存在。 ";
        }
        else
        {
            // 如果 upload 目录不存在该文件则将文件上传到 upload 目录下
            move_uploaded_file($_FILES["file"]["tmp_name"], "upload/" . $_FILES["file"]["name"]);
            echo "文件存储在: " . "upload/" . $_FILES["file"]["name"];
        }
    }
}
else
{
    echo "非法的文件格式";
}
?>
```

### 设置cookie(必须写在html之前)
```php
setcookie("user", "cosyer", time()+3600); // 1小时后过期
echo $_COOKIE["user"]; // (isset($_COOKIE["user"])判断是否设置了cookie
// 删除setcookie("user", "", time()-3600);设置成过去的时点
```

### 存储session
```php
session_start();
// 存储 session 数据
$_SESSION['views']=1;
// 释放 session 数据
// unset($_SESSION['views']);
// 清空所有数据
// session_destroy();
```

### php发送email
```php
<?php
if (isset($_REQUEST['email'])) { // 如果接收到邮箱参数则发送邮件
    // 发送邮件
    $email = $_REQUEST['email'] ;
    $subject = $_REQUEST['subject'] ;
    $message = $_REQUEST['message'] ;
    mail("someone@example.com", $subject,
    $message, "From:" . $email);
    echo "邮件发送成功";
} else { // 如果没有邮箱参数则显示表单
    echo "<form method='post' action='mailform.php'>
    Email: <input name='email' type='text'><br>
    Subject: <input name='subject' type='text'><br>
    Message:<br>
    <textarea name='message' rows='15' cols='40'>
    </textarea><br>
    <input type='submit'>
    </form>";
}
?>
```

### 错误处理
> die("文件不存在");
### 异常处理 同 try catch new Exception()