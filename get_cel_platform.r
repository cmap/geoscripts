# GET_CEL_PLATFORM.R Get the Affymetrix platform for a given cel file
#
# R CMD BATCH --slave '--args celfile=<filename>' get_cel_platform.r
#
# Input arguments to script:
# celfile: CEL filename

args <- commandArgs(TRUE)
nin <- length(args)

#cat (args,nin,"\n")

if (nin == 1)
  {
    for (a in args) {
      v = strsplit(a, '=')[[1]]
      switch(v[1],
             celfile =  celFileName <- as.vector(v[2]),
             )
    }   
    
    library(affy)    
    affyDat<-ReadAffy(filenames=celFileName)
    cat ("#PLATFORM:", cdfName(affyDat), "\n", sep="")
    
  } else
  {
    cat ("CEL2TXT.R Get mas5 summarization and present/absent calls for a single Cel file")
  }

