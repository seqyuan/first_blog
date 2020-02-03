Title: 生信工程师的自我修养--开发一个python包实现单细胞堆叠小提琴图
Date: 2020-02-03
Category: single-cell 
Tags: seurat，scanpy
Slug: scanyuan
Author: ahworld
Summary: 开发一个python包scanyuan实现单细胞堆叠小提琴图

![a0f277a8cc2341563515ca009945dbb3.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/scanyuan/scanyuan_01.png)

To be or not to be，这么着还是那么着，这是莎士比亚的问题呀！等我们开始做单细胞生信分析，To be or not to be，又变成了大家伙儿的问题了，当下最火的技术嘛！

像我这么个好人，可以这么着也可以那么着，这  “To be or not to be”，什么时候儿？它又变成了我自个儿的问题了呢？

咱们这故事啊，得从[僵小鱼的故事](http://www.seqyuan.com/jiangxiaoyu%20story.html)开始说起，她遇见了个顶大的麻烦，在微信群找人帮忙，哎还真有人支招给帮成了，那么这件事和我有什么关系？我是谁呀？我就是讲述`僵小鱼的故事`，并成为故事一部分的一名普通生信工程师，具体是谁并不重要。

在“僵小鱼的故事”开头我们说道：“许多年之后，面对同一个作图需求，僵小鱼将会回想起，在微信群里提出相同问题的那个遥远的上午”。

时间过的并不慢，回想也没有等到很多年之后才来，就在我写完“僵小鱼的故事”第二天，在同一个微信群又有朋友提出了同一类的问题：单细胞marker基因小提琴图横着堆叠在一起的图有没有现成的代码可以实现？

![3669e9613475e72c0dcd1403810fc487.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/scanyuan/scanyuan_02.png)
![961f4743e67242f0f17bf6957b2ebebb.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/scanyuan/scanyuan_03.png)


人们给出了和僵小鱼问的问题一样的建议：`AI`(Adobe Illustrator)；我拿出了前一天刚写好的僵小鱼的故事初版给那位群友看。出人意料的是群里众人的目光投向了我的写作文风以及[我的博客](www.seqyuan.com)屈指可数的文章数，那位朋友问题的话题就这样被忽略了。

最终那位朋友做了和僵小鱼一样的选择：`AI`。

![f6f08d7527114b5ce5e8f2179af84195.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/scanyuan/scanyuan_04.png)

![ba6a20ed80ddab8015d148a8acef3fa7.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/scanyuan/scanyuan_05.png)

虽然我没有帮到他，但是有一点我可以更肯定，僵小鱼看到群里的消息一定会像“僵小鱼的故事”开头写的那样：

> 许多年之后，面对同一个作图需求，僵小鱼将会回想起，在微信群里提出相同问题的那个遥远的上午

而我则想起了在“僵小鱼的故事”中一个未了的心愿，一个吹过的牛皮：

> 于是查看了scanpy的源代码，发现是一个叫stacked_violin的函数调用的seaborn.violinplot实现的这个小提琴图，那我就copy一下这个函数，修改一些设置，让它默认出来就是XY转制的小提琴图不就行了。转念又一想还是不浪费时间了。

回头再来看，故事是好故事，解决了：
> 从[seurat](https://satijalab.org/seurat/)对象到[scanpy](https://scanpy-tutorials.readthedocs.io/en/latest/pbmc3k.html)对象的转换问题，可以应用scanpy丰富的画图函数对seurat的结果画图

但是scanpy中却没有方法能直接能产出僵小鱼和那位朋友需要的图，而我用图片旋转的解决方法，实现过程不够优雅，最终效果与原图相比也有些差距。
![90887f626093ac5377d40ab5e56fbd6b.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/scanyuan/scanyuan_06.png)

所以“`To be or not to be`”它变成了我自个儿的问题，我得把这个事弄圆了。

我先从scanpy源码中找到画堆叠小提琴图的函数stacked_violin，然后拷贝出来重构，命名为stacked_violin_t。
![518dfce091a33f9b801cfe6dd4c91ad3.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/scanyuan/scanyuan_06.png)
最后[做成一个python包](https://mp.weixin.qq.com/s/rc8ky5kqdchJPHVxlQrtRQ)命名为[scanyuan](https://github.com/seqyuan/scanyuan "scanyuan")，上传到github和PYPI，可以用 `pip install scanyuan`安装这个包。

下面所谓`现成的代码`就是：读入数据，并用`scanyuan`中的`stacked_violin_t`方法实现文章堆叠小提琴图，

```python
import scanpy as sc
import scanyuan as scy

# 此处示例为读取loom文件，也可以是其他scanpy支持的数据格式
adata = sc.read_loom("/Users/yuanzan/Desktop/tmp/sdata.loom", sparse=True, cleanup=False, X_name='spliced', obs_names='CellID', var_names='Gene', dtype='float32')
marker_genes = ['Stfa1', 'Ngp', 'Ccl5', 'Ccl4', 'BC100530', 'Gzma', 'Gata2', 'Cd74']

ax = scy.stacked_violin_t(adata, marker_genes, figsize=[8,4], groupby='ClusterName')
```
以下两张图是最终成图的效果展示

![795b900741e3bf3c1d8c7c6d80c6f354.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/scanyuan/scanyuan_07.png)
![4911c6e11d609ba1931c1f82bce4e6f2.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/scanyuan/scanyuan_08.png)

![05c91d1e716db20058dfc6af23b6ea32.jpeg](https://raw.githubusercontent.com/seqyuan/blog/master/images/scanyuan/scanyuan_09.png)

这篇文章其实早已写就，故事到这里也本该就结束了，但是在[僵小鱼的故事](https://mp.weixin.qq.com/s/REUH4Wzt1fT6HQD2LDgthg)文章发出之后，有一位叫`黑川五郎`的朋友留言说他开发了一个R包[MySeuratWrappers](https://github.com/lyc-1995/MySeuratWrappers)实现了我们这次这介绍的`scanyuan`同样的功能。

![6f02c8c3651cb46a9955bdacb5f39b9d.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/scanyuan/scanyuan_10.png)

殊途同归，能遇到同道是我们的幸运。我想，乐于分享，利用自己的技能带给自己和别人一点点便利，是每一个生信工程师自我修养的一部分。

欢迎扫码关注生信微信公众号

![seqyuan](https://raw.githubusercontent.com/seqyuan/blog/master/images/jiangxiaoyu/seqyuan.jpg)
