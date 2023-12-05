# How to run
Exercises 4 a and b:

ruby get_repeats.rb

Outputs: cttctt_repeats_local.gff and report.txt


Exercise 5:

ruby get_repeats_global.rb

Outputs: cttctt_repeats_global.gff

# Image from exercise 6
Arabidopsis_thaliana_219022154_19027528.pdf

# Documentation
Exercises are carried out with a simple script that uses some BioRuby tools learned in class.

Documentation using YARD was deem unnecesary, as no functions were defined. So scripts are documented with 
traditional comments.

# Final remarks
Assignment asks specifically to scan for the CTTCTT sequence, so double repetitions of the CTT sequence. For this reason, this code annotates features of type 'repeat_region' defined as "A region of sequence containing one or more repeat units."

However, note that some genes contain more than two CTT repeat units on the same region, resulting on regions with many more CTT repeat units that may be better defined as a microsatellite or similar.

For this reason, probably a better approach would be to count the number of CTT units on each region and annotate them in function of this count, probably changing its type accordingly. So the result would be a sigle feature for each region.