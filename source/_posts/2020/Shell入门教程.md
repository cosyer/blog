---
title: Shell入门教程
tags:
  - shell
copyright: true
comments: true
date: 2020-03-23 01:51:18
categories: 工具
photos:
---

## 脚本运行

建立一个文本文件 demo，以.sh 结尾的或者不需要后缀都可以。

```shell
#!/bin/bash
NUM=10
printf "输出数字$NUM\n"
echo $NUM
```

通过 sh 或者 bash 命令运行脚本，sh scriptname 运行一个 Bash 脚本将会禁止所有 Bash 的扩展特性。

```shell
# 你能够运行它用命令
sh demo

# 另外也可以用bash来执行
bash demo

# 查看当前安装的所有shell
cat /etc/shells
```

脚本以"#!"行开头，行将会命令解释器(sh 或是 bash)。`#!/bin/rm` 当你运行这个脚本时，除了这个脚本消失了之外，你不会发现更多其他的东西。

## 注释

以#开头的行就是注释，会被解释器忽略。注释行前面也可以有空白字符。

```shell
# 这是一个注释
```

## 命令分隔符

分号;命令分割符，分割符允许在同一行里有两个或更多的命令。

```shell
echo hello; echo there         # 输出 hello 和 there
filename='cosyer'               # 变量文件名
if [ -x "$filename" ]; then    # 注意："if" and "then"需要分隔符
  echo "File $filename exists."; cp $filename $filename.bak
else
  echo "File $filename not found."; touch $filename
fi; echo "File test complete.
```

## 结束符

双分号;;，case 语句分支的结束符。

```shell
read Keypress
case "$Keypress" in
  [[:lower:]]   ) echo "Lowercase letter";;
  [[:upper:]]   ) echo "Uppercase letter";;
  [0-9]         ) echo "Digit";;
  *             ) echo "Punctuation, whitespace, or other";;
esac      #  允许字符串的范围出现在[]中,
          #+ 或者POSIX风格的[[中.
exit 0
```

---

<!--more-->

## 句号/圆点

作为一个文件名的组成部分.，当点.以一个文件名为前缀时，起作用使该文件变成了隐藏文件。这种隐藏文件 ls 一般是不会显示出来的。

作为目录名时，单个点（.）表示当前目录，两个点(..)表示上一级目录（或称为父目录）。

点(.)字符匹配。作为正则表达式的一部分,匹配字符时，单点（.）表示匹配任意一个字符。

## 引号

引号一个很重要的作用是保护命令行上的一个参数不被 shell 解释，而把此参数传递给要执行的程序来处理它。

```shell
echo "$(ls -al)"
```

### 单引号

```shell
str='this is a string'
```

单引号里的任何字符都会原样输出，单引号字符串中的变量是无效的。单引号字串中不能出现单引号（对单引号使用转义符后也不行）。

### 双引号

```shell
your_name='cosyer'
str="Hello, I know your are \"$your_name\"! \n"
echo $str
```

双引号里可以有变量，双引号里可以出现转义字符。

## 命令替换

命令替换"`"，将会重新分配一个命令甚至是多个命令的输出；它会将命令的输出如实地添加到另一个上下文中。

```shell
script_name=`basename cosyer`
echo "The name of this script is $script_name."

textfile_listing=`ls *`
# 变量中包含了当前工作目录下所有的*文件
echo $textfile_listing
```

## 操作符

### 赋值

变量赋值，初始化或改变一个变量的值，通用的变量赋值操作符，可以用于数值和字符串的赋值

```shell
var=27
category=minerals  # "="字符后面不能加空白字符.

# = 用于测试操作符
if [ "$string1" = "$string2" ]
# if [ "X$string1" = "X$string2" ] 会更安全,
# 它为了防止其中有一个字符串为空时产生错误信息.
# (增加的"X"字符可以互相抵消.)
then
   command
fi
```

### 计算操作符

| 操作符 | 描述 | 操作符 | 描述 | 操作符 | 描述 |
| ------ | ---- | ------ | ---- | ------ | ---- |
| `+`    | 加   | `/`    | 除   | `**`   | 求幂 |
| `-`    | 减   | `*`    | 乘   | `%`    | 求模 |

```shell
# Bash在版本2.02引入了"**"求幂操作符.
let "z=5**3"
echo "z = $z"   # z = 125

# 求模（它返回整数整除一个数后的余数）
let "y=5 % 3"
echo "y = $y"   # y = 2
```

| 操作符 | 描述                                                                       |
| ------ | -------------------------------------------------------------------------- |
| `+=`   | 加等(plus-equal) 把原变量值增加一个常量并重新赋值给变量                    |
| `-=`   | 减等(minus-equal) 把原变量值减少一个常量并重新赋值给变量                   |
| `*=`   | 乘等(times-equal) 把原变量值乘上一个常量并重新赋值给变量                   |
| `/=`   | 除等(slash-equal) 把原变量值除以一个常量并重新赋值给变量                   |
| `%=`   | 模等(mod-equal) 把原变量值除以一个常量整除（即取模）并重新赋余数的值给变量 |

```shell
let "var += 5" # 会使变量var值加了5并把值赋给var.
let "var *= 4" # 使变量var的值乘上4并把值赋给var.
```

