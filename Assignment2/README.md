NOT YET FINNISHED
    merging interactions doesen't seem to work well. Genes outside gene list are not deleted.
    Didn't have enough time to generate output file.
    Networks output is available
How to run:

$ ruby find_interaction_networks.rb 

Running times:
Depth 1: 15 - 30 seconds
Depth 2: 58 - 125 seconds
Depth 3: 6 - 7 minutes

Annotations take well over an hour.

Hash object is created with all interactions retrieved from IntAct, and it's used to avoid repeted calling to the same gene.

CONCLUSION: There are more than 100 non interacting genes, that's more than half of the list.
There doesn't seem to be a whole connected network in this of genes.

One function from stackoverflow was used. Referenced in code.