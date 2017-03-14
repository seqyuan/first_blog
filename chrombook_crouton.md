Title: Chromebook Install Crouton in china
Date: 2017-03-13
Category: chromebook
Tags: crouton
Slug: Chromebook Install Crouton in china
Author: seqyuan
Summary: ASUS Chromebook C202通过crouton安装linux


在 Chromebook 上面安装 Linux 发行版有2种方法：

crouton：https://github.com/dnschneid/crouton

ChrUbuntu：https://github.com/iantrich/ChrUbuntu-Guides

crouton 是比较流行的安装方法，主要特点如下：

- 可保留数据，不需要格式化
- 方便切换（热切换）
- 卸载方便（直接删除目录即可）
- 需要科学上网
- 每次 Chrome OS 升级后需要更新一下

一般crouton的安装教程从网上都能找到，但是真正安装的时候总会出现各种问题导致安装不成功，也许你会遇到同样的问题。下面的教程是我失N多总结的经验。

#Install crouton

##开启开发者模式
如果你决定要通过 crouton 的方式安装Linux 发行版，你需要：

一个已经开启开发者模式的 ChromeBook（关于开启开发者模式网上有很多教程，这里不另外叙述）

有充足的电量

良好的网络环境

##下载 crouton
从github打下载crouton，网址：https://github.com/dnschneid/crouton

下载后解压

##修改crouton

更改解压后的crouton中targets/audio文件:

第47行：
```
( wget -O "$archive" "$urlbase/$ADHD_HEAD.tar.gz" 2>&1 \
                                    || echo "Error fetching CRAS" ) | tee "$log"
```
改为：

```
( wget -O "$archive" "http://t.cn/R46YOzM" 2>&1 \
                                    || echo "Error fetching CRAS" ) | tee "$log"
```
##make crouton
继上一步更targets/audio后，在crouton目录中执行

`make`

（在linux环境下执行make）

会生成一个*crouton*文件

把这个*crouton*文件放到你的chromebook的 ~/Downloads目录下

##开始安装
1. 在 Chrome OS 下按 Ctrl + Alt + T 打开命令行标签页，输入 shell 进入命令行。
2. 执行 sudo sh -e ~/Downloads/crouton -r trusty -t xfce -e 进行安装
3. 当出现下面的几行字符时，就表明安装成功：
```
Here's some tips:
 
Audio from the chroot will now be forwarded to CRAS (Chromium OS audio server),
through an ALSA plugin.
 
Future Chromium OS upgrades may break compatibility with the installed version
of CRAS. Should this happen, simply update your chroot.
 
You can flip through your running chroot desktops and Chromium OS by hitting
Ctrl+Alt+Shift+Back and Ctrl+Alt+Shift+Forward.
 
You already have the Chromium OS extension installed, so you're good to go!
 
You can open your running chroot desktops by clicking on the extension icon.
Once in a crouton window, press fullscreen or the "switch window" key to switch
back to Chromium OS.
 
You can launch individual apps in crouton windows by using the "xiwi" command
in the chroot shell. Use startxiwi to launch directly from the host shell.
Use the startxiwi parameter -b to run in the background.
Example: sudo startxiwi -b xterm
 
You can start Xfce via the startxfce4 host command: sudo startxfce4
```
##进入安装好的linux进行配置
执行以下命令进入linux桌面环境
`sudo startxfce4`

###安装中文语言包
因为安装后是什么都不带的系统，因此是英文系统，要使用中文语言先安装语言包：
```
sudo apt-get install language-pack-zh-hans
sudo apt-get install language-pack-gnome-zh-hans
```
接下来安装语言选择器：

`sudo apt-get install language-selector-gnome`

安装好后应该就可以从 Settings-Language Support更改语言了

`sudo update-locale LANG="zh_CN.UTF-8" LANGUAGE="zh_cn:en"`

之后重启即可变更为中文语言

##使用linux
我一般情况下只用以下方式使用linux命令行，而不用桌面版环境


- Ctrl + Alt + T 打开命令行标签页

输入 `shell` 进入命令行

`sudo enter-chroot`

进入linux命令行

好处是一个网页标签就可以使用linux系统了，复制粘贴都方便


##删除发行版
可以使用 `sudo delete-chroot chrootname` 来删除发行版，其中 chrootname 一般是发行版代号

也可以直接删除 /usr/local/chroot 里面的文件夹





