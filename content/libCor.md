Title: Hi-C文库相关性分析
Date: 2019-12-15
Category: Hi-C
Tags: Hi-C
Slug: libcor
Author: seqyuan
Summary: 

Hi-C分析需要的测序量比较高，1个样本往往需要测序很多的数据量，1个Hi-C文库可测序的数据量有限（一般情况下100-300G PE150，超出这个量，多测的数据可能含有较高的PCR dup），所以1个样本往往需要建几个文库来保证总的测序量足够。相同样本不同文库产生的数据需要有比较高的重复性，才能用于后续分析

> 为了计算方便，开发了一个R脚本hicLibRepeatCor.R用于Hi-C文库相关性分析，计算两两Hi-C文库的cis矩阵相关性，对所有文库的相关性矩阵做聚类热图,用于衡量判断样本文库的重复性，和不同样本文库的差异

### 程序地址
https://gitlab.com/seqyuan/ctools/blob/master/module/CQC/libCor/hicLibRepeatCor.R

### 程序用法
`Rscript hicLibRepeatCor.R <lib_matrix.list> <binsize> <outdir>`

### 参数说明
#### lib_matrix.list
此参数为每一个文库的matrix列表，示例如下：

| wt1 | 1000000 | /abspath/wt1_1000000_symmetric.matrix | /abspath/wt1_1000000_abs.bed |
|-----|---------|---------------------------------------|------------------------------|
| wt2 | 1000000 | /abspath/wt2_1000000_symmetric.matrix | /abspath/wt2_1000000_abs.bed |
| tr1 | 1000000 | /abspath/tr1_1000000_symmetric.matrix | /abspath/tr1_1000000_abs.bed |
| tr2 | 1000000 | /abspath/tr2_1000000_symmetric.matrix | /abspath/tr2_1000000_abs.bed |

1. 第一列：文库的命名
2. 第二列：对应行矩阵的bin size
3. 第三列：文库矩阵，格式同[HiC-Pro](http://nservant.github.io/HiC-Pro/RESULTS.html#intra-and-inter-chromosomal-contact-maps)软件buildMatrix产生的3列矩阵的格式
4. 第四列：染色体位置与bin number对应关系bed文件，格式`HiC-Pro`软件buildMatrix产生的bed文件

#### binsize
数字型，选择`lib_matrix.list`参数中第二列与`binsize`参数相同的matrix去做文库相关性分析
#### outdir
输出目录
### 输出结果示例
此程序会输出3个结果文件

* pair.pdf
* corr_heatmap.pdf
* cor_matr.matrix

#### pair.pdf
![avatar](https://gitlab.com/seqyuan/ctools/raw/master/module/CQC/libCor/fig/pair.png)
![avatar](https://gitlab.com/seqyuan/ctools/raw/master/module/CQC/libCor/fig/alllibpair.png)

#### corr_heatmap.pdf
![avatar](https://gitlab.com/seqyuan/ctools/raw/master/module/CQC/libCor/fig/corr_heatmap.png)
![avatar](https://gitlab.com/seqyuan/ctools/raw/master/module/CQC/libCor/fig/alllib_corr_heatmap.png)

#### cor_matr.matrix
`corr_heatmap.pdf`的数据文件，对于有编程经验的用户可以自己再去根据自己的喜好去画热图

|  |wt1                |wt2                |tr1                |tr2                   |
|-----|-------------------|-------------------|-------------------|-------------------|
| wt1 | 1                 | 0.994581416401839 | 0.946872471200991 | 0.946223805271397 |
| wt2 | 0.994581416401839 | 1                 | 0.947224994844614 | 0.946685529296875 |
| tr1 | 0.946872471200991 | 0.947224994844614 | 1                 | 0.995740232735047 |
| tr2 | 0.946223805271397 | 0.946685529296875 | 0.995740232735047 | 1                 |

例如可以用以下python代码画图

```python
import pandas as pd
import matplotlib
import matplotlib as mpl
# matplotlib.use('TkAgg') # for macbook
# matplotlib.use('Agg') # linux or win
import matplotlib.pyplot as plt
import seaborn as sns

df = pd.read_table("cor_matr.matrix", header=0, index_col=0 )
sns.clustermap(df, cmap=sns.color_palette("RdBu_r", 7000))
plt.show()
```

效果

![avatar](https://gitlab.com/seqyuan/ctools/raw/master/module/CQC/libCor/fig/sns_corr_heatmap.png)
![avatar](https://gitlab.com/seqyuan/ctools/raw/master/module/CQC/libCor/fig/sns_6corr_heatmap.png)

### 程序依赖包
R环境需要安装以下两个R包才能使用此程序
*  [HiTC](http://www.bioconductor.org/packages/release/bioc/html/HiTC.html)
*  `pheatmap`
