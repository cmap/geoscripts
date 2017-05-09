# RUN_RMA.R Normalize Affy gene expression data using RMA
#
# R CMD BATCH --slave '--args celpath=<celFileDir> celfiles=<filename> outfile=<filename>' run_rma.r
#
# Input arguments to script:
# celpath: Folder where CEL files are stored
# celfiles: text file with list of CEL files to precess (one file per line)
# outfile: output file for summarized gene expression data

## RMA
runRMA <- function(cel_file_names, cel_file_dir, save_gex_in_file) {
  library("affy")
  eset <- justRMA(filenames=cel_file_names, celfile.path=cel_file_dir, verbose=T)
  write.exprs(eset,file=save_gex_in_file)
}

args <- commandArgs(TRUE)
nin <- length(args)

if (nin == 3)
  {
    
    for (a in args) {
      v = strsplit(a, '=')[[1]]
      switch(v[1],
             celpath = celFileDir <- v[2],
             celfiles =  celFileNames <-scan(v[2], what='', comment.char='#'),
             outfile = outFile <-v[2],
             )
    }

    cat (celFileDir,outFile,"\n")
    runRMA(celFileNames, celFileDir, outFile)
    
  } else
  {
    cat ("RUN_RMA.R Normalize Affy gene expression data using RMA\n
Usage:
R CMD BATCH --slave '--args celpath=<celFileDir> celfiles=<filename> outfile=<filename>' run_rma.r
# Input arguments to script:
# celpath: Folder where CEL files are stored
# celfiles: text file with list of CEL files to process (one file per line)
# outfile: output file for gene expression data
")
  }