### 位操作符

位操作符很少在脚本中使用。他们主要用于操作和测试从端口或 sockets 中读到的数据。“位运算”更多地用于编译型的语言，比如说 C 和 C++，它们运行起来快地像飞。

| 操作符 | 描述                         | 操作符 | 描述     |
| ------ | ---------------------------- | ------ | -------- | -------- |
| `<<`   | 位左移（每移一位相当乘以 2） | `      | `        | 位或     |
| `<<=`  | 位左移赋值                   | `      | =`       | 位或赋值 |
| `>>`   | 位右移（每移一位相当除以 2） | `~`    | 位反     |
| `>>=`  | "位右移赋值"（和<<=相反）    | `!`    | 位非     |
| `&`    | 位与                         | `^`    | 位或     |
| `&=`   | 位于赋值                     | `^=`   | 位或赋值 |

```shell
# <<=
# "位左移赋值"
let "var <<= 2" 结果使var的二进制值左移了二位（相当于乘以4）
```

### 逻辑操作符

逻辑与`&&`

```shell
if [ $condition1 ] && [ $condition2 ]
# 等同于:  if [ $condition1 -a $condition2 ]
# 如果condition1和condition2都为真则返回真...
fi;

if [[ $condition1 && $condition2 ]]    # Also works.
# 注意&&操作不能在[ ... ]结构中使用.
fi;
```

逻辑或`||`

```shell
if [ $condition1 ] || [ $condition2 ]
# 等同于:  if [ $condition1 -o $condition2 ]
# 如果condition1和condition2有一个为真则返回真...
fi;
if [[ $condition1 || $condition2 ]]    # Also works.
# 注意||操作不能在[ ... ]结构中使用.
fi;
```

使用&&和||进行混合条件测试。在算术计算的环境中，&&和||操作符也可以使用。

```shell
echo $(( 1 && 2 )) $((3 && 0)) $((4 || 0)) $((0 || 0))
# 1 0 1 0
```

### 逗号操作符

逗号`,`操作符连接两个或更多的算术操作。所有的操作都被求值(可能会有副作用)，但只返回最后一个操作的结构。

```shell
let "t1 = ((5 + 3, 7 - 1, 15 - 4))"
echo "t1 = $t1"               # t1 = 11

let "t2 = ((a = 9, 15 / 3))"  # 初始化"a"并求"t2"的值.
echo "t2 = $t2    a = $a"     # t2 = 5    a = 9
```

## 变量

变量，是脚本编程中的如何进行数据表现的办法。它们可以在算术计算中作为操作数，在一个字符串表达式中作为符号表达抽象的意义或是其他的其它意义。变量是表示计算机内存中保存一种数据需要占的一个位置或一组的位置的标识。

### 变量值

如果 variable1 是一个变量的名字，那么$variable1 就是引用这个变量的值――即这个变量它包含的数据。

```shell
t1=12
echo $t1
```

一个未初始化的变量有一个”null”值――表示从没有被赋值过（注意 null 值不等于零）。在一个变量从未赋值之前就使用它通常会引起问题。然而，仍然有可能在执行算术计算时使用一个未初始化的变量。

```shell
echo "$uninitialized"      # (blank line)
let "uninitialized += 5"   # Add 5 to it.
echo "$uninitialized"      # 5

#  结论:
#  一个未初始化的变量没有值，
#  但是似乎它在算术计算中的值是零。
#  这个无法证实（也可能是不可移植）的行为。
```

### 定义变量

```shell
# 变量名不加美元符号
your_var="elaine"
# 重新定义
your_var="newname"
```

**注意 ⚠️**

1. 首个字符必须为字母（a-z，A-Z）。
1. 中间不能有空格，可以使用下划线（\_），等号左右也不能有空格。
1. 不能使用标点符号。
1. 不能使用 bash 里的关键字（可用 help 命令查看保留关键字）。

### 只读变量

```shell
#!/bin/bash
github="https://cosyer.github.io"
readonly github
github="https://github.com"

# 运行脚本，结果如下：
/bin/sh: NAME: This variable is read only.
```

### 使用变量

```shell
your_var="github"
echo $your_var
echo ${your_var}
echo "your name is ${your_var}-l"
```

### 删除变量 unset

变量被删除后不能再次使用。unset 命令不能删除只读变量。

```shell
myUrl="https://jaywcjlove.github.io"
unset myUrl
echo $myUrl
```

### 变量类型

不同与许多其他的编程语言，Bash 不以"类型"来区分变量。本质上来说，Bash 变量是字符串，但是根据环境的不同，Bash 允许变量有整数计算和比较。其中的决定因素是变量的值是不是只含有数字。

1. **局部变量** 局部变量在脚本或命令中定义，仅在当前 shell 实例中有效，其他 shell 启动的程序不能访问局部变量。
2. **环境变量** 所有的程序，包括 shell 启动的程序，都能访问环境变量，有些程序需要环境变量来保证其正常运行。必要的时候 shell 脚本也可以定义环境变量。
3. **shell 变量** shell 变量是由 shell 程序设置的特殊变量。shell 变量中有一部分是环境变量，有一部分是局部变量，这些变量保证了 shell 的正常运行

