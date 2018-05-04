Title: 造轮子上传到PYPI
Date: 2018-05-04
Category: multi jump 
Tags: multi jump
Slug: multiJump
Author: seqyuan
Summary: 

> 我们经常以pip install package的形式安装python包，很多新同鞋有这样的疑问：怎样编写python包（自己造轮子）分享给别人，让别人也可以用pip的形式进行安装使用呢？

要解决这个问题我们要从两方面入手：

* 写一个python包
* 规范包的内容上传到PYPI

## 编写一个python包
为了言之有物我们决定编写一个能解决实际应用的包：
> 很多时候我们使用linux集群为了安全考虑在登录节点和计算节点不能连接互联网，只能由某个计算节点切换到跳转节点，在跳转节点才能访问互联网。为了使这种连续跳转节点执行命令的操作更加简洁容易，我们决定编写一个叫multiJump的包。

首先我们编写好单独的脚本https://github.com/seqyuan/multiJump/blob/master/multiJump/multiJump.py

其实我们要把multiJump.py作为一个模块供其他程序例如sendmail.py使用，只需要把multiJump.py放在sendmail.py相同的目录下，然后在sendmail.py写下`import multiJump`就能使用multiJump.py里的类或者函数。

要使multiJump作为一个包存在，我们还需要搭配一定的目录结构，__init__.py可以是个空文件：
```
.
|————multiJump
|    |___ __init__.py
|    |___ multiJump.py
```

## 规范包的内容上传到PYPI
详细的规范请见官方网页https://docs.python.org/2/distutils/setupscript.html，要符合上传到PYPI的规范，我们还需要对前面构建的multiJump目录结构再做一些调整。
```
.
|————multiJump
|    |___ __init__.py
|    |___ multiJump.py
|————COPYING.txt
|————README.rst
|————setup.py
```
我们可以看到新的目录结构多了3个文件：

* **COPYING.txt**    就是授权文件，里面是你关于这个包的授权，比如：MIT license，那么你里面放入MIT License全文即可，这个License获得方式可以在PYPI上搜一个你记得名字的包，把它的COPYING.txt直接copy过来就行。当然，如果你不清楚这个License是什么意思，你完全可以不要这个文件。
* **README.rst**     对于包的说明文件，推荐用rst格式编写（因为不支持markdown）
* **setup.py**       核心文件

> 你需要在官网注册一个PYPI账号https://pypi.org/account/register/
> 创建用户验证文件 ~/.pypirc

```
[distutils]
index-servers=pypi

[pypi]
repository = https://upload.pypi.org/legacy/
username = <username> #在PYPI注册的账号
password = <password> #在PYPI注册账号的密码
```


来看看setup.py是怎么写的：
```
import codecs  
import os,sys
from setuptools import (
    setup,
)

def read(fname):
    return codecs.open(os.path.join(os.path.dirname(__file__), fname)).read() 
    """
    定义一个read方法，用来读取目录下的文件内容,作为包的描述信息
    我们一般是将README文件中的内容读取出来作为长描述，这个会在PyPI中你这个包的页面上展现出来，
    PyPI上支持.rst格式的文件，PyPI会自动把它转为HTML形式显示在你包的信息页面上
    """

setup(
    name="multiJump",
    version = "0.0.6",
    author="seqyuan",
    author_email='seqyuan@gmail.com',
    url="https://github.com/seqyuan/multiJump/wiki",
    #我在github上建了wiki作为包的使用说明，你也可以根据自己需要填写其他网址
    download_url = "https://codeload.github.com/seqyuan/multiJump/zip/master",
    description="multiple Jump IP do something",
    long_description=read("README.rst"),   #读取README.rst里的内容作为包的详细说明
    license="MIT",
    packages=['multiJump'],
    
    #执行此包必须要依赖的其他包
    extras_require = {
        'sys' : [ 'sys'],
        'paramiko' : ['paramiko'],
        'socket' : ['socket'],
        'time' : ['time'],
    }
)
```

setup里各参数的详细说明：

| Meta-Data        | Description                                  |
|------------------|----------------------------------------------|
| name             | name of the package                          |
| version          | version of this release                      |
| author           | package author’s name                        |
| author_email     | email address of the package author          |
| maintainer       | package maintainer’s name                    |
| maintainer_email | email address of the package maintainer      |
| url              | home page for the package                    |
| description      | short, summary description of the package    |
| long_description | longer description of the package            |
| download_url     | location where the package may be downloaded |
| classifiers      | a list of classifiers                        |
| platforms        | a list of platforms                          |
| license          | license for the package                      |

#### 上传并完成发布
上传命令`python3 setup.py sdist upload`

### 上传结果
https://pypi.org/project/multiJump/
欢迎下载并使用`multiJump`
上传到PYPI之后就能用`pip3 install multiJump`安装到自己的python库了
multiJump包的使用方法可参见https://github.com/seqyuan/multiJump/wiki
我用它做的第一件应用是跳转到end节点发送邮件。