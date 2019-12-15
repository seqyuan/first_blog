Title: 复现The most popular genes in the human genome
Date: 2017-11-30
Category: popular genes
Tags: matplotlib
Slug: The most popular genes
Author: seqyuan
Summary: 编程复现The most popular genes in the human genome文章两幅图形
 从14年入行接触编程至今除早期入门阶段外很少记编程笔记，更多的是从以前写过的程序里去找自己想要的东西，两年前写的主要代码的架构和重要元素依稀记得。

 前几天看到一篇文章《NATURE》长文：The most popular genes in the human genome，除了对文章的内容有很大兴趣之外，对于文中的图的精美也很向往，为了做matplotlib画图demo, 记录一些常用画图设置模板，我打算重现文中的两张图。

### 要重现原图如下
 第一幅图是一个条形图,展示了被研究次数最多10个的基因
 第二幅图展示了所有基因的研究次数及基因在染色体上的位置

 ![avatar](https://raw.githubusercontent.com/seqyuan/programs/master/plot/The_Most_Studied_Genes/N1.jpg)

 ![avatar](https://raw.githubusercontent.com/seqyuan/programs/master/plot/The_Most_Studied_Genes/N2.jpg)

### 下载的数据

 * 顺藤摸瓜，找到做这个项目的github：https://github.com/pkerpedjiev/gene-citation-counts

 * 发现人基因组所有基因被研究次数的文件https://github.com/pkerpedjiev/gene-citation-counts/all_gene_counts.tsv 果断下载

 * 要重现第二幅图还需要基因组大小文件以及着丝粒在基因组上的位置信息，所以需要下载http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/chromInfo.txt.gz，http://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/cytoBand.txt.gz

 * 在作者github这个项目的Issues里发现有人提了一个问题：你做的都是针对gene，尝试做一下ncRNA会有更有意思的东西发现吧。作者果断甩出一个文件链接gene_info_total_human.tsv，回答说所有的基因组元件citations信息都在这里，你感兴趣自己玩去。我果断下载之，发现文件中被研究最多的基因按照研究次数进行了排序，所以这个文件就作为了我重现第一幅图的数据源。ps：唯一的Issues已经被作者删除，当然包括gene_info_total_human.tsv的下载地址
 
### 第一幅图被重现，程序用法如下

`python3 The_Most_Studied_Genes.py -i gene_info_total_human.tsv -n 20`

### 第一幅效果如下

 ![avatar](https://raw.githubusercontent.com/seqyuan/programs/master/plot/The_Most_Studied_Genes/The_top10_citations.png)
 ![avatar](https://raw.githubusercontent.com/seqyuan/programs/master/plot/The_Most_Studied_Genes/The_top20_citations.png)

### 第二幅图照虎画猫

 输入参数就固定写了，程序和数据（all_gene_counts.tsv）放同一目录下，直接执行就会出结果，之所以没用gene_info_total_human.tsv作为数据源是因为gene_info_total_human.tsv不带有基因位置信息（省点事）

`python3 gene_on_chrom.py` 

### 第二幅效果如下

 ![avatar](https://raw.githubusercontent.com/seqyuan/programs/master/plot/The_Most_Studied_Genes/gene_on_chrom.png)

 通过与原图的对比我发现和文章结果是一些出入的，在top10基因的排名上，有些不同，也许作者两组数据的产生时间稍有不同。如果想彻底问清楚可以一步步重现作者的搜集数据步骤，自己做数据搜集工作。

 还有点不同是对于着丝粒区域的处理，我是按照比例显示，原图是给了固定的数值

### 发现
  
 X染色体上被研究最多的一个基因为AR(Androgen receptor),蛋白结构如下：
 
 ![AR PDB](https://raw.githubusercontent.com/seqyuan/programs/master/plot/The_Most_Studied_Genes/AR_PDB.png)

 在基因组上的位置

 ![avatar](https://raw.githubusercontent.com/seqyuan/programs/master/plot/The_Most_Studied_Genes/AR-gene.png)

### 源代码

  https://github.com/seqyuan/programs/master/plot/The_Most_Studied_Genes

### 微信公众号

 下图是我的微信公众号，会写一些生物信息相关的文章，欢迎关注。

 ![avatar](https://raw.githubusercontent.com/seqyuan/programs/master/plot/The_Most_Studied_Genes/seqyuan.jpg)
