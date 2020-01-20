Title: 僵小鱼的故事
Date: 2020-01-15
Category: single-cell 
Tags: seurat ， scanpy
Slug: jiangxiaoyu story
Author: ahworld
Summary: 许多年之后，面对同一个作图需求，僵小鱼准会回想起，在微信群里提出相同问题的那个遥远的上午

> 许多年之后，面对同一个作图需求，僵小鱼将会回想起，在微信群里提出相同问题的那个遥远的上午

在那个遥远的上午，百无聊赖的做着项目，用[Seurat](https://satijalab.org/seurat/pancreas_integration_label_transfer.html)画着一个又一个单细胞marker基因小提琴图，“这种图真是够了！”，她在心里想着，“是时候该换一种风格了，最好能够把多个基因的小提琴图规则美观的合并在一起，这样就能直接用在文章里了”。

![9296d89bf90fcffb1feb208444aeaba5.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/jiangxiaoyu/jiangxiaoyu_1.png)

果然在看过的顶级期刊文章里她找到了一个对胃口的图，“嗯，就是这个了”，想归想，真正要实现的时候发现：非常熟悉的Seurat不能直接产生这种图，“怎么办呢？”

“求助吧”，最近刚加了专业领域的微信群，群里大牛云集，“也许他们能给我点启发”，说着就试着发了自己的想法到群里。

![b1c81aa36ab2e0e924d36897edf1fcbd.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/jiangxiaoyu/jiangxiaoyu_2.png)

对于群里的新成员，大家都还是比较热心的，有大佬直接指出“`scanpy does it`”，有的大佬指出“`这张图来自Nature肝硬化的文章吧`”，“都这么熟悉的么”，僵小鱼在群里回应道。“真的假的？”，吃瓜的我心里想着，然后默默打开搜索引擎，搜索“单细胞肝硬化”的新闻，找到原文“[Resolving the fibrotic niche of human liver cirrhosis at single-cell level](https://www.nature.com/articles/s41586-019-1631-3)”，复制粘贴到sci-hub.tw，下载文章，这些都动作一气呵成，仿佛经历过多年的练习。果然，大佬诚不我欺，我从文章里找到了原图。

![89e2163f81c51a19fb56c14fa1ab44cd.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/jiangxiaoyu/jiangxiaoyu_3.png)

群里继续有人在出主意：“Seurat+ppt就能搞定”，“ggplot is able to do everything”，“PPT+1”，“PS食用更佳”，“要么AI，要么AI”，“AI”，“AI ...”。最终僵小鱼选择了`AI`，以下是成图：

![9d1239b17be9264db744ed0ae8a4404a.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/jiangxiaoyu/jiangxiaoyu_4.png)

> `AI才是真的解决一切！`

僵小鱼的故事已经告一段落了，我的心里却久久未能平复，作为已经5年没向AI过低头的人，我始终秉承的信念是：`python能解决一切`。所以在僵小鱼声明“`我目前只能接受seurat`”后，众人不再理睬的那句“`scanpy does it`”始终萦绕在我的脑海。

scanpy是处理单细胞数据的python包，基本复现了seurat的主要功能，我曾经测试过，在处理大数据量的单细胞项目时，scanpy的速度和内存真是比seurat友好太多。今天再一次翻看了[scanpy教程](https://scanpy-tutorials.readthedocs.io/en/latest/pbmc3k.html)，scanpy堆叠小提琴图的风格和Nature文章里的那个图很像，下面是scanpy教程里的小提琴图，在风格上还真是很像：

![a402d4be69390fb1882ba97f979851a6.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/jiangxiaoyu/jiangxiaoyu_5.png)

但是怎样把seurat的对象转换成scanpy能够识别的数据格式呢，这一个是R S3对象，另一个是python的[anndata](https://anndata.readthedocs.io/en/stable/api.html#module-anndata)对象。最初的想法是能不能把seurat对象的矩阵和分群信息导出到文件，再手动构建一个anndata对象，真要做的时候发现面临很多困难。

最终经过在google搜索，毫无意外的发现了同道中人，有相同需求的人在`bioinformatics`上提问[Convert R RNA-seq data object to a Python object](https://bioinformatics.stackexchange.com/questions/3943/convert-r-rna-seq-data-object-to-a-python-object)，通过查看这个页面提供的方案，我发现[seurat官网](https://satijalab.org/seurat/v3.1/conversion_vignette.html)提供了不同单细胞处理软件结果互通的转换方法。

![98691e781a906e3bf1774ce4a55e9f63.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/jiangxiaoyu/jiangxiaoyu_6.png)

seurat官网提供了`seurat对象`与`SingleCellExperiment`、`loom`、`AnnData`三种单细胞数据格式相互转换的方法。目前seurat（version 3.1）不支持写入scanpy要求的H5AD文件，所以目前的解决方案是：

1. Seurat对象转换为loom文件
2. Scanpy读取loom文件转换为能够操作的anndata对象

要是实现上面的两个简单的步骤还需要安装一些R和python包，需要安装的有以下几个，如果已经安装了，忽略就好：

* R包：[seurat](https://satijalab.org/seurat/install.html)
* R包：[hdf5r](https://github.com/hhoeflin/hdf5r)
* R包：[loomR](https://satijalab.org/loomR/loomR_tutorial.html)
* R包：[scater](https://bioconductor.org/packages/release/bioc/html/scater.html)
* python包：[scanpy](https://scanpy.readthedocs.io/en/stable/installation.html)
* python包：[loompy](http://linnarssonlab.org/loompy/installation/index.html)

> 安装好以上包之后，*`在R中执行以下代码`* ，实现第一步：`Seurat对象转换为loom文件`

```R
#读入seurat处理后的rds文件
library(Seurat)
library(loomR)

sdata <- readRDS(file = "/Users/yuanzan/Desktop/tmp/seurat_project.rds")
# seurat对象转换为loop文件
sdata.loom <- as.loom(x = sdata, filename = "/Users/yuanzan/Desktop/tmp/sdata.loom", verbose = FALSE)
# Always remember to close loom files when done
sdata.loom$close_all()
```

> 接着 *`在jupyter中执行以下代码`* ，实现第二步：`Scanpy读取loom文件转换为能够操作的anndata对象`

```python
import scanpy as sc
adata = sc.read_loom("/Users/yuanzan/Desktop/tmp/sdata.loom", sparse=True, cleanup=False, X_name='spliced', obs_names='CellID', var_names='Gene', dtype='float32')

marker_genes = ['Stfa1', 'Ngp', 'Ccl5', 'Ccl4', 'BC100530', 'Gzma', 'Gata2', 'Cd74']
ax = sc.pl.stacked_violin(adata, marker_genes, groupby='ClusterName', rotation=90)
```
初步产生的图和scanpy教程里一样，挑选的marker基因在各个亚群中的表达小提琴图，规则的排布在了一起，基本实现了当初的想法。

![4d2b58a4c8f94ba6f2acf69477bfc4b2.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/jiangxiaoyu/jiangxiaoyu_7.png)

再调一下参数，转换X轴和Y轴标签：

```python
ax = sc.pl.stacked_violin(sdata, marker_genes, groupby='ClusterName', rotation=90,swap_axes=True, save="_tmp.png")
```

![91c7fc5e195e3fb0b29ce0d891ca9dca.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/jiangxiaoyu/jiangxiaoyu_8.png)

到这里和文章里的图只差顺时针旋转90度了，于是查看了scanpy的源代码，发现是一个叫`stacked_violin`的函数调用的`seaborn.violinplot`实现的这个小提琴图，那我就copy一下这个函数，修改一些设置，让其由纵向增加小提琴图变为横向增加小提琴图就可以了。转念又一想还是不浪费时间了，“`用AI吧，简单操作一下就能搞定了`”，不知道从哪里冒出一个声音，真是可恶，那就简单实现一下旋转吧：

```python
from PIL import Image
import matplotlib.pyplot as plt
img = Image.open('./figures/stacked_violin_tmp.png')
img.transpose(Image.ROTATE_270)
```

![9ad9428dec37767f78607bbc743fc123.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/jiangxiaoyu/jiangxiaoyu_9.png)

多年以后，再次读起这些文字，我一定会回想起此时自己没等看到最后一行便已明白，自己不会再走出这故事。从一个围观的吃瓜群众到讲述这个故事再到成为故事一部分的我，应该很庆幸此时的参与。一切过往自永远至永远不会再重复，因为激发起相同兴趣的情形不会有第二次机会在大地上出现。

欢迎扫码关注生信微信公众号

![seqyuan](https://raw.githubusercontent.com/seqyuan/blog/master/images/jiangxiaoyu/seqyuan.jpg)
