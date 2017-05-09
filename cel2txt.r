    # RUN_GENORMALIZE.R Normalize Affy gene expression data using different algorithms
#
# R CMD BATCH --slave '--args celfile=<filename> outfile=<filename> cel2txt.r
#
# Input arguments to script:
# celpath: Folder where CEL files are stored
# celfiles: text file with list of CEL files to precess (one file per line)
# outfile: output file for gene expression data
# method: normalization method to use, 

args <- commandArgs(TRUE)
nin <- length(args)
# default mas5 method
mas5Method <- 'simpleaffy'

#cat (args,nin,"\n")
if (nin >= 2)
  {
    for (a in args) {
      v = strsplit(a, '=')[[1]]
      switch(v[1],
             celfile =  celFileName <- as.vector(v[2]),
	     outfile = outFile <-v[2],
             mas5method = mas5Method <-v[2],
             )
    }

    cat (celFileName,outFile,mas5Method,"\n")
    
    library(affy)
    library(simpleaffy)
    
    cat("Reading Celfile\n")
    affyDat<-ReadAffy(filenames=celFileName)
    ## Fix NaN's, breaks MAS5
    bad<-which(is.na(exprs(affyDat)))
    if (length(bad)>0)
	{
	cat(length(bad), 'NaNs found in CEL file, setting to zero...\n')
	exprs(affyDat)[bad]<-0.0
	}
    chip <- toupper(cdfName(affyDat))
    numFeatures <- length(geneNames(affyDat))
    cat("Computing MAS5\n") 

    ## 3 equivalent ways of computing mas5   
    ## Using simpleaffy library (fastest)
    if (mas5Method=='simpleaffy')
      {
        cat("Using simpleaffy mas5\n")
        x.mas5 <- call.exprs(affyDat, 'mas5')
        x.mas5 <- round(2^exprs(x.mas5),2)
      }
    else if (mas5Method=='affy')
      {
        cat("Using affy mas5\n")
        ## Using MAS5 from the affy library
        x.mas5<- mas5(affyDat,sc=100)
        x.mas5 <- round(exprs(x.mas5),2)
      }

    ## Using Expresso from affy library
    #x.mas5 <-expresso(affyDat, pmcorrect.method="mas", bgcorrect.method="mas", summary.method="mas")
    #x.mas5 <- affy.scalevalue.exprSet(x.mas5, sc=100)
    #x.mas5 <- round(exprs(x.mas5),2)
    
    cat("Computing Pcalls\n")
    x.pcalls <- exprs(mas5calls(affyDat))
    df <- data.frame(rownames(x.mas5),x.mas5,x.pcalls)
    colnames(df) <- c('NAME','MAS5','PCALLS')
    
    ## Write output
    fid <- file(outFile, "w")
    cat("#TXT_VIA_R_MAS5\n", file=fid)
    #bn <- strsplit(celFileName,'.CEL$|.CEL.gz$')[[1]]
    bn <- strsplit(basename(celFileName),'.CEL$|.CEL.gz$')[[1]]
    cat("#NAME:", bn, "\n", file=fid)
    cat("#CHIP:", chip ,"\n", file=fid)
    cat("#NUM_FEATURES:", numFeatures, "\n", file=fid)
    write.table(df, col.names=T, row.names=F, sep="\t", quote=F, file=fid, append=TRUE)
    close(fid)
    
  } else
  {
    cat ("CEL2TXT.R Get mas5 summarization and present/absent calls for a single Cel file")
  }

