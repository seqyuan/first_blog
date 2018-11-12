Title: supertools
Date: 2018-11-09
Category: tools
Tags: cotools, tetools, pagtools, medtools, plotools
Slug: supertools
Author: seqyuan
Summary: cotools使用开发说明，适用于 cotools, tetools, pagtools, medtools, plotools

[TOC]

## cotools使用
### 网页检索
我们设置了网页服务使开发者和用户更好的互动，访问以下ip中的任何一个都能看到相应工具集的汇总
[tetools](192.168.2.202:1900) [192.168.2.202:1900](192.168.2.202:1900)

[pagtools](192.168.2.202:1901) [192.168.2.202:1901](192.168.2.202:1901)

[medtools](192.168.2.202:1902) [192.168.2.202:1902](192.168.2.202:1902)

[plotools](192.168.2.202:1903) [192.168.2.202:1903](192.168.2.202:1903)

### 空运行，帮助文档
空运行cotools，会显示帮助文档，如下：
```
Program: tetools (Tools set)
Version: 0.0.1   seqyuan@gmail.com  Nov 08 2018

Usage:  tetools  <command> <command> [options]
                 at|addtool          [toolspath]            Add a new tool or a new version
                 ut|updatetool       [toolspath]            Update a tool not change the version
                 am|addmodule        [module description]   Add a new module

    TAD             TAD类个性化分析工具
    compartment     sfadf

```
### 查看某个module里所有的tool
运行 cotools modulename即可查看相应module里所有的tool，示例：
`tetools TAD`
```
$./tetools TAD

    Usage TAD:
        Jujube_pill     v0.0.1  吃枣药丸
        argtest         v0.0.1  argtest
```
### 查看某个tool的帮助文档
运行 `cotools modulename toolname`即可查看相应tool的帮助信息，示例：
```
$./tetools TAD Jujube_pill

usage:
    python3 /Users/yuanzan/Documents/golang_programe/tetools/module/TAD/Jujube_pill/current/Jujube_pill/bin/Jujube_pill arg1 val1 arg2 val2
jujube pill

/Users/yuanzan/anaconda3/bin/python3 /Users/yuanzan/Documents/golang_programe/tetools/module/TAD/Jujube_pill/current/Jujube_pill/bin/Jujube_pill 
```
在运行命令的最后一行会提示实际要执行的程序
### 使用tool
#### cotools的方式使用
首先执行`cotools modulename toolname`查看tool的参数说明，然后根据参数说明直接在命令行输入即可，例如：
```
$./tetools TAD Jujube_pill ag1 
jujube pill

/Users/yuanzan/anaconda3/bin/python3 /Users/yuanzan/Documents/golang_programe/tetools/module/TAD/Jujube_pill/current/Jujube_pill/bin/Jujube_pill  ag1
```
根据示例我们能清楚的看到`tetools TAD Jujube_pill ag1` 等价于执行`/Users/yuanzan/anaconda3/bin/python3 /Users/yuanzan/Documents/golang_programe/tetools/module/TAD/Jujube_pill/current/Jujube_pill/bin/Jujube_pill  ag1`
所以可以用以上两种方式调用执行程序
## cotools目录结构
```
.
├── bin                 
│   ├── cotools.ini        #cotools配置文件
│   └── tetools            #cotools主程序
├── html                   #用于网页服务的目录
│   ├── Makefile
│   ├── __pycache__
│   ├── content
│   ├── develop_server.sh
│   ├── fabfile.py
│   ├── output
│   ├── pelicanconf.py
│   ├── publishconf.py
│   └── themes
└── module                 #存放开发人员提交的各类程序
    ├── TAD                #模块名1
    └── compartment        #模块名2
```
## 程序开发规范
### 目录及文件
开发目录示例如下：
```
.
└── argtest                        #NOT NULL
    └── bin                        #NOT NULL
        ├── argtest -> argtest.py  #NOT NULL
        ├── argtest.ini            #NOT NULL
        ├── argtest.md             #NOT NULL
        ├── argtest.py             #NOT NULL
        └── figure                 #NOT NULL
            └── seqyuan.jpg
```
`**提交给tools管理员此目录的绝对路径即可**`
#### toolname
提交给tools管理员的路径basename即为程序的名称`toolname`，此后统称为`toolname`，示例中为`argtest`
#### bin
bin目录是固定且必须的
#### 主程序
bin目录下有主程序，示例中为`argtest.py`，此程序命名不做要求
#### 主程序链接为`toolname`
示例中bin/argtest为一个软链接文件，链接的是bin下的主程序，链接文件的命名与`toolname`的名称相同
#### toolname.ini文件
示例中的argtest.ini为必须文件，标准的ini书写格式，命名为`toolname` + `.ini`，其中内容如下：

    [argtest]               
    # section name需命名为`toolname` 
 
    interpreter = python3
     # 主程序的解释器，固定的option name，value值可根据主程序作修改，例如主程序为test.r 需要Rscript3.5.1那么这个值请设置为Rscript3.5.1，如果是比较特殊的版本请联系tools管理员添加新的程序解释器路径到tools的配置文件

    description = argtest
    # 对程序功能的简短描述，用于显示在linux界面
       
    module = TAD
    # 主程序所属的分类，可通过空运行tools程序查看已有分类信息，如果没有新提交程序的分类，可以联系cotools管理员进行添加

    version = v0.0.1 
    # 程序的版本号，以三段式命名版本号。如果对已经提交的程序有任何basename目录内的文件更改，需要更改版本号并提交目录给cotools管理员
