Title: python实现COVID-19肺炎疫情地图
Date: 2020-02-14
Category: map
Tags: map, python
Slug: feiyan
Author: ahworld
Summary: python实现COVID-19肺炎疫情分布地图

此次新型冠状病毒肺炎疫情影响甚广，很多网站推出了疫情分布地图供我们时时追踪全国各地的疫情情况。

![feiyan_1.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/feiyan/feiyan_1.png)

我们自己要用python实现这个图需要解决两个大的问题：

* [ ] 获取全国各地确诊数据
* [ ] 选取合适的python包画地图

> 我的运行环境是`MACOS` chrom浏览器 + jupyter notebook，jupyter notebook可通过安装[Anaconda](https://www.anaconda.com/distribution/#download-section)获得

## 获取全国各地确诊数据

我们选择采用网络爬虫技术获取数据，目标是：[腾讯疫情地图网页](https://news.qq.com//zt2020/page/feiyan.htm#charts)

解析网页分析获取数据的技术我们在[python实现NBA球员出手位置图表](https://mp.weixin.qq.com/s/km5ZUSDFtr7VGjZswdQPVw)这篇文章中介绍过，具体步骤如下：
##### 1）解析网页，分析确诊数据来源

* 打开chrom浏览器
* 打开一个空白网页
* 在网页上点击右键
* 选择`检查`

![feiyan_2.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/feiyan/feiyan_2.png)

* 在网页的地址栏输入[腾讯疫情地图网页](https://news.qq.com//zt2020/page/feiyan.htm#charts)

我们依次查看`Network`涉及到的各种网页链接，最终发现全国各省的确诊数据是以Json格式存储

![feiyan_3.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/feiyan/feiyan_3.png)

从`Headers`我们获取到数据存放的网址
![feiyan_4.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/feiyan/feiyan_4.png)
##### 2）用代码下载数据

我们用以下python代码获取数据存储到`data`
```python
import time,json,requests
url = 'https://view.inews.qq.com/g2/getOnsInfo?name=disease_h5&callback=&_=%d'%int(time.time()*1000)
data = json.loads(requests.get(url=url).json()['data'])
```
data中包含以下数据，其中`areaTree`包含我们需要的各省确诊数据
```
lastUpdateTime
chinaTotal
chinaAdd
isShowAdd
chinaDayList
chinaDayAddList
dailyNewAddHistory
dailyDeadRateHistory
confirmAddRank
areaTree
articleList
```

## 选取合适的python包画地图
我们选取[geopandas](https://geopandas.org/install.html)这个python包画地图，我们先画一幅世界地图做测试

```python
import geopandas as gpd
import pandas as pd
import matplotlib.pyplot as plt
%matplotlib inline

world = geopandas.read_file(geopandas.datasets.get_path('naturalearth_lowres'))
world = world[(world.pop_est>0) & (world.name!="Antarctica")]
world.plot()
plt.show()
```

![feiyan_5.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/feiyan/feiyan_5.png)

geopandas结合了pandas和shapely的功能，扩展了pandas在空间数据操作方面的能力，使得可以轻松的用python实现空间数据分析，`geometry`列为地图坐标信息。

![feiyan_6.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/feiyan/feiyan_6.png)
 
##### 1）下载中国地图，并整理
我们从[GADM](https://gadm.org/download_country_v3.html)网站下载中国行政区划分地图，以下是我下载的地图，，解压后使用，具体下载链接参考文末的`Reference`

* [gadm36_CHN_shp](https://data.biogeo.ucdavis.edu/data/gadm3.6/shp/gadm36_CHN_shp.zip)
* [gadm36_HKG_shp](https://data.biogeo.ucdavis.edu/data/gadm3.6/shp/gadm36_HKG_shp.zip)
* [gadm36_MAC_shp](https://data.biogeo.ucdavis.edu/data/gadm3.6/shp/gadm36_MAC_shp.zip)
* [gadm36_TWN_shp](https://data.biogeo.ucdavis.edu/data/gadm3.6/shp/gadm36_TWN_shp.zip)

其中`gadm36_CHN_shp`包含3组数据

* gadm36_CHN_1.shp：省、自治区、直辖市单位划分
* gadm36_CHN_2.shp：市级单位划分
* gadm36_CHN_3.shp：县级单位划分

从GADM下载的地图，中国大陆和港、澳、台的文件是分开的，所以用以下代码合并地图数据
```python
mainland_map = gpd.read_file('/Users/yuanzan/Desktop/tmp/gadm36_CHN_shp/gadm36_CHN_1.shp')
HK_map = gpd.read_file('/Users/yuanzan/Desktop/tmp/map/gadm36_HKG_shp/gadm36_HKG_0.shp')
HK_p = pd.DataFrame({'GID_0':'CHN', 'NAME_0':'China', 'GID_1':'CHN.32_1', 'NAME_1':'Hongkong', 'VARNAME_1':'Hongkong', 'NL_NAME_1':'香港', 'TYPE_1':'tebiexingzhengqu', 'ENGTYPE_1':'SAR', 'CC_1':None, 'HASC_1':'CN.HK', 'geometry':None}, index=[0])
HK_p.loc[0,'geometry'] = HK_map.loc[0,'geometry']

MAC_map = gpd.read_file('/Users/yuanzan/Desktop/tmp/map/gadm36_MAC_shp/gadm36_MAC_0.shp')
MAC_p = pd.DataFrame({'GID_0':'CHN', 'NAME_0':'China', 'GID_1':'CHN.33_1', 'NAME_1':'Macao', 'VARNAME_1':'Macao', 'NL_NAME_1':'澳门', 'TYPE_1':'tebiexingzhengqu', 'ENGTYPE_1':'SAR', 'CC_1':None, 'HASC_1':'CN.MAC', 'geometry':None}, index=[0])
MAC_p.loc[0,'geometry'] = MAC_map.loc[0,'geometry']

TW_map = gpd.read_file('/Users/yuanzan/Desktop/tmp/map/gadm36_TWN_shp/gadm36_TWN_0.shp')
TW_p = pd.DataFrame({'GID_0':'CHN', 'NAME_0':'China', 'GID_1':'CHN.34_1', 'NAME_1':'Taiwan', 'VARNAME_1':'Taiwan', 'NL_NAME_1':'台湾', 'TYPE_1':'Shěng', 'ENGTYPE_1':'Province', 'CC_1':None, 'HASC_1':'CN.TW', 'geometry':None}, index=[0])
TW_p.loc[0,'geometry'] = TW_map.loc[0,'geometry']

mainland_map = mainland_map.append(HK_p, ignore_index=True)
mainland_map = mainland_map.append(MAC_p, ignore_index=True)
mainland_map = mainland_map.append(TW_p, ignore_index=True)
```

通过前期的观察，我们发现从腾讯网站下载的`data`中的省命名与`mainland_map`地图中存储的命名不一致，所以用以下代码调整一致

```python
mainland_map_c = mainland_map.copy()
for i, v in mainland_map.iterrows():
    tmp = v['NL_NAME_1'].split("|")
    if len(tmp)==2:
        jian = tmp[1]
        if '自治区' in jian:
            if jian == "内蒙古自治区":
                mainland_map_c.loc[i,"NL_NAME_1"] = "内蒙古"
            else:
                mainland_map_c.loc[i,"NL_NAME_1"] = jian[0:2]
        else:
            if tmp[0] == "黑龙江省":
                mainland_map_c.loc[i,"NL_NAME_1"] = "黑龙江"
            else:
                mainland_map_c.loc[i,"NL_NAME_1"] = jian
```

简单画图预览`mainland_map_c.plot()`

![feiyan_7.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/feiyan/feiyan_7.png)

##### 2）合并地图与data中的各省确诊病例数据

```python
mainland_map_c['confirm'] = 0
mainland_map_c.index = mainland_map_c['NL_NAME_1']
mainland_map_c
for i in data['areaTree'][0]['children']:
    mainland_map_c.loc[i['name'], 'confirm'] = i['total']['confirm']
```

##### 3）画图
以下代码第一行为MACOS系统上显示中文设置，Win/Linux系统的设置请参考[python3字体解决大挖掘](https://mp.weixin.qq.com/s/SHuLZRMAAenaWWxrQ5vbRA)

```python
plt.rcParams["font.family"] = 'Arial Unicode MS'

def set_frame(ax):
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.spines['bottom'].set_visible(False)
    ax.spines['left'].set_visible(False)
    ax.set_xticks([])
    ax.set_yticks([])

ax = mainland_map_c.plot(column="confirm", scheme="User_Defined", classification_kwds=dict(bins=[10,100,500,1000,10000]), alpha= 1, figsize=(9,9), cmap='OrRd', legend=True)
leg = ax.get_legend()
leg._loc = [0,0.1]
leg.get_frame().set_facecolor('none')
leg.get_frame().set_edgecolor('none')

legend_labels = ['1-9人','10-99人','100-499人','500-999人','1000-999人','10000人及以上']
for i,v in enumerate(leg.get_texts()):
    v.set_text(legend_labels[i])
   
set_frame(ax)
#mainland_map_c.apply(lambda x: ax.annotate(s=x.NL_NAME_1, xy=x.geometry.centroid.coords[0], ha='center'),axis=1);
```

以下两图为加与不加最后一行的结果图

![96aab34249cdf1f3d977789890f63718.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/feiyan/feiyan_8.png)

![ecbb471165cd459426e9f7b067e1b2a4.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/feiyan/feiyan_9.png)

### 单个省城市疫情地图的绘制
我们以河北省为例，读取的地图数据要选取`gadm36_CHN_2.shp`

##### 1）读取市级地图数据并整理城市命名

```python
city_map = gpd.read_file('/Users/yuanzan/Desktop/tmp/gadm36_CHN_shp/gadm36_CHN_2.shp')

city_map_hebei = city_map[city_map['NL_NAME_1']=='河北']
city_map_hebei_c = city_map_hebei.copy() 

for i,v in city_map_hebei.iterrows():
    city_map_hebei_c.loc[i,"NL_NAME_2"] = v['NL_NAME_2'].rstrip('市')
    
city_map_hebei_c['confirm'] = 0
city_map_hebei_c.index = city_map_hebei_c['NL_NAME_2']
```

##### 2）合并地图与data中的各市确诊病例数据
```python
for i in data['areaTree'][0]['children']:
    if i['name'] == '河北':
        for ii in i['children']:
            city_map_hebei_c.loc[ii['name'],'confirm'] = ii['total']['confirm']
```

##### 3）画图

```python
ax = city_map_hebei_c.plot(column='confirm', figsize=(5,5), cmap='OrRd', legend=False)
city_map_hebei_c.apply(lambda x: ax.annotate(s='{0} {1}'.format(x.NL_NAME_2,x.confirm), xy=x.geometry.centroid.coords[0], ha='center'),axis=1)

set_frame(ax)
```

![c933dcaffa120c21a215e061355f38f7.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/feiyan/feiyan_10.png)

欢迎扫码关注生信微信公众号

![seqyuan](https://raw.githubusercontent.com/seqyuan/blog/master/images/jiangxiaoyu/seqyuan.jpg)
