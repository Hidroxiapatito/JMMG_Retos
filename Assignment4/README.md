# How to run
ruby reciprocal_best_BLAST.rb 

Script runs for: 2 - 2,5 hours

If you are going to run it: Delete results.table

If you don't use parameters -b and -e; running time increases to over 6 hours. But in turn, 9 more reciprocal hits are detected.

Standard output of the script can be followed in stdoutput.txt

In total, this analysis produces arround 2553 possible orthologues from Reciprocal-best-BLAST.
# Results
Reciprocal BLAST best hits are stored in results.table

These are derived from blastx and tblastn with parameters that use soft filtering (-F "m S") and a Smith–Waterman alignment (-s T). This was used following the indications of the following paper:

Gabriel Moreno-Hagelsieb, Kristen Latimer, Choosing BLAST options for better detection of orthologs as reciprocal best hits, Bioinformatics, Volume 24, Issue 3, February 2008, Pages 319–324, https://doi.org/10.1093/bioinformatics/btm585

I also use filters like (-e 0.05) and (-b5), which give only hits with an e-value lower than 0.05 (Which is better than using a bit score because it normalizes the value with many relevat parameters and is essentially equivalent to a p-value.) and retrieve the top 5 results (for efficiency), although we only need the top result, blast recommends at least 5.

# How would I continue to analyze the putative orthologues just discovered, to prove that they really are orthologues:
We know that these genes are homologous, now, we don't know if they are orthologous or paralogous; these are evolutionary concepts and ideally we could use a phylogenetic tree to differentiate them. But this may not be feasible, because it could be very computationally expensive.

Using best reciprocal hits as we have done, works well for one-to-one orthologs, but not for solving co-orthologs, such as 1-to-many or many-to-many, where there are inparalogs.

Other methods similar to blast but that work better for very distant sequences are HMM (Hidden Markov Models) and PSI-BLAST. Which could help with very distant orthologs, but not with the inparalogs problem.

Finally, if we had more proteomes we could build Clusters of Orthologous Groups (COGs), calculating the best reciprocal hits between proteomes and classifying them with respect to how they cluster.

# Documentation
Exercises are carried out with a simple script that uses some BioRuby tools learned in class.

Documentation using YARD was deem unnecesary, as no functions were defined. So script is documented using traditional comments.