Title: 授人以渔-购买VPS搭建ssr科学上网
Date: 2017-12-01
Category: popular genes
Tags: 翻墙
Slug: vps shadowsocksr
Author: seqyuan
Summary: 购买VPS服务器,搭建ssr科学上网

##自建ssr科学上网教程整体分三步：

 * 第一步：购买VPS服务器
 * 第二步：部署VPS服务器
 * 第三步：下载配置ShadowsocksR科学上网

### ===第一步：购买VPS服务器===

 VPS服务器需要选择国外的，我选择的是“搬瓦工”，速度、稳定性易用性都不错。

 * 搬瓦工注册地址：https://bwh1.net/
 * 注册后选择一个适合自己的配置（最便宜的），点进去购买。
 
### 1 选择最便宜的

 ![avatar](https://raw.githubusercontent.com/seqyuan/blog/master/images/ssr/N1.jpg)

### 2 点击红色箭头所示位置

 ![avatar](https://raw.githubusercontent.com/seqyuan/blog/master/images/ssr/N2.jpg)

### 3 选择套餐（建议先选择一个月的试试）
 
 ![avatar](https://raw.githubusercontent.com/seqyuan/blog/master/images/ssr/N3.jpg)  

### 4 选择一个机房

 ![avatar](https://raw.githubusercontent.com/seqyuan/blog/master/images/ssr/N4.jpg)  

### 5 加入到购物车（单击最下方的 add to cart）

### 6 Checkout

 ![avatar](https://raw.githubusercontent.com/seqyuan/blog/master/images/ssr/N5.jpg)  

### 7 检查信息，选择付款方式（Alipay）

 ![avatar](https://raw.githubusercontent.com/seqyuan/blog/master/images/ssr/N6.jpg) 
 
### 8 Pay now

 ![avatar](https://raw.githubusercontent.com/seqyuan/blog/master/images/ssr/N7.png)

### 9 打开手机支付宝，扫码支付（已自动转换汇率）。为防止你不小心为我的账号付款，二维码已打码

 ![avatar](https://raw.githubusercontent.com/seqyuan/blog/master/images/ssr/N8.png)

### ===第二步：一键部署VPS服务器===

### 1 由主页的Client Area进入自己的搬瓦工账户

 ![avatar](https://raw.githubusercontent.com/seqyuan/blog/master/images/ssr/N9.png)

### 2 按红色箭头标示，依次点击 Service, My Service，KiviVM Control Panel，之后进入KiviVM管理界面

 ![avatar](https://raw.githubusercontent.com/seqyuan/blog/master/images/ssr/N10.png)

### 3 按红色箭头标示，点击start 启动服务器

 ![avatar](https://raw.githubusercontent.com/seqyuan/blog/master/images/ssr/N11.png)

### 4 一键安装并启动ShadowsocksR，建议改一下端口号，我一般改成4位数

### 5 根据你的使用的科学上网设备下载相应客户端,windows ssr下载地址链接: [ShadowsocksR](https://github-production-release-asset-2e65be.s3.amazonaws.com/98547658/787c9470-731d-11e7-9284-a1c67a0abaec?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20171201%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20171201T070154Z&X-Amz-Expires=300&X-Amz-Signature=a7c3c861b7c0dab8d669bacda6f08ce9e262799638368924546c240d0d3383c9&X-Amz-SignedHeaders=host&actor_id=0&response-content-disposition=attachment%3B%20filename%3DShadowsocksR-4.7.0-win.7z&response-content-type=application%2Foctet-stream)

 ![avatar](https://raw.githubusercontent.com/seqyuan/blog/master/images/ssr/N12.png)  

### ===第三步：下载配置ShadowsocksR科学上网===

### 1 下载客户端后, 解压缩，按箭头所示双击飞机图标

 ![avatar](https://raw.githubusercontent.com/seqyuan/blog/master/images/ssr/N13.jpg)

### 2 根据KiviVM中ShadowsocksR GUI settings，填写自己ssr客户端的账号信息，然后点击确定

 ![avatar](https://raw.githubusercontent.com/seqyuan/blog/master/images/ssr/N14.png)

 ![avatar](https://raw.githubusercontent.com/seqyuan/blog/master/images/ssr/N15.png)

### 3 选择PAC模式上网

 ![avatar](https://raw.githubusercontent.com/seqyuan/blog/master/images/ssr/N16.png)

### 如果想分享给局域网内其他人使用,可以按照下面的步骤 

### 1 打开shadowsocksR选项设置,允许来自局域网的连接

 ![avatar](https://raw.githubusercontent.com/seqyuan/blog/master/images/ssr/N17.png)

### 2 打开dos命令行,输入ipconfig查看自己电脑的IP地址

 ![avatar](https://raw.githubusercontent.com/seqyuan/blog/master/images/ssr/N18.png)

### 3 把上一步得到的IP告知你要分享的人,让其按照如下操作设置即可

 ![avatar](https://raw.githubusercontent.com/seqyuan/blog/master/images/ssr/N19.png)