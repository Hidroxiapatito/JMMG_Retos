## CONCLUSION: 
I would say that the majority of these co-expressed genes are not known to bind to one another.

My script concludes that from the list of 168 genes, there are 102 of them that don't interact, that's way more than half of the list. So, at best 66 genes from the list interact with other products, that's less than 40%. And those form 8 separate networks, one of them including the majority of these.


## Report is stored in: result_output.txt
Now that I'm able to get an output (last week I could not get output because of some external network error; see result_error.txt) I see that the indices of the genes when displaing annotations are wrong and the report is not very readable.


## Bugs:
Merging interactions into networks doesen't seem to work well. Genes outside the problem gene list are not deleted, hence networks inlcude genes from outside the list.

## What are the rest of the files and how does the script work
Hash object is created with all interactions retrieved from IntAct, and it's used to avoid repeted calling of the same gene. 
It is stored in hash file

Interactions from hash object are then parsed. Networks are created as a list of lists, and non interacting genes are identified. This is stored in networks.txt and nonInteracting.txt respectively.

Finally, network objects are created from the 'networks' list of lists and annotated


## How to run:

$ ruby find_interaction_networks.rb 


## Running times:

Depth 1: 15 - 30 seconds

Depth 2: 58 - 125 seconds

Depth 3: 6 - 7 minutes

Annotations take well over an hour and 20 mins.

## References
One function from stackoverflow was used. Referenced in code.