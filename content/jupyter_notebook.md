Title: 本地电脑浏览器访问Linux集群上配置Jupyter Notebook服务
Date: 2020-02-24
Category: linux
Tags: jupyter
Slug: jupyter_notebook
Author: ahworld
Summary: Linux集群上配置Jupyter Notebook服务，本地电脑进行访问的方法

以往我们用Jupyter Notebook都是在自己电脑安装Anaconda，然后打开Jupyter服务，但是有时候我们运行的命令需要的计算量和内存比较大，所以如果能在Linux集群上配置Jupyter Notebook服务，再以自己的电脑浏览器访问这个服务就能体验Linux集群计算资源带来的便利。

具体实现有以下5个步骤：

>1. Linux集群上安装Anaconda
>2. 生成jupyter配置文件
>3. 生成密钥
>4. 修改jupyter配置文件
>5. 启动jupyter notebook服务

#### 1）Linux集群上安装Anaconda
登陆[Anaconda官网](https://www.anaconda.com/distribution/)下载、安装到你的Linux集群。Anaconda集成了Jupyter，安装Anaconda的过程会自动把Jupyter加入到你的环境变量。

#### 2）生成jupyter配置文件
在Linux集群命令行输入以下命令。
```
jupyter notebook --generate-config
```
以上命令执行成功后会在home目录生成jupyter notebook的配置文件`.jupyter/jupyter_notebook_config.py`。

#### 3）生成密钥
在集群Linux命令行打开python3环境，执行以下两行命令生成密钥。
```python
from notebook.auth import passwd  
passwd()
```
在执行`passwd()`命令的时候会提示输入密码，这是jupyter服务的密码，可以设置简单点便于自己记住，例如`123456a`
#### 4）修改jupyter配置文件
```
vim ~/.jupyter/jupyter_notebook_config.py
```
修改`~/.jupyter/jupyter_notebook_config.py`里的以下内容：
```python
# 就是设置ip为 0.0.0.0
c.NotebookApp.ip = '0.0.0.0'
# 刚才复制粘贴的那个密钥 
c.NotebookApp.password = 'shal:dd...'
# 禁止自动打开浏览器 
c.NotebookApp.open_browser = False 
# 设置端口号
c.NotebookApp.port = 7890
# 设置默认的work dir
c.NotebookApp.notebook_dir = '/seqyuan/PMO/yuanzan'
```
![jupyter_1.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/jupyter/jupyter_1.png)

#### 5）启动jupyter notebook服务
在Linux命令行输入以下命令启动jupyter notebook服务
```
jupyter notebook
```
我公司Linux集群的IP地址是192.168.2.209，所以在公司电脑`浏览器地址栏`输入`192.168.2.209:7890`就能访问jupyter notebook服务了

![jupyter_2.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/jupyter/jupyter_2.png)

## 后续更新

> `用家里电脑的浏览器访问在公司集群建立的服务`，例如：`python3 -m http.server`或者`jupyter notebook`


欢迎扫码关注生信微信公众号

![seqyuan](https://raw.githubusercontent.com/seqyuan/blog/master/images/jiangxiaoyu/seqyuan.jpg)
