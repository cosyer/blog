---
title: 【Mac 终端配置】iTerm2 + oh-my-zsh
tags:
  - 工具
copyright: true
comments: true
date: 2020-06-21 23:41:55
categories: 工具
photos:
---

## 安装 iterm2

- [官网下载](https://iterm2.com/)
  下载完，拖到应用程序里即可

## iterm2 配置配色方案

- 下载复制文件内容[](https://github.com/mbadolato/iTerm2-Color-Schemes/blob/master/schemes/
  Solarized%20Dark%20Higher%20Contrast.itermcolors)

- 保存为文件 SolarizedDarkHigherContrast.itermcolors，双击安装

- 打开 iTerm2 终端，依次在菜单栏选择：iTerm2 –> Preferences –> Profiles –> Colors –> Colors Presets –>
  SolarizedDarkHigherContrast

## 恢复 iterm2 默认设置

```bash
defaults delete com.googlecode.iterm2
```

## 前置校验

```bash
# 1、默认已安装 Homebrew、iTerm2
# 2、查看是否安装了zsh，查看是否返回 /usr/bin/zsh
cat /etc/shells
# 若未安装
brew install zsh

# iTerm2 启动项配置
chsh -s /bin/zsh      # 设置为zsh
chsh -s /bin/bash     # 设置为bash（Mac自带默认）
```

---

<!--more-->

## 安装 oh-my-zsh

```bash
# 方式一：wegt安装
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh

# 方式二：curl 安装
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# 方式三：手动安装
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

# 卸载
uninstall_oh_my_zsh zsh

# 更新
upgrade_oh_my_zsh

# 配置主题 默认robbyrussell 随机主题random
vim ~/.zshrc
ZSH_THEME="agnoster"
source ~/.zshrc

# 主题设置完成后，终端中却出现了乱码的字符 设置powerline字体
## 将 Powerline 字体文件下载到「下载」文件夹中
cd ~/Downloads && git clone https://github.com/powerline/fonts.git

## 将 Powerline 字体文件下载到「下载」文件夹中
cd fonts && ./install.sh

## 删除下载的字体文件
cd && rm -rf ~/Downloads/fonts

# 主题
ls ~/.oh-my-zsh/themes

# zsh配置环境变量
~/.zshrc

# 环境配置问题
用zsh 环境变量配置文件为 .zshrc

用bash 环境变量配置文件为 .bash_profile
```

## 卸载 oh-my-zsh

```js
进入到.oh-my-zsh/tools目录，执行shell命令 ./uninstall.sh
会提示不让执行shell命令

解决办法
输入 chmod +x uninstall.sh
然后再执行 ./uninstall.sh ，发现oh-my-zsh被卸载
最后删除.zshrc文件
```

## 安装 Powerline

```bash
# 若显示没有 pip,先安装pip
sudo easy_install pip

# 其他方法
# wget https://bootstrap.pypa.io/get-pip.py
# python get-pip.py

# 1、检测是否已经安装，若有版本信息则已安装
pip show powerline-status

# 2、将 powerline-status 安装在/usr/根目录中
pip install --user powerline-status

# 卸载
pip uninstall powerline-status

# 记录下location的安装路径 然后在.bash_profile文件加上启动脚本
. /Powerline安装路径/powerline/bindings/bash/powerline.sh

# 重载配置
source .bash_profile

# 报错的话`powerline/bindings/bash/../../../scripts/powerline-config:: No such file or directory`
# 原因没有将powerline的相关命令添加到环境变量，可以使用软链接解决
ln -s /Users/chenyu/Library/Python/2.7/bin/powerline /usr/local/bin
ln -s /Users/chenyu/Library/Python/2.7/bin/powerline-config /usr/local/bin
ln -s /Users/chenyu/Library/Python/2.7/bin/powerline-daemon /usr/local/bin

# 报错 write() failed: Bad file descriptor
powerline-daemon
```

## 设置字体

```bash
# 1、新建文件夹(如~/Desktop/OpenSource)，文件夹下
cd ~/Desktop/OpenSource
git clone https://github.com/powerline/fonts.git --depth=1
# 2、进入脚本目录
cd fonts
# 3、执行脚本
./install.sh

# 进入 iTerm2 -> Preferences -> Profiles -> Text -> Font -> Change Font
# 选择Meslo LG S for Powerfine, 常规， 12
```

## 设置配色方案

```bash
# 直接下载tar.zip包(包含全部配色)
# 进入 iTerm2 -> Preferences -> Profiles->Color
# 选择 Color Presets->import 选择解压好的目录下schemes目录中相应配色方案导入
```

## 安装 oh-my-zsh 主题

```bash
# 下载安装 agnoster 主题，将主题拷贝到oh my zsh的zsh中
cd ~/Desktop/OpenSource
git clone https://github.com/fcamblor/oh-my-zsh-agnoster-fcamblor.git
cd oh-my-zsh-agnoster-fcamblor/
./install

# 将 ZSH_THEME 值改为 agnoster，ecs 退出，:wq 保存
vi ~/.zshrc
```

## 安装插件

```bash
# ======================== 高亮插件 ========================
# 在 ~ 目录下新建文件夹 zsh-plugins(~/.zshrc 默认目录)
cd zsh-plugins
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git
vim .zshrc
# 文末添加以下配置
source ~/zsh-pludins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
cd ~/.oh-my-zsh/custom/plugins
vim .zshrc
# 文末添加以下配置
plugins=(zsh-syntax-highlighting)

# ======================== 自动补齐插件 ========================
cd zsh-plugins
http://mimosa-pudica.net/src/incr-0.2.zsh
# 将文件放到 ~/zsh-pludins/inrc下
vim .zshrc
source ~/.oh-my-zsh/plugins/incr/incr*.zsh
```

## homebrew 安装

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

- https://github.com/oldj/SwitchHosts