### 内部变量

| 内部变量          | 说明                                                                                                                       |
| ----------------- | -------------------------------------------------------------------------------------------------------------------------- |
| $BASH             | Bash 二进制程序文件的路径                                                                                                  |
| $BASH_ENV         | 该环境变量保存一个 Bash 启动文件路径，当启动一个脚本程序时会去读该环境变量指定的文件。                                     |
| $BASH_SUBSHELL    | 一个指示子 shell(subshell)等级的变量。它是 Bash 版本 3 新加入的。                                                          |
| $BASH_VERSINFO[n] | 这个数组含有 6 个元素，指示了安装的 Bash 版本的信息。它和$BASH_VERSION 相似，但它们还是有一些小小的不同。                  |
| $BASH_VERSION     | 安装在系统里的 Bash 版本。                                                                                                 |
| $DIRSTACK         | 在目录堆栈里面最顶端的值(它受 pushd 和 popd 的控制)                                                                        |
| $EDITOR           | 由脚本调用的默认的编辑器，一般是 vi 或是 emacs。                                                                           |
| $EUID             | 有效用户 ID                                                                                                                |
| $FUNCNAME         | 当前函数的名字                                                                                                             |
| $GLOBIGNORE       | 由通配符(globbing)扩展的一列文件名模式。                                                                                   |
| $GROUPS           | 目前用户所属的组                                                                                                           |
| $HOME             | 用户的家目录，通常是/home/username                                                                                         |
| $HOSTNAME         | 在系统启动时由一个初始化脚本中用 hostname 命令给系统指派一个名字。然而，gethostname()函数能设置 Bash 内部变量 E$HOSTNAME。 |
| $HOSTTYPE         | 机器类型，像$MACHTYPE 一样标识系统硬件。                                                                                   |
| $IFS              | 内部字段分隔符                                                                                                             |
| $IGNOREEOF        | 忽略 EOF：在退出控制台前有多少文件结尾标识（end-of-files,control-D）会被 shell 忽略。                                      |
| $LC_COLLATE       | 它常常在.bashrc 或/etc/profile 文件里被设置，它控制文件名扩展和模式匹配的展开顺序。                                        |
| $LINENO           | 这个变量表示在本 shell 脚本中该变量出现时所在的行数。它只在脚本中它出现时有意义，它一般可用于调试。                        |
| $MACHTYPE         | 机器类型，识别系统的硬件类型。                                                                                             |
| $OLDPWD           | 上一次工作的目录("OLD-print-working-directory",你上一次进入工作的目录)                                                     |
| $TZ               | 时区                                                                                                                       |
| $MAILCHECK        | 每隔多少秒检查是否有新的信件                                                                                               |
| $OSTYPE           | 操作系统类型                                                                                                               |
| $MANPATH man      | 指令的搜寻路径                                                                                                             |
| $PATH             | 可执行程序文件的搜索路径。一般有/usr/bin/, /usr/X11R6/bin/, /usr/local/bin,等等。                                          |
| $PIPESTATUS       | 此数组变量保存了最后执行的前台管道的退出状态。相当有趣的是，它不一定和最后执行的命令的退出状态一样。                       |
| $PPID             | 一个进程的$PPID 变量保存它的父进程的进程 ID(pid)。用这个变量和 pidof 命令比较。                                            |
| $PROMPT_COMMAND   | 这个变量在主提示符前($PS1 显示之前)执行它的值里保存的命令。                                                                |
| $PS1              | 这是主提示符（第一提示符），它能在命令行上看见。                                                                           |
| $PS2              | 副提示符（第二提示符），它在期望有附加的输入时能看见。它显示像">"的提示。                                                  |
| $PS3              | 第三提示符。它在一个 select 循环里显示 (参考例子 10-29)。                                                                  |
| $PS4              | 第四提示符，它在用-x 选项调用一个脚本时的输出的每一行开头显示。它通常显示像"+"的提示。                                     |
| $PWD              | 工作目录(即你现在所处的目录) ，它类似于内建命令 pwd。                                                                      |
| $REPLY            | 没有变量提供给 read 命令时的默认变量．这也适用于 select 命令的目录，但只是提供被选择的变量项目编号而不是变量本身的值。     |
| $SECONDS          | 脚本已运行的秒数。                                                                                                         |
| $SHELLOPTS        | 已经激活的 shell 选项列表，它是一个只读变量。                                                                              |
| $SHLVL            | SHELL 的嵌套级别．指示了 Bash 被嵌套了多深．在命令行里，$SHLVL 是 1，因此在一个脚本里，它是 2                              |
| $TMOUT            | 如果$TMOUT 环境变量被设为非零值时间值 time，那么经过 time 这么长的时间后，shell 提示符会超时．这将使此 shell 退出登录      |
| $UID              | 用户 ID 号，这是当前用户的用户标识号，它在/etc/passwd 文件中记录。                                                         |

### 位置参数

