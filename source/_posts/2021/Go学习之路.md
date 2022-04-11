---
title: Go学习之路
tags:
  - go
copyright: true
comments: true
date: 2021-9-13 11:32:11
categories: Go
top: 107
photos:
---

> 人生苦短，let's Go

## 环境安装

### homebrew 安装 go

- [mac 使用 brew 安装 Python](https://www.jianshu.com/p/b821a8d1d8dc)

#### 安装

```bash
brew install go
```

### 官网下载安装(https://golang.google.cn/dl/)

### 配置 golang 的相关环境变量

**_默认 go 安装的文件地址是 /usr/local/go/_**

### 将 go 的配置写入环境

```bash
cd ~
vim ./bash_profile

#GO
#GOROOT
export GOROOT=/usr/local/go/
#GOPATH
export GOPATH=$HOME/go

source ~/.bash_profile
```

### 检查环境变量和版本

```go
go env
go version
```

### 示例

```go
go mod init hello

// 创建main.go
package main
import "fmt"
func main() {
	fmt.Println("Hello World")
}

// go build 编译 -o 指定名称
// go run main.go

// 导包
import "fmt"
import "os"

import (
	"fmt"
	"os"
)

import ("fmt"; "os")

// 重命名
import fm "fmt"
```

### go install

`go install`表示安装的意思，它先编译源代码得到可执行文件，然后将可执行文件移动到 GOPATH 的 bin 目录下。因为我们的环境变量中配置了 GOPATH 下的 bin 目录，所以我们就可以在任意地方直接执行可执行文件了。

### go proxy

默认 GoPROXY 配置是：GOPROXY=https://proxy.golang.org,direct，由于国内访问不到https://proxy.golang.org，所以我们需要换一个PROXY，这里推荐使用https://goproxy.io或https://goproxy.cn。

可以执行下面的命令修改 GOPROXY：

```go
go env -w GOPROXY=https://goproxy.cn,direct
```

### 25 个关键字/保留字

| 1        |      2      |   3    |     4     | 5      |
| :------- | :---------: | :----: | :-------: | :----- |
| break    |   default   |  func  | interface | select |
| case     |    defer    |   go   |    map    | struct |
| chan     |    else     |  goto  |  package  | switch |
| const    | fallthrough |   if   |   range   | type   |
| continue |     for     | import |  return   | var    |

## 类型

- int、float、bool、string
- 结构化的（复合的），如：struct、array、slice、map、channel；默认值都是 nil
- 只描述类型的行为的，如：interface。

```go
package main

import (
  "fmt"
)

const c = "C"

var v int = 5

type T struct{}

func init() { // initialization of package
}

func main() {
	var a int
	Func1()
	// ...
	fmt.Println(a)
}

func (t T) Method1() {
  //...
}

func Func1() { // exported function Func1
  //...
}

// 常量可以用来枚举
const (
	Unknown = 0
	Female = 1
	Male = 2
)

// iota，特殊常量，可以认为是一个可以被编译器修改的常量。
const (
	a = iota   //0
	b          //1
	c          //2
	d = "ha"   //独立值，iota += 1
	e          //"ha"   iota += 1
	f = 100    //iota +=1
	g          //100  iota +=1
	h = iota   //7,恢复计数
	i          //8
)
fmt.Println(a,b,c,d,e,f,g,h,i)
// 0 1 2 ha ha 100 100 7 8
```

### 类型转换

> 在必要以及可行的情况下，一个类型的值可以被转换成另一种类型的值。由于 Go 语言不存在隐式类型转换，因此所有的转换都必须显式说明，就像调用一个函数一样（类型在这里的作用可以看作是一种函数）

```go
// 等同于var a = 5.0
a := 5.0
b := int(a)

// 格式化字符串
package main

import (
  "fmt"
)

func main() {
	// %d 表示整型数字，%s 表示字符串
	var stockcode=123
	var enddate="2020-12-31"
	var url="Code=%d&endDate=%s"
	var target_url=fmt.Sprintf(url,stockcode,enddate)
	fmt.Println(target_url)
}
// Code=123&endDate=2020-12-31
// 类型默认值
bool(false)、int(0)、string("")

// 因式分解关键字写法
var x, y int
var (  // 这种因式分解关键字的写法一般用于声明全局变量
	a int
	b bool
)
```

### for 循环

```go
for key, value := range oldMap {
  newMap[key] = value
}

sum := 0
for i := 0; i <= 10; i++ {
	sum += i
}
fmt.Println(sum)

// 无限循环
for {
	sum++ // 无限循环下去
}

for true {
	sum++
}

// 遍历
strings := []string{"google", "cosyer"}
for i, s := range strings {
	fmt.Println(i, s)
}


numbers := [6]int{1, 2, 3, 5}
for i,x:= range numbers {
 	fmt.Printf("第 %d 位 x 的值 = %d\n", i,x)
}
// 0 google
// 1 cosyer
// 第 0 位 x 的值 = 1
// 第 1 位 x 的值 = 2
// 第 2 位 x 的值 = 3
// 第 3 位 x 的值 = 5
// 第 4 位 x 的值 = 0
// 第 5 位 x 的值 = 0
```

### 数组

```go
// 初始化数组中 {} 中的元素个数不能大于 [] 中的数字。
// 如果忽略 [] 中的数字不设置数组大小，Go 语言会根据元素的个数来设置数组的大小
var balance = [5]float32{1000.0, 2.0, 3.4, 7.0, 50.0}
```

### 结构体 Struct

```go
type Books struct {
	title string
	author string
	subject string
	book_id int
}
// Books{"Go 语言", "cosyer", "Go 语言教程", 6495407}
// Books{title: "Go 语言", author: "cosyer", subject: "Go 语言教程", book_id: 6495407}
// Books{title: "Go 语言", author: "cosyer"}
```

### 切片 Slice - 切片不需要说明长度

```go
s :=[] int {1,2,3}

 // 默认值nil
var numbers []int

var numbers = make([]int,3,5)
fmt.Printf("len=%d cap=%d slice=%v\n",len(x),cap(x),x)
// len=3 cap=5 slice=[0 0 0]

// 切片截取
numbers := []int{0,1,2,3,4,5,6,7,8}
// numbers[1:4] == [1 2 3]
// numbers[:3] == [0 1 2]
// numbers[4:] == [4 5 6 7 8]

// 添加一个元素
append(numbers, 0)
/* 创建切片 numbers1 是之前切片的两倍容量*/
numbers1 := make([]int, len(numbers), (cap(numbers))*2)
// 拷贝
copy(numbers1, numbers)
```

### 语言范围 Range

```go
nums := []int{2, 3, 4}
sum := 0
for _, num := range nums {
		sum += num
}
//range也可以用来枚举Unicode字符串。第一个参数是字符的索引，第二个是字符（Unicode的值）本身。
for i, c := range "go" {
	fmt.Println(i, c)
}
```

### 集合 Map

```go
/* 声明变量，默认 map 是 nil */
var map_variable map[key_data_type]value_data_type

/* 使用 make 函数 */
map_variable := make(map[key_data_type]value_data_type)


var countryCapitalMap map[string]string /*创建集合 */
countryCapitalMap = make(map[string]string)

/* map插入key - value对,各个国家对应的首都 */
countryCapitalMap [ "France" ] = "巴黎"
countryCapitalMap [ "Italy" ] = "罗马"
countryCapitalMap [ "Japan" ] = "东京"
countryCapitalMap [ "India " ] = "新德里"

/*使用键输出地图值 */
for country := range countryCapitalMap {
	fmt.Println(country, "首都是", countryCapitalMap [country])
}

/*查看元素在集合中是否存在 */
capital, ok := countryCapitalMap [ "American" ] /*如果确定是真实的,则存在,否则不存在 */
/*fmt.Println(capital) */
/*fmt.Println(ok) */
if (ok) {
	fmt.Println("American 的首都是", capital)
} else {
	fmt.Println("American 的首都不存在")
}

// delete删除集合元素
delete(countryCapitalMap, "France")
```

### 接口 Interface

```go
/* 定义接口 */
type interface_name interface {
	method_name1 [return_type]
	method_name2 [return_type]
	method_name3 [return_type]
	...
	method_namen [return_type]
}

/* 定义结构体 */
type struct_name struct {
  /* variables */
}

/* 实现接口方法 */
func (struct_name_variable struct_name) method_name1() [return_type] {
  /* 方法实现 */
}
```

### 错误处理 Error

```go
type error interface {
  Error() string
}

func Sqrt(f float64) (float64, error) {
	if f < 0 {
		return 0, errors.New("math: square root of negative number")
	}
	// 实现
}
result, err:= Sqrt(-1)

if err != nil {
  fmt.Println(err)
}
```

### Go 并发

```go
package main

import (
	"fmt"
	"time"
)

func say(s string) {
	for i := 0; i < 5; i++ {
		time.Sleep(100 * time.Millisecond)
		fmt.Println(s)
	}
}

func main() {
	go say("world")
	say("hello")
}
// 输出的 hello 和 world 是没有固定先后顺序。因为它们是两个 goroutine 在执行
```

### 通道 Channel

> 通道（channel）是用来传递数据的一个数据结构。

- 通道可用于两个 goroutine 之间通过传递一个指定类型的值来同步运行和通讯。操作符 <- 用于指定通道的方向，发送或接收。如果未指定方向，则为双向通道。

```go
ch <- v    // 把 v 发送到通道 ch
v := <-ch  // 从 ch 接收数据
           // 并把值赋给 v
ch := make(chan int)
```

```go
// 计算数字之和
package main

import "fmt"

func sum(s []int, c chan int) {
	sum := 0
	for _, v := range s {
					sum += v
	}
	c <- sum // 把 sum 发送到通道 c
}

func main() {
	s := []int{7, 2, 8, -9, 4, 0}

	c := make(chan int)
	go sum(s[:len(s)/2], c)
	go sum(s[len(s)/2:], c)
	x, y := <-c, <-c // 从通道 c 中接收
	fmt.Println(x, y, x+y)
}
// -5 17 12

// 可以设置缓冲区
ch := make(chan int, 100)
// 这里我们定义了一个可以存储整数类型的带缓冲通道
// 缓冲区大小为2
ch := make(chan int, 2)

// 因为 ch 是带缓冲的通道，我们可以同时发送两个数据
// 而不用立刻需要去同步读取数据
ch <- 1
ch <- 2

// 获取这两个数据 1 2
fmt.Println(<-ch)
```

### 遍历通道和关闭 range close()

```go
package main

import (
	"fmt"
)

func fibonacci(n int, c chan int) {
	x, y := 0, 1
	for i := 0; i < n; i++ {
		c <- x
		x, y = y, x+y
	}
	close(c)
}

func main() {
	c := make(chan int, 10)
	go fibonacci(cap(c), c)
	// range 函数遍历每个从通道接收到的数据，因为 c 在发送完 10 个
	// 数据之后就关闭了通道，所以这里我们 range 函数在接收到 10 个数据
	// 之后就结束了。如果上面的 c 通道不关闭，那么 range 函数就不
	// 会结束，从而在接收第 11 个数据的时候就阻塞了。
	for i := range c {
		fmt.Println(i)
	}
}
```

### defer

- 特性

1. 关键字 `defer` 用于注册延迟调用。
2. 这些调用直到 return 前才被执行。因此，可以用来做资源清理。
3. 多个 defer 语句，按先进后出的方式执行。
4. defer 语句中的变量，在 defer 声明时就决定了。

- 用途

1. 关闭文件句柄
2. 锁资源释放
3. 数据库连接释放

```go
package main

import "fmt"

func main() {
    var users [5]struct{}
    for i := range users {
        defer func() { fmt.Println(i) }()
    }
}

package main

import "fmt"

func main() {
    var users [5]struct{}
    for i := range users {
        defer Print(i)
    }
}
func Print(i int) {
    fmt.Println(i)
}
// 43210
```

## 参考资料 读入-求值-打印-循环(Read-Eval-Print-Loop) REPL

- [跟煎鱼学 Go](https://eddycjy.com/go-categories/)
- [Go 入门指南](https://github.com/unknwon/the-way-to-go_ZH_CN/)
- [Go 资料补给包](https://github.com/0voice/Introduction-to-Golang)
