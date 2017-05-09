#Sanger800
#bsub -o logs/qcreports/sanger800.log  /xchip/dimred/holmes/tools/R-2.7.0/bin/R CMD BATCH --slave '--args txtpath=/xchip/bged/Samples txtfiles=sanger800_cel_files.txt outfile=output/qcreports/qcreport_sanger800_HT_HG-U133A_n611.txt' qcrpt.r

# $Author: Rajiv Narayan [narayan@broadinstitute.org]
# $Version: 142
# $Date: Jun.15.2010 19:08:52 EDT

#bsub -o logs/qcreports/sanger800_plate_11_12.log  /xchip/dimred/holmes/tools/R-2.7.0/bin/R CMD BATCH --slave '--args txtpath=/xchip/bged/sanger_new txtfiles=lists/sanger800_plate_11_12.txt outfile=output/qcreports/qcreport_sanger800_plate_11_12_n192.txt' qcrpt.r logs/qcreports/sanger800_plate_11_12.Rout

#bsub -o logs/qcreports/sanger800_missing_files.log  /xchip/dimred/holmes/tools/R-2.7.0/bin/R CMD BATCH --slave '--args txtpath=/xchip/bged/Samples txtfiles=lists/sanger800_missing_files.txt outfile=output/qcreports/qcreport_sanger800_missing_files_n156.txt' qcrpt.r logs/qcreports/sanger800_missing_files.Rout

#CMAP
#bsub -o logs/qcreports/cmap_HG-U133A_n830.log  /xchip/dimred/holmes/tools/R-2.7.0/bin/R CMD BATCH --slave '--args txtpath=/xchip/dimred/db/txt_files txtfiles=cmap_cel_files_HG-U133A_n830.grp outfile=output/qcreports/qcreport_cmap_HG-U133A_n830.txt' qcrpt.r

#bsub -o logs/qcreports/cmap_HT_HG-U133A_EA_n258.txt  /xchip/dimred/holmes/tools/R-2.7.0/bin/R CMD BATCH --slave '--args txtpath=/xchip/dimred/db/txt_files txtfiles=cmap_cel_files_HT_HG-U133A_EA_n258.grp outfile=output/qcreports/qcreport_cmap_HT_HG-U133A_EA_n258.txt' qcrpt.r

#bsub -o logs/qcreports/cmap_cel_files_HT_HG-U133A_n6070.grp  /xchip/dimred/holmes/tools/R-2.7.0/bin/R CMD BATCH --slave '--args txtpath=/xchip/dimred/db/txt_files txtfiles=cmap_cel_files_HT_HG-U133A_n6070.grp outfile=output/qcreports/qcreport_cmap_HT_HG-U133A_n6070.txt' qcrpt.r

#GEO
#GPL570
#bsub -o logs/qcreports/gpl570.log  /xchip/dimred/holmes/tools/R-2.7.0/bin/R CMD BATCH --slave '--args txtpath=/xchip/bged/Samples txtfiles=list_of_cel_files_for_GEO_GPL570.txt  outfile=output/qcreports/qcreport_GEO_GPL570_n10885.txt' qcrpt.r

#GPL571
#bsub -o logs/qcreports/gpl571.log  /xchip/dimred/holmes/tools/R-2.7.0/bin/R CMD BATCH --slave '--args txtpath=/xchip/bged/Samples txtfiles=list_of_cel_files_for_GEO_GPL_571_good.txt outfile=output/qcreports/qcreport_GEO_GPL571_n867.txt' qcrpt.r

#GPL96
#bsub -o logs/qcreports/gpl96.log  /xchip/dimred/holmes/tools/R-2.7.0/bin/R CMD BATCH --slave '--args txtpath=/xchip/bged/Samples txtfiles=list_of_cel_files_for_GEO_GPL96.txt outfile=output/qcreports/qcreport_GEO_GPL96_n8420.txt' qcrpt.r

#BGED ALL
#bsub -o logs/qcreports/bgedall.log  /xchip/dimred/holmes/tools/R-2.7.0/bin/R CMD BATCH --slave '--args txtpath=/xchip/bged/Samples txtfiles=bged_unique_n38209.grp  outfile=output/qcreports/qcreport_BGED_n38209.txt' qcrpt.r

#bsub -o logs/qcreports/bgedremain.log  /xchip/dimred/holmes/tools/R-2.7.0/bin/R CMD BATCH --slave '--args txtpath=/xchip/bged/Samples txtfiles=temp/qc_bged_all_remain.txt  outfile=output/qcreports/qcreport_BGED_remain_2_n27413.txt' qcrpt.r

########
#GSK
#bsub -o logs/qcreports/gsk.log /xchip/dimred/holmes/tools/R-2.7.0/bin/R CMD BATCH --slave '--args txtpath=/xchip/bged/gsk txtfiles=lists/gsk_n950.txt outfile=output/qcreports/qcreport_gsk_n950.txt' qcrpt.r logs/qcreports/gsk_n950.Rout

#####
#NCI60
#bsub -o logs/qcreports/nci60.log /xchip/dimred/holmes/tools/R-2.7.0/bin/R CMD BATCH --slave '--args txtpath=/xchip/bged/Samples txtfiles=lists/nci60.txt outfile=output/qcreports/qcreport_nci60.txt' qcrpt.r logs/qcreports/nci60.Rout

#GNF84
bsub -o logs/qcreports/gnf84.log /xchip/dimred/holmes/tools/R-2.7.0/bin/R CMD BATCH --slave '--args txtpath=/xchip/bged/Samples txtfiles=lists/gnf84.txt outfile=output/qcreports/qcreport_gnf84.txt' qcrpt.r logs/qcreports/gnf84.Rout