| 参数处理 | 说明                                                                                                                |
| -------- | ------------------------------------------------------------------------------------------------------------------- |
| `$#`     | 传递到脚本的参数个数                                                                                                |
| `$*`     | 以一个单字符串显示所有向脚本传递的参数。如"∗"用「"」括起来的情况、以"1 2…n"的形式输出所有参数。                     |
| `$$`     | 脚本运行的当前进程 ID 号                                                                                            |
| `$!`     | 后台运行的最后一个进程的 ID 号                                                                                      |
| `$@`     | 与 ∗ 相同，但是使用时加引号，并在引号中返回每个参数。如"@"用「"」括起来的情况、以"1""2" … "$n" 的形式输出所有参数。 |
| `$-`     | 显示 Shell 使用的当前选项，与 set 命令功能相同。                                                                    |
| `$?`     | 显示最后命令的退出状态。0 表示没有错误，其他任何值表明有错误。                                                      |

### 字串移动

`${string#substring}`从$string左边开始，剥去最短匹配$substring 子串。  
`${string##substring}`从$string左边开始，剥去最长匹配$substring 子串。  
`${string%substring}` 从$string结尾开始，剥去最短匹配$substring 子串。  
`${string%%substring}`从$string结尾开始，剥去最长匹配$substring 子串。

```shell
String=abcABC123ABCabc
#       ├----┘     ┆
#       └----------┘

echo ${String#a*C}      # 123ABCabc
# 剥去匹配'a'到'C'之间最短的字符串.

echo ${String##a*C}     # abc
# 剥去匹配'a'到'C'之间最长的字符串.


String=abcABC123ABCabc
#       ┆           ||
#       └------------┘

echo ${String%b*c}      # abcABC123ABCa
# 从$String后面尾部开始，剥去匹配'a'到'C'之间最短的字符串.

echo ${String%%b*c}     # a
# 从$String后面尾部开始，剥去匹配'a'到'C'之间最长的字符串.
```

### 用 awk 处理字符串

Bash 脚本可以调用 awk 的字符串操作功能来代替它自己内建的字符串操作符

```shell
String=23skidoo1
#      012345678    Bash
#      123456789    awk
# 注意上面两个程序对索引的不同处理:
# Bash把字符串的第一个字符的标号称为'0'。
# Awk把字符串的第一个字符的标号称为'1'。

echo ${String:2:4} # position 3 (0-1-2), 4 characters long
                                         # skid

# 在awk中与Bash的${string:pos:length}等同的是substr(string,pos,length)。
echo | awk '{
  print substr("'"${String}"'",3,4)      # skid
}'
#  用一个空的"echo"由管道传一个空的输入给awk,
#+ 这样就不必提供一个文件名给awk。
exit 0
```

## for/while

重复一些命令的代码块,如果条件不满足就退出循环。

### for

在循环的每次执行中，arg 将顺序的存取 list 中列出的变量，下面是一个基本的循环结构。

> for arg in [list]  
> do  
>  command(s)...  
> done

每个`[list]`中的元素都可能包含多个参数，在处理参数组时，这是非常有用的，使用 set 命令来强制解析每个`[list]`中的元素。并且分配每个解析出来的部分到一个位置参数中。

循环的一个简单例子

```shell
for planet in Mercury Venus Earth Mars Jupiter Saturn Uranus Neptune Pluto
do
  echo $planet  # 每个行星被单独打印在一行上.
done
```

### while

一个 while 循环可以有多个判断条件，但是只有最后一个才能决定是否退出循环。然而这需要一种有点不同的循环语法。

> while [condition]  
> do  
>  command...  
> done

```shell
# --------------------------
# 简单的while循环
# --------------------------
var0=0
LIMIT=10

while [ "$var0" -lt "$LIMIT" ]
do
  echo -n "$var0 "        # -n 将会阻止产生新行。
  #             ^           空格,数字之间的分隔。
  var0=`expr $var0 + 1`   # var0=$(($var0+1))  也可以。
                          # var0=$((var0 + 1)) 也可以。
                          # let "var0 += 1"    也可以。
done                      # 使用其他的方法也行。
# --------------------------
# 多条件的while循环
# --------------------------
var1=unset
previous=$var1

while echo "previous-variable = $previous"
      echo
      previous=$var1
      [ "$var1" != end ] # 记录之前的$var1.
      # 这个"while"循环中有4个条件, 但是只有最后一个能控制循环.
      # 退出状态由第4个条件决定.
do
echo "Input variable #1 (end to exit) "
  read var1
  echo "variable #1 = $var1"
done
exit 0
```

### until

这个结构在循环的顶部判断条件，并且如果条件一直为 false 那就一直循环下去。(与 while 相反)。

> until [condition-is-true]  
> do  
>  command...  
> done

**注意 ⚠️**

1. until 循环的判断在循环的顶部，这与某些编程语言是不同的。
2. 与 for 循环一样，如果想把 do 和条件放在一行里，就使用";"。

> until [condition-is-true] ; do

```shell
END_CONDITION=end
until [ "$var1" = "$END_CONDITION" ]
# 在循环的顶部判断条件.
do
  echo "Input variable #1 "
  echo "($END_CONDITION to exit)"
  read var1
  echo "variable #1 = $var1"
done
exit 0
```

### 嵌套循环

嵌套循环就是在一个循环中还有一个循环，内部循环在外部循环体中。

