
library("ggplot2")
library("DESeq2")
library(tools)
library(scde)

###################################################################################
#======== Reading the htseq count from a folder using DESeq methods===============
##################################################################################

# Generates the table from the histseq count. The counts has to be absolute counts
# Reading data from htseq-count Files
directory<-"/home/baker/Rna-seq Data Analysis/Single-cell RNAseq with SCDE/Single-cell_RNAseq with/htseq_count_files"
sampleFiles<-grep("JB",list.files(directory), value=TRUE)
sampleCondition<-c(rep("SingleCell_6",3), rep("SingleCell_7",4), rep("SingleCell_8",3), rep("SingleCell_9",3))
sampleTable<-data.frame(sampleName=file_path_sans_ext(sampleFiles), fileName=sampleFiles, treatment = sampleCondition)

# rep replicates elements of vectors and lists, rep(x, times) or rep (x, lenght.out)
# c() combines values into a vector or list. This way a vector or matrix is created
# The function factor is used to encode a vector as a factor. In factor the integer values are labled with the values in labels
treatment<-factor(sampleCondition,levels=c("SingleCell_6","SingleCell_7","SingleCell_8","SingleCell_9"), labels =c("SingleCell_6","SingleCell_7","SingleCell_8","SingleCell_9") )


ddsHTSeq<-DESeqDataSetFromHTSeqCount(sampleTable=sampleTable,directory=directory, design = ~treatment)

# Just getting the count without normalization
normCounts<-as.data.frame(counts(ddsHTSeq,normalized=FALSE))
write.csv(normCounts,"SingleCell_RNA_seq_Count.csv")

###################################################################################
###################################################################################
###################################################################################

# load example dataset
data(es.mef.small);
# factor determining cell types
sg <- factor(gsub("(MEF|ESC).*","\\1",colnames(es.mef.small)),levels=c("ESC","MEF"));
names(sg) <- colnames(es.mef.small); # the group factor should be named accordingly
table(sg);

# clean up the dataset
cd <- es.mef.small;
# omit genes that are never detected
cd <- cd[rowSums(cd)>0,];
# omit cells with very poor coverage
cd <- cd[,colSums(cd)>1e4];
# number of local process cores to use in processing
n.cores <- 4;
# calculate models
o.ifm <- scde.error.models(counts=cd,groups=sg,n.cores=n.cores,threshold.segmentation=T,save.crossfit.plots=F,save.model.plots=F,verbose=1);

# filter out cells that don't show positive correlation with
# the expected expression magnitudes (very poor fits)
valid.cells <- o.ifm$corr.a >0;
table(valid.cells)
o.ifm <- o.ifm[valid.cells,];

# estimate gene expression prior
o.prior <- scde.expression.prior(models=o.ifm,counts=cd,length.out=400,show.plot=F)

# define two groups of cells
groups <- factor(gsub("(MEF|ESC).*","\\1",rownames(o.ifm)),levels=c("ESC","MEF")); 
names(groups) <- row.names(o.ifm);

# run differential expression tests on all genes.
ediff <- scde.expression.difference(o.ifm,cd,o.prior,groups=groups,n.randomizations=100,n.cores=n.cores,verbose=1)
# top upregulated genes (tail would show top downregulated ones)
head(ediff[order(ediff$Z,decreasing=T),])
# write out a table with all the results, showing most significantly different genes (in both directions) on top
write.table(ediff[order(abs(ediff$Z),decreasing=T),],file="results.txt",row.names=T,col.names=T,sep="\t",quote=F)
scde.test.gene.expression.difference("Tdh",models=o.ifm,counts=cd,prior=o.prior)


