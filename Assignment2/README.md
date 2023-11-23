NOT YET FINNISHED
    merging interactions doesen't seem to work

How to run:

$ ruby find_interaction_networks.rb 

Running times:
Depth 1: 15 - 20 seconds
Depth 2: 58 - 72 seconds
Depth 3: 6 - 7 minutes


Hash object is created with all interactions retrieved frim IntAct, and it's used to avoid repeted calling to the same gene.

CONCLUSION: There are mire than 100 non interacting genes, that's more than half of the list.
There doesn't seem to be a wole connected network in this of genes.

One function from stackoverflow was used