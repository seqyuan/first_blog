Title: 单细胞多组学数据推断基因调控网络GRN
Date: 2020-03-13
Category: GRN
Tags: GRN
Slug: GRN
Author: ahworld
Summary: 活跃表达的TF与其靶基因组成的基因调控网络（GRN）对于细胞类型的决定与维持至关重要，本文详细介绍了这方面的综述

> 基因调控网络（GRN）决定并维持cell-type-specific的转录状态，这反过来又构成了细胞形态和功能的基础。每种细胞类型或稳定状态均由一组特异的转录因子与其靶标基因组合构成，在这个组合中活跃的转录因子（TFs）与基因组中的一组顺式调节区域相互作用并与染色质结构相互作用，从而产生特定的基因表达谱。

![GRN_1.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/GRN/GRN_1.png)

**`活性TFs及其靶基因的组合通常表示为GRNs`**。探索GRNs是基因组研究领域的主要挑战之一。一旦确定了驱动并维持细胞状态行为的关键regulators，它们最终就可以用来做干扰这些调控过程的切入点。比如，结合一组特异的TFs组合，将成纤维细胞重编程为诱导性多能干细胞（iPS）；许多其他的重编程途径也是通过特定的TFs组合驱动一个GRN来促使细胞状态的改变；最近在[癌症治疗](https://www.sciencedirect.com/science/article/pii/S0959437X17300096)中进行了尝试，使癌细胞转成一种易于受特定药物侵害的状态。

基于大规模转录组和表观基因组数据来计算预测GRNs是一个广泛研究的领域。但是诸如microarrays, RNA sequencing (RNA-seq), DHS-seq, ATAC-seq或者different methylation-seq methods等等，这些bulk技术衡量的是组织或样本中所有细胞的平均信号，在许多情况下，这种信号是由多种细胞类型组成的。虽然在某些情况下可以从组织中提取特定的细胞类型，例如通过FACS分选，但这需要特定标记的先验知识，并且无法识别新的细胞状态。利用单细胞技术，我们现在可以从单个细胞中收集组学数据，从而有了前所未有的机会来研究GRNs的异质性，并且揭示基因表达的随机（概率）性质和潜在的调控程序。由于这些原因，**调节基因组学**领域的研究正在大规模转向采用单细胞方法。

> 2018年发表的一篇综述`Fiers M W E J, Minnoye L, Aibar S, et al. Mapping gene regulatory networks from single-cell omics data[J]. Briefings in functional genomics, 2018, 17(4): 246-254.`比较全面的介绍了目前GRN的发展。

在这篇文章，作者讨论了最近发表的从单细胞转录组学数据推断GRNs的方法。与bulk data相比应该如何应对噪音水平、数据稀疏性以及数据量的增加的挑战。作者还讨论了如何使用单细胞表观基因组学的新技术（例如单细胞ATAC-seq和单细胞DNA甲基化谱图）来破译基因调控过程。作者期待着单细胞多组学和微扰技术的应用，这些技术将来可能在GRNs推断中发挥重要作用。

## Introduction
在背景介绍部分，作者介绍了如何利用单细胞多组学技术以结合算法，从不同层面阐释调控程序：从调控区的染色质状态到GRNs。

* 以目前应用最广的scRNA-seq开始，介绍如何将其用于检测一组共同被调控的基因集，并推断出潜在的主要的regulators。
* 此外，作者描述了最近发表的研究是如何利用GRNs来进行细胞聚类并细胞状态的转换。
* 接下来，作者讨论了单细胞表观基因组分析的进展，这些进展提供了研究基因调控的不同方法。详细介绍了单细胞染色质可及性、单细胞甲基化以及怎样整合多组学数据到每个细胞。每个细胞多组学数据的整合对单个细胞中GRNs的整合预测十分诱人，甚至可能使基因表达预测模型的最终目标触手可及。
* 最后，作者介绍了单细胞扰动分析，可能用于研究扰动GRNs（TF或增强子水平）对转录组的影响。这些微扰方法可用于验证预测，并且在不久的将来，它们将成为用于推断高精度GRNs的强大工具。

## GRN inference from scRNA-seq data
scRNA-seq是当今最常用的单细胞测序技术。汤富酬最早在2009年第一个发表之后，许多其他的scRNA-seq技术相继被开发出来。大多数方法遵循类似的方法，将改进的RNA-seq方案应用于以液滴或微孔分离的单个细胞。

但是，从单个细胞获得的转录组目前不如其对应的bulk样本那样灵敏或提供更多信息：由于生物学差异（例如，随机性，爆发）和技术局限性的结合，只对一个细胞中的总mRNA进行捕获，扩增和测序。

由于技术的局限性而未被检测到表达的基因称为缺失（dropouts），缺失的水平由每个细胞检测到的基因数的中位数来反映（尽管不同细胞类型可能导致差异），并且通常与实验规模（即测序的细胞数）进行权衡。

大量单细胞的测序，对于统计区分不同的细胞状态有很大帮助，并可能补偿某些噪音，但是很难获得低表达基因的结论。在评估TF时，这可能是一个特殊的问题，这些TF通常是低表达的。

> 数据处理过后，scRNA-seq数据会做成行列为基因和细胞的表达矩阵，矩阵中的数值为表达值。大多数scRNA-seq分析的重点是确定组织或癌症中细胞亚群的类型或状态，或研究动态变化过程，例如细胞分化、细胞周期或刺激反应。

**用于解决这些问题的计算方法包括**：
* [使用聚类算法将细胞分为不同的细胞类型或状态](https://www.sciencedirect.com/science/article/pii/S0098299717300493)
* [通过轨迹推断方法沿伪时间轴对细胞进行排序](https://onlinelibrary.wiley.com/doi/full/10.1002/eji.201646347)

> 从转录组学数据推断GRNs通常依赖于可以从表达模式中提取调控信息的假设。例如，具有相似行为的那些基因受共同机制（例如特异性的TF）的调节。依据这样的假设，调控网络（GRN）推断的目的可以是：

* 对导致细胞从一种状态转变成另一种状态的TF激活事件顺序进行建模
* 确定TFs潜在的靶标基因
* 鉴定一个细胞状态能够维持所依赖的特定主要regulators（或regulators组合）。

大多单细胞GRNs推断方法（下图）基于此，且与bulk数据开发的工具[[1](https://www.sciencedirect.com/science/article/abs/pii/S0010482514000420)[2](https://www.embopress.org/doi/full/10.1038/msb4100120)[3](https://www.nature.com/nmeth/journal/v9/n8/abs/nmeth.2016.html)]原理相同。

![GRN_2.png](https://raw.githubusercontent.com/seqyuan/blog/master/images/GRN/GRN_2.png)

##### **一类GRN推断方法**着重于解密在动态过程中，细胞从一种状态转换到另一种状态所需的TF逻辑组合

这通常是通过布尔网络模型实现的。例如Single-Cell Network Synthesis ([SCNS](https://link.springer.com/chapter/10.1007/978-3-319-21690-4_38)) toolkit和[BoolTraineR](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-016-1235-y)，通过将每个细胞进行状态分类（基于TF表达）并连接有限数量差异的细胞来构建布尔网络。生成的状态图能够让我们找到参与细胞状态改变的关键TFs，并可用于预测TF的过表达或敲除后的效果。但是，**这不涉及有关靶基因的信息**。

另外，网络规模的增加会导致计算量的迅速增加。因此，这些工具只能模拟少数基因（<100）。所以通常选择相关TFs子集，再结合这些方法应用于动态过程的轨迹推断步骤。

布尔网络的另一个缺点是将表达水平转换为二进制状态(基于阈值分为active/not active)，这使其无法可靠地建立剂量反应关系模型，并且对dropouts很敏感。

这些方法的应用实例包括[对iPS的重编程建模](https://www.sciencedirect.com/science/article/pii/S0092867412010215)以及[Moignard等人的工作](https://www.nature.com/articles/nbt.3154)，作者对血液发育的调控网络进行了建模，使用的是扩散图和SCNS toolkit分支轨迹。

##### 调控网络推断的另一种方法是：将TF与候选靶基因连接，最终目的是确定驱动特定细胞状态的“主要regulators”

此类别中的一种主要方法是基于共表达分析并已广泛用于bulk基因表达数据，例如[GENIE3](https://orbi.uliege.be/handle/2268/107580)和[WGCNA](https://link.springer.com/article/10.1186/1471-2105-9-559)。最近的研究已经成功地将相似的方法应用于单细胞数据。使用这些方法时需要考虑的要素包括以下假设：

* regulator表达水平的变化直接影响下游靶标的表达
* 忽略了转录后调控
* 忽略了并非所有co-varying基因都一定是直接作用的靶标
* 这些方法对normalization和batch-effects敏感，可能会引入人工协变量

基于共表达算法的其中一部分算法专门针对动态过程中的单细胞转录组数据构建GRN模型。这些方法结合细胞沿时间轴的初始顺序（或预测的轨迹），同时对基因和调节子之间的表达动态进行建模，使用的技术包括：(non-linear) correlation、regression、covariance analysis 、multivariant information 、ordinary differential equation (ODE)模型以及其他的模型。

**ODE**模型是这些模型中的一个特殊类别，它在时间序列上重构表达模式以检测和合并相似的模式。ODE系统允许推断某些因果关系，并且比其他方法更现实更详细。但是，它需要大量输入数据才能可靠地估计其参数，并且计算量很大，因此只能将它们应用于有限数量的TFs和靶标基因。

在研究一个没有轨迹信息的系统时，需要采取不同的方法。例如由多种不同（静态）细胞类型组成的组织。复杂组织异质性的研究通常专注于识别细胞类型以及表征它们的基因markers，但是进一步的调控分析并不常见。最新工具试图弥补这种gap，例如[SINCERA](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4658017/)和[ACTION](https://www.nature.com/articles/s41467-018-03933-2)这两个scRNA-seq 分析流程可以帮助寻找cell-type-specific的关键调控因子。

> 作者的实验室开发的[SCENIC](https://www.nature.com/articles/nmeth.4463)直接从数据中推断出GRN，通过将共表达与基序富集分析相结合，鉴定TFs与靶标基因之间调控关系。每一个细胞中的GRN活性用于鉴定细胞状态，关键TFs能够更精确地表征每个状态的特征。

*总之，早期结果表明，可以利用单细胞转录组学数据重建GRNs。进一步，使用（预测的）调控关系对单细胞数据集进行聚类是有利的，这对于理解细胞异质性至关重要*

## Single-cell epigenomics
单细胞表观基因组学提供了转录状态的补充描述，现在被表示为表观基因组图谱（epigenomic landscapes）。转录组是转录、转录后调控和RNA降解的结果。**表观基因组提供了一个更接近转录过程的视角**。一个表观基因组揭示了在每个状态下哪些调节区（例如增强子和启动子）起作用。单细胞表观基因组势必会增加对细胞（转录）异质性的了解，并在绘制GRNs时为scRNA-seq提供有价值的补充。

尽管做单细胞表观基因组学的方法很多，这里主要讨论是ATAC-seq和DNA甲基化，因为这些方法已应用于多种生物系统。

有两种实验方法可以执行scATAC-seq，一种是基于微流控平台（Fluidigm C1）进行物理分离的单细胞，另一种是基于组合索引（combinatorial indexing）的（sciATAC-seq），两种方法均源自原始的ATAC-seq协议，使用多能性Tn5转座酶同时切割和标记可及的染色质。**目前10X Genomics 公司已经推出商业化的10X单细胞ATAC-seq解决方案**。

关于从单细胞表观基因组及多组学联合揭示GRNs的方法及应用，总体滞后于scRNA-seq-based方法，这和各组学数据的获得难易程度及组学特点有很大关系，具体内容我在这里不再详述，大家有兴趣可以阅读原文献。

## 文章要点
* 调控基因组学领域正在朝着单细胞分辨率发展
* GRNs可以根据scRNA-seq数据进行逆向推断
* Single-cell GRNs可用于识别稳定的细胞状态和细胞状态转变
* 单细胞表观基因组学，单细胞扰动
分析和单细胞多组学提供令人兴奋的
揭开转录程序的机会
* 从scRNA-seq数据推断GRNs的方法发展迅速；从单细胞表观基因组学数据中揭示调控过程的方法比较滞后

## 相关阅读
[SCENIC | 以single-cell RNA-seq数据推断基因调控网络和细胞功能聚类](https://mp.weixin.qq.com/s/BggAc9zdwsz0yOtPOWzjmA)
