```shell
outer=1             # 设置外部循环计数.
# 开始外部循环.
for a in 1 2 3 4 5
do
  echo "Pass $outer in outer loop."
  echo "---------------------"
  inner=1           # 重设内部循环的计数.

  # ===============================================
  # 开始内部循环.
  for b in 1 2 3 4 5
  do
    echo "Pass $inner in inner loop."
    let "inner+=1"  # 增加内部循环计数.
  done
  # 内部循环结束.
  # ===============================================

  let "outer+=1"    # 增加外部循环的计数.
  echo              # 每次外部循环之间的间隔.
done
# 外部循环结束.

exit 0
```

### 循环控制

影响循环行为的命令 `break`， `continue`， break 命令将会跳出循环，continue 命令将会跳过本次循环下边的语句，直接进入下次循环。

**continue：** continue 命令与 break 命令类似，只有一点差别，它不会跳出所有循环，仅仅跳出当前循环。

```shell
LIMIT=19  # 上限

echo "Printing Numbers 1 through 20 (but not 3 and 11)."

a=0

while [ $a -le "$LIMIT" ]
do
  a=$(($a+1))
  if [ "$a" -eq 3 ] || [ "$a" -eq 11 ]  # Excludes 3 and 11.
  then
    continue      # 跳过本次循环剩下的语句.
  fi
  echo -n "$a "   # 在$a等于3和11的时候,这句将不会执行.
done
```

**break：** break 命令允许跳出所有循环（终止执行后面的所有循环）。

下面的例子中，脚本进入死循环直至用户输入数字大于 5。要跳出这个循环，返回到 shell 提示符下，就要使用 break 命令。

```shell
while :
do
    echo -n "Input a number between 1 to 5: "
    read aNum
    case $aNum in
        1|2|3|4|5) echo "Your number is $aNum!"
        ;;
        *) echo "You do not select a number between 1 to 5, game is over!"
            break
        ;;
    esac
done
```

⚠️ 在嵌套循环中，break 命令后面还可以跟一个整数，表示跳出第几层循环。例如：

```shell
break n #表示跳出第 n 层循环。
```

## case/select

case/select 依靠在代码块的顶部或底部的条件判断来决定程序的分支。

### case

case 它允许通过判断来选择代码块中多条路径中的一条。它的作用和多个 if/then/else 语句相同，是它们的简化结构，特别适用于创建目录。

> case "$variable" in   
>   ?"$condition1" )  
>  ?command...  
>  ?;;  
>  ?"$condition2" )  
>  ?command...  
>  ?;;  
> esac

- 对变量使用`""`并不是强制的，因为不会发生单词分离。
- 每句测试行，都以右小括号`)`结尾。
- 每个条件块都以两个分号结尾`;;`。
- case 块的结束以 esac(case 的反向拼写)结尾。

```shell
clear # 清屏.

echo "          我的简历"
echo "          ------- "
echo "下面通过shell脚本输出我的简历"
echo
echo "[B]asicinfo, 基本信息"
echo "[E]ducation, 教育经历"
echo "[I]tskill, IT 技能"
echo
read person
case "$person" in
# 注意,变量是被引用的.
  "B" | "b" )
  # 接受大写或小写输入.
  echo
  echo "小弟调调"
  echo "手  机 : 136*****13"
  echo "E-mail :wowohoo@qq.com"
  echo "首  页 : http://JSLite.io"
  ;;
  # 注意,在每个选项后边都需要以;;结尾.

  "E" | "e" )
  # 接受大写或小写输入.
  echo "■ 2003年9月 到 2006年8月"
  echo "----------------------------"
  echo "› 学校 : 野鸟高中"
  echo "› 专业 : 艺术类"
  echo "› 学历 : 高中"
  ;;
  # 后边的[I]tskill的信息在这里就省略了.
          * )
   # 默认选项.
   # 空输入(敲RETURN).
   echo
   echo "没有数据！"
  ;;
esac
exit 0
```

### select

select 结构是建立菜单的另一种工具，这种结构是从 ksh 中引入的。

> select variable [in list]  
> do  
>  ?command...  
>  ?break  
> done

用 select 来创建菜单

```shell
PS3='选择你喜欢的蔬菜: ' # 设置提示符字串.

echo
select vegetable in "豆" "胡萝卜" "土豆" "洋葱" "芜菁甘蓝"
do
  echo
  echo "你最喜欢的蔬菜是 $vegetable 。"
  echo "讨厌!"
  echo
  break  # 如果这里没有'break'会发生什么?
done
exit 0
```

