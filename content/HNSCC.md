Title: 以《致癌物或病毒介导的HNSCC免疫图谱》为例总结单细胞文章分析框架
Date: 2020-03-28
Category: single-cell
Tags: 细胞通讯
Slug: HNSCC
Author: ahworld
Summary: 详细解读《致癌物或病毒介导的HNSCC免疫图谱》，总结单细胞文章分析框架

上一篇我们分享的《[一文了解单细胞基因调控网络（GRN）](https://mp.weixin.qq.com/s/gKJMYFzJMIsRbpostEW_RA)》中有提过:
> scRNA-seq数据的表达矩阵之后大多数后续分析的重点是: 确定组织或癌症中细胞亚群的类型或状态，或研究动态变化过程，例如细胞分化、细胞周期或刺激反应。

用于解决上述问题的计算方法主要包括以下两方面：
> * 使用聚类算法将细胞分为不同的细胞类型或状态
> * 通过轨迹推断方法沿伪时间轴对细胞进行排序

**除了以上两点之外还可以通过分析配体（表面或分泌的）和受体表达来探究推测细胞外在相互作用--`细胞通讯`**

纵然大多文章的亚群聚类分析选择了R包[Seurat]( http://www.satijalab.org/seurat)，发育轨迹推断分析选择了[Monocle2](https://www.nature.com/articles/nmeth.4402)，但是我们在《[单细胞轨迹分析知多少--拟时间分析比较](https://mp.weixin.qq.com/s/6ZVTR3wpXrI2tdQpQEVwlQ)》这篇文章中也介绍过Monocle2并非做轨迹分析的万金油。要发高分文章有一个不错的选择是：`一个吸引人的生物学问题+自己开发的软件算法得到新的发现`。

> Cillo A R, Kürten C H L, Tabib T, et al. Immune Landscape of Viral-and Carcinogen-Driven Head and Neck Cancer[J]. Immunity, 2020.

例如2020年发表在Immunity上的这篇文章，在文章`DISCUSSION`的第一段结尾写的这样：
> 在这项研究中，我们使用了`新的生物信息学工具和方法`对**HNSCC致癌物介导的（HPV-）或病毒介导的（HPV +）致癌作用的TME患者中所有CD45+免疫细胞进行了深入分析**。 一般而言，我们的实验和分析方法可用于分析样本组之间细胞组成和转录状态不同的任何异质细胞群体。

瞧瞧，是不是有内味儿了，高分文章的标配。

上面提到的`新的生物信息学工具和方法`就是以下几个：

* [DRAGON](https://github.com/arc85/dragonsc)：用于scRNA-seq数据的聚类
* [singleseqgset](https://github.com/arc85/singleseqgset)：用于基因集富集分析，分群之后可以用它结合marker基因做亚群的功能鉴定等
* [celltalker](https://github.com/arc85/celltalker)：从scRNAseq数据预测配体和受体相互作用

除此之外，文章中用于轨迹推断的方法是不同于一般算法的`Diffusion map`，这种算法对于大数据集的项目的处理相较于Monocle2要好太多。

Diffusion map算法做轨迹推断分析在2016年发表的[destiny](https://academic.oup.com/bioinformatics/article/32/8/1241/1744143)和[DPT](https://www.nature.com/articles/nmeth.3971)两篇文章有原理介绍，后续我会做一个使用教程。*linux下非root账号通过singularity运行[dyno](https://mp.weixin.qq.com/s/3rRbGeRR5PU-pwpww4TqPQ)的坑还没有填上* ┗( T﹏T )┛

既然说到了`celltalker`，我们就以这篇文章为例看一看scRNA-seq数据分析框架

**样品情况**
![HNSCC_01.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_01.png)
**文章分析框架**：这块本想做文字介绍，发现做成鱼骨头可能更清晰一些，具体的分析内容就看后文的文章详细解读章节吧。有了这个图在看文章时便会时刻清楚文中分析内容在整体框架中的的定位，不犯迷糊。
![HNSCC_02.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_02.png)
想看的更清楚可以从以下网址下载
> **百度云链接**:https://pan.baidu.com/s/1ZttS8Ezx_ruLswWURpkTyw
> **密码**:hj3c

文章全篇围绕病毒和变异引起的HNSCC这一生物学问题寻找他们在各类免疫细胞的异同。具体的解析请看后面的文章详细解读。

文章1点细节需要改正：

* Figure S2B，中间图的ylabel应该为FItSNE_2
![HNSCC_03.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_03.png)


# 文章详细解读
## Highlights

* HPV-和HPV+ HNSCC中的单细胞RNA-seq在显示出迥异的免疫谱
* 高维分析显示B细胞，髓系细胞和CD4+ Tconv细胞发散状
* 多光谱成像发现与HPV+疾病相关的免疫结构（TLS）
* T滤泡辅助标志与TCGA病人的良好生存相关

## SUMMARY
HNSCC通常是由于暴露于致癌环境或者HPV恶性转移引起的。这篇文章评估了来自HPV-和HPV+ HNSCC患者以及健康供体的外周和肿瘤内免疫群体中131,224个单细胞的转录谱。HPV和HPV HNSCC肿瘤内的免疫细胞展示了一系列的转录特征，其中辅助CD4 + T细胞和B细胞相对发散，而CD8+ T细胞和CD4+ 调节性T细胞相对相似。转录组的结果结合多光谱免疫荧光分析，基于空间邻近性分析推断细胞与细胞之间的通讯。这些分析定义了与CD4+ T卵泡辅助细胞相关的基因表达特征，该基因表达特征与HNSCC患者中更长的无进展生存期有关。这篇文章的数据集和分析方法为进一步研究免疫细胞对病毒和致癌物诱导的癌症的影响提供了资源。
![HNSCC_04.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_04.png)

## INTRODUCTION
头颈部鳞状细胞癌（HNSCC）在全球每年发生近60万例，大多数患者出现局部晚期疾病。HNSCC可能是由于暴露于致癌物（酒精或烟草）引起的遗传改变，也可能是由于HPV感染后发生的恶性转化而引起的。虽然大多数HNSCC与烟草使用相关，在西部，HPV+ HNSCC的发生率已大幅上升，并且呈上升趋势。现在，美国有一半的HNSCC病例是由高危HPV感染引起的。

在临床上，HPV+ HNSCC患者相较于HPV- HNSCC患者具有更好的总体生存率。在HNSCC中也观察到了肿瘤浸润免疫人群的差异：HPV+ HNSCC中存在较高的肿瘤内B细胞频率，HPV–HNSCC中功能失调的CD8+ T细胞发生的频率更高。**致癌物诱导的和病毒诱导的癌症的二元性是HNSCC的一个独特方面**，`并提供了机会来评估发生在相似解剖位置的两种不同癌症病因的免疫状况差异`。

传统上，HPV-和HPV+ HNSCC均通过外科手术，化疗和放射线进行治疗。这些疗法通常与明显的发病率相关，许多患者在3-5年内复发，导致预后不良和缺乏其他治疗选择。免疫疗法为癌症的治疗创造了新的范例，最近的临床试验证明了靶向免疫检查点的功效。免疫疗法治疗HNSCC同样可以给患者带来生存益处，这表明免疫系统可以靶向实现HNSCC的临床获益。尽管取得了临床上的成功，但只有约20％–30％的HNSCC患者在PD-1或PD-L1阻断后获得生存获益，这强调了需要更好地了解HNSCC肿瘤微环境中免疫系统状态生物学的复杂性。对免疫细胞状态的进一步了解将有助于识别与当前可用的免疫疗法或反应性相关的特征（或者相反，缺乏反应性），将为临床中单剂和多剂免疫疗法的发展提供信息。同样，比较HPV–和HPV + HNSCC中的免疫谱也是确定开发新的免疫疗法靶标的细胞类型和分子的先决条件。

这篇文章，作者通过单细胞RNA测序（scRNA-seq）分析和多光谱免疫荧光（IF）比较了未经治疗的HNSCC中由突变与由病毒引起的癌症的免疫状况。分析了肿瘤微环境（TME）中的空间定位模式和细胞邻域的特征。分析提供了有关HPV+ 和HPV HNSCC的免疫谱系以及这些细胞的转录状态和分化轨迹。细胞cross-talk与肿瘤的进展的潜在关联。此外，这篇文章的分析`定义了一个具有临床预后潜力的基因集`。这些数据集和分析方法为进一步研究病毒和致癌物诱发癌症的免疫贡献提供了资源。

## RESULTS
### Single-Cell Survey of Immune Lineages in HNSCC
![HNSCC_05.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_05.png)
血液学来源的活细胞的单细胞转录组来源是：术后立即从18例HPV- HNSCC患者和8例HPV+ HNSCC患者的原发肿瘤获得的配对血液和组织中分离出CD45+细胞，所有患者均未接受免疫治疗。作为对照，以下样本也做了单细胞转录组测序：1）5个独立的睡眠呼吸暂停患者（无癌症）的扁桃体组织中分离的CD45+细胞；2）6位健康捐赠者的外周血单核细胞(PBMCs)。总共131224个通过质控的个体免疫细胞，平均表达1262个基因。

![HNSCC_06.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_06.png)
根据scRNA-seq数据构建的Pseudobulk表达矩阵做样品表达相关性，结果显示：**样品会根据PBMC和组织来源分离**，肿瘤浸润性白细胞（TILs）和扁桃体样品分离成簇。

![HNSCC_07.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_07.png)
png
作者对**PBMC和TIL Pseudobulk表达做了对比**，最大的不同在于：PBMC中表达的大多是外周血骨髓细胞相关的基因（例如LYZ和FCGR3A）；TIL中大多高表达免疫调节基因（例如CTLA4和IDO1）和炎性细胞因子（例如IFNG和IL1B）。

![HNSCC_08.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_08.png)
在TIL clusters的分析中，作者发现clusters 3、4与来自扁桃体组织的clusters 1的样品共享了部分表达模式，包括B细胞（MS4A1和CD19）和活化的T细胞基因（CD3D和HLA-DRB5），但也表达了与TIL不同的一小簇细胞毒性基因（例如GZMB）。

总体而言，Pseudobulk RNA-seq分析显示PBMC和TIL样品之间的基因表达有很大不同。提示了与HPV–和HPV+ TIL之间的差异性浸润和转录状态相关的亚结构。

![HNSCC_09.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_09.png)

作者开发了[DRAGON](https://github.com/arc85/dragonsc)算法对细胞进行分群，DRAGON和Louvian聚类的表现相似，但基于不同的框架。DRAGON确定的26个cluster通过基于快速傅里叶变换加速插值的t分布随机邻居嵌入（[FItSNE](https://github.com/KlugerLab/FIt-SNE)）进行了可视化。

![HNSCC_10.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_10.png)

为了鉴定主要的免疫谱系，作者在用DRAGON聚类的时候设置了相对较高的温度参数(Temperature = 45)，所有细胞总共分为4个cluster：

![HNSCC_11.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_11.png)

![HNSCC_12.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_12.png)
发现这4个cluster之间的差异表达基因与以下4类细胞密切相关：

* CD4+ T细胞
* B细胞
* 细胞毒性细胞（CD8+ T细胞和自然杀伤性[NK]细胞）
* 髓系细胞

接着，作者对这4个cluster分别进行亚群细分，以根据规范的基因表达模式识别细胞类型。

![HNSCC_13.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_13.png)
推断的细胞类型与通过流式细胞仪在部分患者的配对样品上鉴定的细胞类型密切相关。
![HNSCC_14.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_14.png)
以下是4个亚群细分后映射到完整数据集FItSNE上的结果：
![HNSCC_15.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_15.png)
下图为不同样本细胞的FItSNE分布
![HNSCC_16.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_16.png)

为了量化HPV-和HPV+ TILs主要免疫谱系之间的改变，作者使用Bhattacharyya距离测量了每种肿瘤类型的免疫谱系之间的距离。
![HNSCC_17.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_17.png)

* 该分析揭示了HPV-和HPV+ TIL之间的B细胞，髓样细胞和常规CD4+（Tconv）细胞之间存在很大差异
* CD8+ T细胞和CD4+调节（Treg）细胞更为相似

## CD8+ T Cells Have a Continuous Differentiation Trajectory
作者挑选CD8+ T细胞，并重新聚类为8个亚群，TILs的CD8+ T细胞最常见于第1–4群，而PBMC和扁桃体的CD8+ T细胞更常见于第5–8群。
![HNSCC_18.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_18.png)

差异表达基因分析发现：控制每个亚群的基因迥异

![HNSCC_19.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_19.png)


1.  `cluster 1`与周期细胞相关(e.g., MKI67)
2.  `cluster 2`与干扰素（IFN）应答基因（e.g., ISG15）相关
3.  `cluster 3、4`表达耗竭免疫检查点相关基因（e.g., PDCD1 [gene for PD-1] and CTLA4 and HAVCR2 [gene for TIM3]）
4.  `cluster 5`通常是静止的并且表达低水平的效应子分子（e.g., GZMH和KLRD1）
5.  `cluster 6`与naiv 或memory细胞相关(e.g., CCR7和CD27)
6.  `cluster 7`表达与早期激活相关的基因（e.g., JUNB和FOSB）
7.  `cluster 8`表达的基因与效应子功能相关（e.g., KLRG1和GZMH）

作者使用自己实验室开发的[SingleSeqGset](https://github.com/arc85/singleseqgset)采用竞争性基因集实施富集检验，评估这些cluster相关的生物学功能。

CD8+ T细胞相关的`cluster 3`中co-simulation上调，`cluster 4`中缺氧信号和INF响应。

作者使用一种非线性降维技术`Diffusion Map`来推导分化轨迹。2维Diffusion map揭示了一条平滑的轨迹，该轨迹将PBMC连接到TIL，而对于HPV+和HPV- TIL则重叠：
![HNSCC_20.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_20.png)
下图是各cluster细胞在2维Diffusion map中的展示：
![HNSCC_21.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_21.png)
作者鉴定了与每个扩散成分相关的基因来表征两个扩散成分（DC1和DC2），DC1与终末分化表型密切相关，沿着DC1的进展与抑制性受体的共表达增加相关；DC2与由CD27，CCR7，EOMES和与记忆形成相关的其他基因的共表达控制的记忆表型相关
![HNSCC_22.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_22.png)

> 总之，确定了CD8+ T细胞群，并推断出肿瘤类型之间共有的分化轨迹。这表明针对CD8+ T细胞的免疫治疗策略可能适用于病毒和致癌物诱导的HNSCC。

## Extensive CD4+ Tconv Heterogeneity and Differentiation Trajectories
在这一部分，作者比较了HPV-和HPV+ HNSCC之间CD4+ T细胞的转录情况，`分别对CD4+ Tconv细胞和CD4+ Treg细胞进行了分析`。
![HNSCC_23.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_23.png)
#### CD4 Tconv细胞聚为7类
基因集富集分析显示：
**PBMC衍生的CD4 Tconv细胞中**：
* `cluster 2`富集了与naive和memory相关基因
* `cluster 3`富集了effector memory相关基因
* `cluster 5`富集了effector和central memory相关基因

![HNSCC_24.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_24.png)

**来自TIL的CD4 Tconv细胞中**：
* `cluster 1、6`大部分由HPV TIL和扁桃体（Tonsil）CD4 Tconv细胞组成
* `cluster 4、7`大部分是来自HPV- TILs的CD4 Tconv细胞

**Tonsil和TIL CD4 Tconv细胞显示出一系列相互关联的T滤泡辅助物（TFH）和1型辅助物（TH1）特征，并带有效应记忆特征。**

作者对CD4 Tconv细胞的样本类型与聚类之间的关系进行了统计学评估，发现HPV+ TIL与HPV- TIL相比，在该聚类中具有显着的细胞富集（p = 0.0044，秩和检验）
![HNSCC_25.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_25.png)
![HNSCC_26.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_26.png)
##### 接下来作者用Diffusion map重建CD4 + Tconv细胞的分化轨迹
![HNSCC_27.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_27.png)
三维Diffusion map显示CD4+ Tconv的分化轨迹 产生了分支，这点与CD8+ T细胞不同。

接下来，作者对源自HPV–和HPV+ TIL的CD4+ Tconv细胞的DC1，DC2和DC3之间的回归平面进行拟合，发现肿瘤类型之间的分化平面显着不同：
![HNSCC_28.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_28.png)
将Diffusion map的前两维与推断的Diffusion pseudotime(DPT)放到一起查看，结果很明显，DC1和DC2都与DPT正相关，彼此基本呈正交。
![HNSCC_29.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_29.png)

与基因集富集分析一致，cluster 2是最初的cluster，然后细胞通过连续的中间表型，向cluster 1或cluster 7定义的终态发展，cluster1和cluster7之间的top差异表达基因未发现与TFH相关的基因，与cluster1相关的激活，INF反应以及与cluster7相关的记忆基因。

![HNSCC_30.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_30.png)
接下来，作者评估了与每个Diffusion components相关的基因，并发现CXCR5和PDCD1与DC1的表达之间有很强的联系。热图显示了来自cluster1和cluster7的前50个差异表达基因，通过Diffusion分析显示了两个末端分支。cluster1与T滤泡辅助（TFH）表型相关，而cluster7具有效应记忆表型。

![HNSCC_31.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_31.png)
把CXCR5和PDCD1放在三维图中与DC1和DPT一起查看时，发现CXCR5和PDCD1是双峰，相对于DPT在DC1的早期和晚期都有共表达，与早期激活过程中的表达以及处于分化的TFH状态一致。

结果还显示在CXCR5和PDCD1共表达明显的同一点上其他已知抑制性受体（LAG3和HAVCR2）的共表达。这表明了在DPT早期的命运决定中，细胞既可以进展为CD4+ TFH；又可以采用与抑制受体共表达的表型，潜在抑制进一步分化。

总之，结果展示了与HPV+和HPV- HNSCC相关的CD4+ Tconv细胞的独特分化轨迹。

#### Reciprocal IFN- and TNFR-Related Signaling in CD4+ Treg Cells

CD4+ Treg细胞可抑制TME中的抗肿瘤免疫反应，最近在肺癌和乳腺癌中的研究已经描述了TME中Treg细胞的独特转录状态。

![HNSCC_32.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_32.png)

> `附件图为7个亚群，正文图6个亚群应该主要来自TIL Treg cells`

![HNSCC_33.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_33.png)
CD4+ Treg细胞主要由来自TIL的细胞组成。

##### 使用DRAGON对CD4+ Treg细胞分成6个亚群
对每个群做基因集富集分析，以表征每个群中的生物学功能。
![HNSCC_34.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_34.png)

*  `clusters 2、4` 富含与IFNa应答相关的基因集（IFN应答基因[Browne]）和广普的IFN应答基因（IFN诱导的抗病毒模块[Bosco]）
*  `clusters 3、6` 富含肿瘤坏死因子受体（TNFR）家族信号通路

> IFN反应和TNFR信号传导相关的模块是互斥的，表明这些细胞对不同信号的反应取决于它们的分化状态。

![HNSCC_35.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_35.png)
CD4+ Treg细胞的Diffusion map显示DPT与DC1密切相关，在DPT早期，来自HPV- TILs的Treg细胞更多。
![HNSCC_36.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_36.png)
与基因集富集和簇cluster推断的表达模式一致，结果显示TNFRSF18（GITR），TNFRSF9（CD137，4-1BB）和TNFRSF4（OX40）与DC1正相关，并在DPT晚期共表达。这一结果支持了TNFR超家族对于维持效应Treg细胞群体很重要的观点。相反，结果显示IFN反应基因IFITM1，IFIT1，IFIT3和ISG20在DPT早期时表达，并随着伪时间的进展而关闭。**这表明IFN信号在Treg细胞的早期活化中具有潜在作用**。

> 综上所述，该分析表明，Treg细胞在HPV–和HPV+ HNSCC之间具有相似的轨迹（尽管在不同状态下频率不同），并且在分化过程中IFN相关信号和TNFR家族信号相互相关。

## Germinal Center B Cells Are Found in HPV+ TILs
HPV+ TILs中发现了`生发中心B细胞`

TME中的B细胞与人类肿瘤类型的总体生存呈正相关已经被广泛报道，并且会影响CD4+ Tconv细胞表型。
![HNSCC_37.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_37.png)

##### B细胞聚类为11个亚群

* 来自HPV+ TIL和扁桃体组织的B细胞在`cluster 1-4`中大量富集，而来自HPV- TIL的B细胞则主要存在于`cluster5、7`中。
* 基因集富集分析确定了`cluster 6、9`为naive细胞
* `cluster 8、11`为记忆细胞
* `cluster 5`为浆细胞
* `cluster 1、4`为生发中心B细胞

细胞周期和生发中心基因集的重叠富集意味着cluster 3和cluster 4是中心母细胞，与在暗区中快速增殖的B细胞一致。相反，cluster 1和cluster 2也富集生发中心基因集，但缺乏细胞周期基因的表达，这表明这些细胞是亮区的中心细胞，在此处它们受到CD4+ TFH的选择。

![HNSCC_38.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_38.png)

与HPV+ TIL相比，HPV- TIL中的B细胞通常是浆细胞（cluster 5）或switched memoryB细胞（cluster 7），在HPV–TIL状态下仅存在血浆或早期切换的记忆B细胞可能与缺乏CD4 + TFH帮助相一致。

![HNSCC_39.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_39.png)

B细胞的Diffusion map显示了跨多轴分化的复杂过程：`DC4与从naive发展到memory B细胞的进展有关`。DC1在DC4的最小值和最大值之间与DC4相交，并且沿着DC1从右向左依次发育（最右`cluster 6、9`为naive细胞），与生发中心的形成有关。

与HPV- HNSCC中生发中心B细胞较少相一致，HPV- HNSCC中的B细胞向DC1的正值富集（上图F），浆细胞（cluster 5）的位置更靠近memory B细胞（cluster 8、11），这与生发中心反应的释放一致。

**对HPV-与HPV+ HNSCC的TME中B细胞的分析得出的结论是**：

> * 通过HPV+ HNSCC中的生发中心反应，生发中心B细胞存在于各个发展阶段
> * 在HPV–HNSCC中，发现的B细胞数量较少且处于非生殖器中心状态

## A Common Trajectory Yields Divergent Myeloid States
髓样细胞在形成TME中的免疫反应中起重要作用，可大致分为`肿瘤相关巨噬细胞`（TAM）和`树突状细胞`。TAM通常被认为是抗肿瘤或促肿瘤的（i.e., M1-like or M2-like, respectively）。 最近的研究揭示了TME中髓样细胞更广泛的异质性，例如：乳腺癌中TAM共同表达了M1和M2的特征（Azizi等人，2018），以及肺癌中髓样细胞的独特状态（Lavin 等人，2017）。
![HNSCC_40.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_40.png)
###### 髓样细胞分成了8个亚群

* `cluster 2-4`主要存在于PBMC中
* `cluster 1、5-8`主要存在于TIL中

![HNSCC_41.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_41.png)
通过分析不同亚群top差异基因，对亚群进行了细分命名：

* `cluster 2`鉴定为CD16+的单核细胞
* `cluster 3、4`鉴定为CD14+的单核细胞

重要的是，`cluster 3`低表达的FCGR3A（CD16基因），表明它是唯一的CD14+ 单核细胞群，而不是CD14+ CD16+ 单核细胞的过渡种群。

在**TIL**中，`cluster 5、7`似乎是高度分泌的，表达高水平的趋化因子和细胞因子。

`cluster1、6和8`表达相对较高水平的人类白细胞抗原（HLA）分子，与抗原呈递细胞一致，但在几个方面有所不同：

1. cluster 1高表达IDO1，CCL17和CCR7
2. cluster 6表达CD1C（与常规树突状细胞一致）
3. cluster 8表达补体相关基因，也表达了规范的M2标记MRC1（CD206的基因），尽管不是top差异表达基因

在HPV- TILs中在第1和第8群比例更高，提示HPV-疾病患者具有潜在的免疫抑制作用。

###### 髓样细胞发育分析
![HNSCC_42.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_42.png)
![HNSCC_43.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_43.png)

Diffusion map坚定了髓样细胞的几个分支。

* `cluster 5`对于TME中髓样细胞的命运至关重要，因为`cluster 5`将来自PBMC的CD14+ 单核细胞连接到TIL群体，并提示PBMC和TIL CD14+ 单核细胞之间的表达状态出人意料的平稳过渡（上图F）
* 在DC1和DC2轴上的正方向上，cluster 5向cluster 7、8前进，cluster 7、8表示该轨迹的一个末端分支
* `cluster 6`似乎是从cluster 5中出现，横跨cluster 5朝着cluster 7、8的发育轨迹，表明沿着这种分化轨迹可能具有可塑性
* `cluster 8`似乎是一个不成熟的树突状细胞群，因为它在共同的轨迹上先于更成熟的树突状细胞（cluster 6）

TME中髓系谱系的鉴定表明，TAM超出了标准的M1或M2范式，细胞状态之间的平滑过渡以及一些树突状细胞群。



## Global Crosstalk between Immune Cells
> 单细胞转录组学分析不仅可以揭示细胞内在信息，而且还可以通过分析配体（表面或分泌的）和受体表达来探究推测细胞外在相互作用。 

https://www.nature.com/articles/ncomms8866
为了绘制可能的细胞间相互作用，我们首先使用[708个独特的配体和691个独特的受体的清单](https://www.nature.com/articles/ncomms8866)来鉴定配体/受体的表达，它们可以共同形成2557个潜在的相互作用对。

![HNSCC_44.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_44.png)

上图为HPV- 和HPV+ HNSCC中表达的顶级配体和受体。

> 作者开发了R包[CellTalker](https://github.com/arc85/celltalker)以在更广泛的范围预测潜在配体和受体，用于评估细胞间通讯。

使用CellTalker，作者鉴定了168个配体和194个受体，它们参与了481个独特的相互作用。

![HNSCC_45.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/HNSCC/HNSCC_45.png)

CellTalker的结果展示在以上circos图中，每种相互作用都描绘为跨细胞类型配体与受体连接的线。

相互作用大致分为三种类型：

1. **常见相互作用（在至少一种其他样品类型中发生）**
2. 与健康的供体PBMC相比独特的互作
3. 与所有其他样品相比独特的互作的类型

尽管PBMC和扁桃体样本中存在许多预测的相互作用，但在TIL人群中，预测的相互作用大规模扩张。

除了在TME中增加了细胞间通信之外，结果还发现了HPV-和HPV+ TIL中独特的通信。尽管从全局的角度来看很有用，但了解免疫细胞彼此之间的空间定位将为基于邻近性评估预测的细胞通讯提供更为严格的框架。

## Spatial Organization Is Consistent with Transcriptional Signatures
取了24个病人共90个感兴趣的区域(ROIs)，平均2–5 ROIs/slide。这部分的分析不再展开来讲，有兴趣可以看文章原文。总之结合空间临近信息，使细胞通讯分析更加严格，结果更加可信。

> 免疫细胞通讯分析如果结合能提供更多信息的10X Genomics空间转录组解决方案将会有更多发现。
















