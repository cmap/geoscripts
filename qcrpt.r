# QCRPT.R Generate QC report for a list of text files
#
# R CMD BATCH --slave '--args txtpath=<txtfolder> txtfiles=<filename> outfile=<filename> qcrpt.r
#
# Input arguments to script:
# txtfiles: text file with list of TXT files to process (one file per line)
# outfile: output file for QC report

# returns string w/o leading or trailing whitespace
trim <- function (x) gsub("^\\s+|\\s+$", "", x)

args <- commandArgs(TRUE)
nin <- length(args)

if (nin == 3)
  {
    for (a in args) {
      v = strsplit(a, '=')[[1]]
      switch(v[1],
             txtfiles =  txtFiles <- scan(v[2], what='', comment.char='#'),
	     outfile = outFile <-v[2],
             txtpath = txtPath <- v[2],
             cat ("Invalid argument specified:",v[1],"\n")
             )
    }

    ofid <- file(outFile,"w")
    cat ("CEL_NAME", "CHIP", "NUM_FEATURES","MEAN_INT","STDEV_INT","MEDIAN_INT","MIN_INT","MIN_ROB10","MAX_INT","MAX_ROB10","PCALL_PERCENT","MCALL_PERCENT","ACALL_PERCENT","GAP35_RATIO","ACT35_RATIO","GAP3M_RATIO","ACT3M_RATIO","BIOB_PCALL","IS_SPIKE_ASCEND","SPIKE_INT","\n",sep="\t", file=ofid)
    fs=.Platform$file.sep
    
    #loop over txtFiles
    for (f in txtFiles)
      {
        # strip extension, assume the file is foo.CXT.gz
        celName <- strsplit(f,'.CEL$|.CEL.gz$|.TXT$|.CXT$|.CXT.gz$')[[1]]
        fn <- paste(celName, ".CXT.gz", sep="")
        fname <- file.path(txtPath, fn, fsep=fs)
	cat (fname,"\n")
        if ( file.access(fname, 4) == 0 )
          {
            cat (fname,"\n")

            if (length(grep('.gz$', fname))>0) {
              fid <- gzfile(fname, "rt")
            }
            else {
              fid <- file( fname, "rt")
            }
            line1<-readLines(fid,1)
            ## mas5 program output
            if (! is.na(pmatch("Description\tAccession\t", line1)) ){
              hdr <- readLines(fid,2)
              numFeatures <- as.numeric(hdr[2])
              dat <- read.csv(fid, header=F, sep="\t")
              name<-dat$V1
              signal<-dat$V2
              pcalls<-dat$V3
            }
            ## format type 1 
            else if (! is.na(pmatch("Expression Analysis: Metrics Tab", line1))) {
              dat <- read.csv(fid, header=T, sep="\t")
              name <- dat$Probe.Set.Name
              signal <- dat$Signal
              pcalls <- dat$Detection
              numFeatures<- length(signal)
            }
            else if (! is.na(pmatch("#TXT_VIA_R_MAS5", line1))) {
              intname <- trim(strsplit(strsplit(readLines(fid, 1), ': ')[[1]][2],'.CEL$|.CEL.gz$')[[1]])
              if (! intname == celName) celName<-paste("#NAME_MISMATCH:", celName,',',intname, sep='')
              chip <- toupper(strsplit(readLines(fid, 1), ': ')[[1]][2])
              ## read gzipped file, NOTE: requires R >= 2.10
              dat<-read.csv(fid, header=T, sep="\t", comment.char="#")              
              name <- dat$NAME
              signal <- dat$MAS5
              pcalls <- dat$PCALL
              numFeatures<- length(signal)
            }
             else {
              dat <- read.csv(fid, header=F, sep="\t")
              #celName<- levels(dat$Analysis.Name[1])              
              name <- dat$V1
              signal <- dat$V2
              pcalls <- dat$V3
              numFeatures<- length(signal)
            }
            close(fid)
                      
            ## Intensity stats
            meanInt <- mean(signal)
            sdInt <- sd(signal)
            q <- quantile(signal,c(0.5,0.1,0.9))
            medianInt <- q[1]
            minInt <- min(signal)
            minRob10 <- mean(signal[signal <= q[2]])
            maxInt <- max(signal)
            maxRob10 <- mean(signal[signal >= q[3]])
            
            ## Present calls
            pcall <- 100*sum(pcalls=="P")/numFeatures
            mcall <- 100*sum(pcalls=="M")/numFeatures
            acall <- 100*sum(pcalls=="A")/numFeatures
            
            ## GAPDH and beta-actin levels
            num<-c("AFFX-HUMGAPDH/M33197_3_at", "AFFX-HSAC07/X00351_3_at", "AFFX-HUMGAPDH/M33197_3_at", "AFFX-HSAC07/X00351_3_at")
            denom<-c("AFFX-HUMGAPDH/M33197_5_at", "AFFX-HSAC07/X00351_5_at", "AFFX-HUMGAPDH/M33197_M_at", "AFFX-HSAC07/X00351_M_at")
            
            numIdx <- match(num, name)
            denomIdx <- match(denom, name)
            ## gapdh35, act35, gapdh3m, act3m
            GAratios <- signal[numIdx] / signal[denomIdx]
            
            ## Spike controls
            spikeIdx <- match(c("AFFX-r2-Ec-bioB-3_at","AFFX-r2-Ec-bioC-3_at","AFFX-r2-Ec-bioD-3_at","AFFX-r2-P1-cre-3_at"),name)
            
            ## Use alternate probeset if required
            if (any(is.na(spikeIdx))) {
              cat("Using alternate spike control probes\n")
              spikeIdx <- match(c('AFFX-BioB-3_at', 'AFFX-BioC-3_at', 'AFFX-BioDn-3_at', 'AFFX-CreX-3_at'), name)
            }
            
            ## BioB present call
            biobPCall <- factor(pcalls[spikeIdx[1]])
            ## Intensities of BioB, BioC, BioD, CreX
            spkInt <- paste(round(signal[spikeIdx]),collapse="|")
            ## Are Intensities of spike controls in ascending order  BioB<BioC<BioD<CreX
            spkAscend <- ifelse(all(diff(signal[spikeIdx])>0),"Y","N");
            
            cat (celName, chip, numFeatures, meanInt, sdInt, medianInt, minInt, minRob10, maxInt, maxRob10, pcall, mcall, acall, GAratios, levels(biobPCall), spkAscend, spkInt, "\n", sep="\t", file=ofid)
          }
        else
          {
            cat ("File:", fname, "not readable\n");
          }        
      }
        close(ofid);
    
  } else
  {
    cat ("QCRPT.R Generate QC report for a list of text files")
  }