如果忽略了 in list 列表,那么 select 命令将使用传递到脚本的命令行参数($@),或者是函数参数(当 select 是在函数中时）与忽略 in list 时的 for 语句相比较：**for variable [in list]**

```shell
PS3='选择你喜欢的蔬菜:  '
echo
choice_of(){
  select vegetable
  # [in list] 被忽略, 所以'select'用传递给函数的参数.
  do
    echo
    echo "你最喜欢的蔬菜是  $vegetable。"
    echo "讨厌!"
    echo
    break
  done
}

choice_of "豆" "米饭" "胡萝卜" "土豆" "洋葱" "芜菁甘蓝"
#         $1   $2     $3      $4    $5     $6
#         传递给choice_of() 函数的参数

exit 0
```

## 函数

和"真正的"编程语言一样，Bash 也有函数，虽然在某些实现方面稍有些限制。 一个函数是一个子程序，用于实现一串操作的代码块(code block)，它是完成特定任务的"黑盒子"。 当有重复代码，当一个任务只需要很少的修改就被重复几次执行时, 这时你应考虑使用函数。

```shell
function function_name {
  command...
}
# 或
function_name () {
  command...
}
```

在一个函数内嵌套另一个函数也是可以的，但是不常用。

```shell
f1 (){
  f2 (){ # nested
    echo "Function \"f2\", inside \"f1\"."
  }
}
f2  #  引起错误.
    #  就是你先"declare -f f2"了也没用.

f1  #  什么也不做,因为调用"f1"不会自动调用"f2".
f2  #  现在,可以正确的调用"f2"了,
    #+ 因为之前调用"f1"使"f2"在脚本中变得可见了.
```

### 局部变量

如果变量用 local 来声明，那么它只能在该变量声明的代码块(block of code)中可见，这个代码块就是局部"范围"。

```shell
# 在函数内部的全局和局部变量.
func ()
{
  local loc_var=23       # 声明为局部变量.
  echo                   # 使用内建的'local'关键字.
  echo "\"loc_var\" in function = $loc_var"
  global_var=999         # 没有声明为局部变量.
                         # 默认为全局变量.
  echo "\"global_var\" in function = $global_var"
}

func
# 现在，来看看是否局部变量"loc_var"能否在函数外面可见.
echo "\"loc_var\" outside function = $loc_var"
                                   # $loc_var outside function =
                                   # 不, $loc_var不是全局可访问的.
echo "\"global_var\" outside function = $global_var"
                                      # $global_var outside function = 999
                                      # $global_var 是全局可访问的.
exit 0
#  与In contrast to C相比, 在函数内声明的Bash变量只有在
#+ 它被明确声明成局部的变量时才是局部的
```

⚠️ ：在函数调用之前，所有在函数内声明且没有明确声明为 local 的变量都可在函数体外可见

```shell
func (){
  global_var=37    #  在函数还没有被调用前
                   #+ 变量只在函数内可见.
}                  #  函数结束
echo "global_var = $global_var"  # global_var =
                                 #  函数"func"还没有被调用,
                                 #+ 所以变量$global_var还不能被访问.
func
echo "global_var = $global_var"  # global_var = 37
                                 # 已经在函数调用时设置了值.
```

### 函数参数

在 Shell 中，调用函数时可以向其传递参数。在函数体内部，通过 `$n` 的形式来获取参数的值，例如，$1 表示第一个参数，$2 表示第二个参数

```shell
funWithParam(){
    echo "第一个参数为 $1 !"
    echo "第二个参数为 $2 !"
    echo "第十个参数为 $10 !"
    echo "第十个参数为 ${10} !"
    echo "第十一个参数为 ${11} !"
    echo "参数总数有 $# 个!"
    echo "作为一个字符串输出所有参数 $* !"
}
funWithParam 1 2 3 4 5 6 7 8 9 34 73
```

### 函数返回值

定义一个带有 return 语句的函数。函数返回值在调用该函数后通过 `$?` 来获得。

```shell
funWithReturn(){
    echo "这个函数会对输入的两个数字进行相加运算..."
    echo "输入第一个数字: "
    read aNum
    echo "输入第二个数字: "
    read anotherNum
    echo "两个数字分别为 $aNum 和 $anotherNum !"
    return $(($aNum+$anotherNum))
}
funWithReturn
echo "输入的两个数字之和为 $? !"

# 这个函数会对输入的两个数字进行相加运算...
# 输入第一个数字:
# 1
# 输入第二个数字:
# 2
# 两个数字分别为 1 和 2 !
# 输入的两个数字之和为 3 !
```

⚠️ `$10` 不能获取第十个参数，获取第十个参数需要${10}。当n>=10时，需要使用${n}来获取参数。

**特殊字符用来处理参数：**

| 参数处理 | 说明                                                           |
| -------- | -------------------------------------------------------------- |
| $#       | 传递到脚本的参数个数                                           |
| $\*      | 以一个单字符串显示所有向脚本传递的参数                         |
| $$       | 脚本运行的当前进程 ID 号                                       |
| $!       | 后台运行的最后一个进程的 ID 号                                 |
| $@       | 与$\*相同，但是使用时加引号，并在引号中返回每个参数。          |
| $-       | 显示 Shell 使用的当前选项，与 set 命令功能相同。               |
| $?       | 显示最后命令的退出状态。0 表示没有错误，其他任何值表明有错误。 |

## 测试

### 测试结构

一个 if/then 结构能包含嵌套的比较和测试。

```shell
echo "Testing \"false\""
if [ "false" ]              #  "false"是一个字符串.
then
  echo "\"false\" is true." #+ 它被测试为真.
else
  echo "\"false\" is false."
fi            # "false"为真.
```

Else if 和 elif

elif 是 else if 的缩写。作用是在一个 if/then 里嵌入一个内部的 if/then 结构。

`[[]]`结构比 Bash 版本的`[]`更通用。用`[[ ... ]]`测试结构比用`[ ... ]`更能防止脚本里的许多逻辑错误。比如说，`&&`,`||`,`<`和`>`操作符能在一个`[[]]`测试里通过，但在`[]`结构会发生错误。

`(( ))`结构扩展并计算一个算术表达式的值。如果表达式值为 0，会返回 1 或假作为退出状态码。一个非零值的表达式返回一个 0 或真作为退出状态码。这个结构和先前 test 命令及`[]`结构的讨论刚好相反。

### 文件测试操作符

如果下面的条件成立返回真。

| 操作符    | 描述                                                                |
| --------- | ------------------------------------------------------------------- |
| -e        | 文件存在                                                            |
| -a        | 文件存在，这个和-e 的作用一样. 它是不赞成使用的，所以它的用处不大。 |
| -f        | 文件是一个普通文件(不是一个目录或是一个设备文件)                    |
| -s        | 文件大小不为零                                                      |
| -d        | 文件是一个目录                                                      |
| -b        | 文件是一个块设备(软盘，光驱，等等。)                                |
| -c        | 文件是一个字符设备(键盘，调制解调器，声卡，等等。)                  |
| -p        | 文件是一个管道                                                      |
| -h        | 文件是一个符号链接                                                  |
| -L        | 文件是一个符号链接                                                  |
| -S        | 文件是一个 socket                                                   |
| -t        | 文件(描述符)与一个终端设备相关。                                    |
| -r        | 文件是否可读 (指运行这个测试命令的用户的读权限)                     |
| -w        | 文件是否可写 (指运行这个测试命令的用户的读权限)                     |
| -x        | 文件是否可执行 (指运行这个测试命令的用户的读权限)                   |
| -g        | 文件或目录的设置-组-ID(sgid)标记被设置。                            |
| -u        | 文件的设置-用户-ID(suid)标志被设置                                  |
| -k        | 粘住位设置                                                          |
| -N        | 文件最后一次读后被修改                                              |
| f1 -nt f2 | 文件 f1 比 f2 新                                                    |
| f1 -ot f2 | 文件 f1 比 f2 旧                                                    |
| f1 -ef f2 | 文件 f1 和 f2 是相同文件的硬链接                                    |
| !         | "非" -- 反转上面所有测试的结果(如果没有给出条件则返回真)。          |

**注意 ⚠️**

1. `-t` 这个测试选项可以用于检查脚本中是否标准输入 ([ -t 0 ])或标准输出([ -t 1 ])是一个终端。
1. `-g` 如果一个目录的 sgid 标志被设置，在这个目录下创建的文件都属于拥有此目录的用户组，而不必是创建文件的用户所属的组。这个特性对在一个工作组里的同享目录很有用处。

### 比较操作符

二元比较操作符比较两个变量或是数值。注意整数和字符串比较的分别。

**整数比较**

| 比较操作符 | 描述                      | 例子                   |
| ---------- | ------------------------- | ---------------------- |
| `-eq`      | 等于                      | `if [ "$a" -eq "$b" ]` |
| `-ne`      | 不等于                    | `if [ "$a" -ne "$b" ]` |
| `-gt`      | 大于                      | `if [ "$a" -gt "$b" ]` |
| `-ge`      | 大于等于                  | `if [ "$a" -ge "$b" ]` |
| `-lt`      | 小于                      | `if [ "$a" -lt "$b" ]` |
| `-le`      | 小于等于                  | `if [ "$a" -le "$b" ]` |
| `<`        | 小于(在双括号里使用)      | `(("$a" < "$b"))`      |
| `<=`       | 小于等于 (在双括号里使用) | `(("$a" <= "$b"))`     |
| `>`        | 大于 (在双括号里使用)     | `(("$a" > "$b"))`      |
| `>=`       | 大于等于(在双括号里使用)  | `(("$a" >= "$b"))`     |

**字符串比较**

| 比较操作符 | 描述                                                            | 例子                                         |
| ---------- | --------------------------------------------------------------- | -------------------------------------------- |
| =          | 等于                                                            | `if [ "$a" = "$b" ]`                         |
| ==         | 等于，它和=是同义词。                                           | `if [ "$a" == "$b" ]`                        |
| !=         | 不相等，操作符在[[...]]结构里使用模式匹配.                      | `if [ "$a" != "$b" ]`                        |
| <          | 小于，依照 ASCII 字符排列顺序，注意"<"字符在[ ] 结构里需要转义  | `if [[ "$a" < "$b" ]]` `if [ "$a" \< "$b" ]` |
| >          | 大于，依照 ASCII 字符排列顺序，注意">"字符在[ ] 结构里需要转义. | `if [[ "$a" > "$b" ]]` `if [ "$a" \> "$b" ]` |
| -z         | 字符串为"null"，即是指字符串长度为零。                          | -                                            |
| -n         | 字符串不为"null"，即长度不为零。                                | -                                            |

**混合比较**

| 比较操作符 | 描述                                                             | 例子                        |
| ---------- | ---------------------------------------------------------------- | --------------------------- |
| -a         | 逻辑与，如果 exp1 和 exp2 都为真，则 exp1 -a exp2 返回真。       | `if [ "$exp1" -a "$exp2" ]` |
| -o         | 逻辑或，只要 exp1 和 exp2 任何一个为真，则 exp1 -o exp2 返回真。 | `if [ "$exp1" -o "$exp2" ]` |

在一个混合测试中，把一个字符串变量引号引起来可能还不够。如果$string变量是空的话，表达式`[ -n "$string" -o "$a" = "$b" ]`在一些Bash版本中可能会引起错误。安全的办法是附加一个外部的字符串给可能有空字符串变量比较的所有变量，`[ "x$string" != x -o "x$a" = "x$b" ]` (x 字符可以互相抵消)

## 操作字符串

Bash 已经支持了令人惊讶的字符串操作的数量。不一致的命令语法和冗余的功能，导致真的学起来有困难。

### 字符串长度

```shell
String=abcABC123ABCabc

echo ${#String}                 # 15
echo `expr length $String`      # 15
echo `expr "$String" : '.*'`    # 15
```

匹配字符串开头的字串的长度，下面两种方法的 $substring 是一个正则表达式。

`expr match "$string" '$substring'`  
`expr "$string" : '$substring'`

```shell
String=abcABC123ABCabc
#       └------┘
#
echo `expr match "$String" 'abc[A-Z]*.2'`   # 8
echo `expr "$String" : 'abc[A-Z]*.2'`       # 8
```

### 索引

`expr index $string $substring` 在字符串$string中$substring 第一次出现的数字位置

```shell
String=abcABC123ABCabc
echo `expr index "$String" C12`             # 6
                                             # C 字符的位置.

echo `expr index "$String" 1c`              # 3
# 'c' (in #3 position) matches before '1'.
```

### 字串提取

`${string:position}` 把$string中从第$postion 个字符开始字符串提取出来。如果$string是"*"或"@"，则表示从位置参数中提取第$postion 后面的字符串。  
`${string:position:length}` 把$string中$postion 个字符后面的长度为$length 的字符串提取出来。

```shell
# 字串提取
String=abcABC123ABCabc
#       0123456789.....
#       以0开始计算.

echo ${String:0}                            # abcABC123ABCabc
echo ${String:1}                            # bcABC123ABCabc
echo ${String:7}                            # 23ABCabc
echo ${String:7:3}                          # 23A
                                            # 提取的字串长为3

# 有没有可能从字符串的右边结尾处提取?

echo ${String:-4}                           # abcABC123ABCabc
# 默认是整个字符串，就相当于${parameter:-default}.
# 然而. . .

echo ${String:(-4)}                         # Cabc
echo ${String: -4}                          # Cabc
# 这样,它可以工作了.
# 圆括号或附加的空白字符可以转义$position参数.
```

## 转义字符

在单个字符前面的转义符`\`告诉 shell 不必特殊解释这个字符，只把它当成字面上的意思。但在一些命令和软件包里，比如说 echo 和 sed,转义一个字符可能会引起一个相反的效果－－因为它们可能触发那个字符的特殊意思。

`\r` 回车  
`\n` 换行  
`\c` 不换行  
`\t` 水平制表符  
`\v` 垂直制表符  
`\a` 表示“警告”（蜂鸣或是闪动）  
`\\` 反斜杠字符  
`\0ddd` 将自负表示成 1 到 3 的八进制数值

## 退出/退出状态

`$?` 变量用于测试脚本中的命令执行结果非常的有用。

```shell
echo hello
echo $?    # 因为上一条命令执行成功，打印0。

lskdf      # 无效命令。
echo $?    # 因为上面的无效命令执行失败，打印一个非零的值。

exit 113   # 返回113状态码给shell。
           # 可以运行脚本结束后立即执行命令"echo $?" 检验。

#  依照惯例,命令'exit 0'表示执行成功,
#  当产生一个非零退出值时表示一个错误或是反常的条件。
```

### 变量间接引用

假设一个变量的值是第二个变量的名字。这样要如何才能从第一个变量处重新获得第二个变量的值？例如，`a=letter_of_alphabet`和`letter_of_alphabet=z`，是否能由 a 引用得到 z ? 这确实可以办到，这种技术被称为间接引用。

```shell
a=letter_of_alphabet   # 变量"a"保存着另外一个变量的名字.
letter_of_alphabet=z
# 直接引用.
echo "a = $a"          # a = letter_of_alphabet

# 间接引用.
eval a=\$$a
echo "Now a = $a"      # 现在 a = z
exit 0
```

### 双括号结构

用`((...))`结构来使用 C 风格操作符来处理变量。[demo26](./example/demo26)

```shell
(( a = 23 ))  # 以C风格来设置一个值，在"="两边可以有空格.
echo "a (initial value) = $a"

(( a++ ))     # C风格的计算后自增.
echo "a (after a++) = $a"

(( a-- ))     # C风格的计算后自减.
echo "a (after a--) = $a"


(( ++a ))     # C风格的计算前自增.
echo "a (after ++a) = $a"

(( --a ))     # C风格的计算前自减.
echo
```

## 参考文档

- [Bash 脚本教程](https://wangdoc.com/bash/index.html)