#### tool说明文件toolname.md
示例中的argtest.md为markdown格式的文件，命名为`toolname`+ `.md`，与标准markdown不同的是文件中需要有头文件，示例如下：


    Title: argtest
    # 值为`toolname`
    Date: 2018-11-06
    # 日期格式
    Category: TAD
    # 值为module name

    Tags: args，python
    # 本tools的关键词,如有多个以逗号隔开

    Slug: 
    # 此项为空
    # 此项为url的后缀，例如 192.168.2.202/1900/argtest.html中的 argtest，如果此项为空默认为Title，所以tools里面的toolsname是不允许有重名的，即使相同的toolname在不同的module里，如果不同module里有重名的toolname会导致网页生成有问题

    Author: seqyuan
    # 作者名称

    Summary: 
    # 摘要
 
以下为`toolname.md`的正文部分，以标准的markdown格式书写
```
> 我们经常以pip install package的形式安装python包，很多新同鞋有这样的疑问：怎样编写python包（自己造轮子）分享给别人，让别人也可以用pip的形式进行安装使用呢？

要解决这个问题我们要从两方面入手：

* 写一个python包
* 规范包的内容上传到PYPI

## 编写一个python包
为了言之有物我们决定编写一个能解决实际应用的包
![seqyuan](./module/TAD/argtest/bin/figure/seqyuan.jpg)
```
如果需要在`toolname.md`中插入图片，请按照示例中的样式``采用相对路径``插入图片，图片要放在`toolname/bin/figure`里，标准相对路径格式为：
>./module/模块名/toolname/bin/figure/图片名

#### toolname/bin/figure
此目录必须存在，即使为空。用于存放`toolname.md`中插入的图片

### tool审核
tool审核工作由cotools管理员进行分配审核

## cotools管理员
### 添加tool
cotools管理员采用 `at`参数+`开发人员提交的tool路径`
以下命令用于添加tool到cotools
tetools at /abspath/toolname
### 更新tool
如果提交的toolname在cotools中已经存在，更新tool的版本需要用到`ut`参数
cotools管理员采用 `ut`参数+`开发人员提交的tool路径`
以下命令用于添加tool到cotools
cotools ut /abspath/toolname
### 添加模块到cotools
如果开发人员提供的tool所属模块在cotools中不存在（空运行cotools可查看已有的模块），需要用到`am`参数添加新模块到cotools才能使用`at`参数添加tool。
示例：`cotools am newmodulename moduleDescription`
### 添加新的解释器
请编辑`cotools.ini`文件手动添加
`cotools.ini`内容如下：
```
[software]
python3 = /annoroad/share/software/install/Python-3.3.2/bin/python3
perl    = /annoroad/share/software/install/perl-5.16.2/bin/perl
make    = /usr/bin/make -f
Rscript = /annoroad/share/software/install/R-3.2.2/bin/Rscript

[module]
TAD = TAD类个性化分析工具
```
### 删除module
请编辑`cotools.ini`文件中的`module`section自行删除或修改
如要删除整个模块，请手动删除`./module/modlueName`
### 建立持久网页服务
由supertools总管理员进入makeService，然后`go build make_serve.go`，最后`nohup make_serve &` 就启动了网页服务
```bash
cd supertools/makeService
go build make_serve.go
nohup make_serve &
```
### 设置计划任务，定期生成网页
运用`crontab -e`命令在每周日的晚21点自动执行以下命令,注意`*tools`改成自己负责的工具
```
0 21 * * sun cd supertools/*tools/html && make html
```