Title: linux常用总结
Date: 2017-03-15
Category: linux
Tags: linux
Slug: linux
Author: seqyuan
Summary: linux常用总结

###实现linux集群间不同节切换无密码登录

在客户执行以下命令

`ssh-keygen -t rsa`

出现以下结果

```
Generating public/private rsa key pair.
Enter file in which to save the key (/home/yuanzan/.ssh/id_rsa):
/home/yuanzan/.ssh/id_rsa already exists.
Overwrite (y/n)? y
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/yuanzan/.ssh/id_rsa.
Your public key has been saved in /home/yuanzan/.ssh/id_rsa.pub.
The key fingerprint is:
63:f2:a8:5c:21:0b:da:70:da:ff:18:c0:ee:48:82:97 yuanzan@login-0-1.local
The key's randomart image is:
+--[ RSA 2048]----+
|                 |
|                 |
|                 |
| .               |
|. = . o S        |
|.O + o * .       |
|=.E o o .        |
|o+ o =           |
|. . =..          |
+-----------------+

```

然后执行以下命令，添加pulic key 到 authorized_keys即可

`cat ～/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys`


重新打开一个远程窗口就能在节点之间无密码切换了