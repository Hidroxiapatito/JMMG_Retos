# How to run
ruby reciprocal_best_BLAST.rb 

Script runs for: minutes

If you are going to run it: Delete results.table

# Results
Reciprocal BLAST best hits are stored in results.table

These are derived from blastx and tblastn with parameters that use soft filtering and a Smith–Waterman alignment. This was used following the indications of the following paper:

Gabriel Moreno-Hagelsieb, Kristen Latimer, Choosing BLAST options for better detection of orthologs as reciprocal best hits, Bioinformatics, Volume 24, Issue 3, February 2008, Pages 319–324, https://doi.org/10.1093/bioinformatics/btm585

# Documentation
Exercises are carried out with a simple script that uses some BioRuby tools learned in class.

Documentation using YARD was deem unnecesary, as no functions were defined. So script is documented using 
traditional comments.