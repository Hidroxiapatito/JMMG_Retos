require './helper'

gene_interactions = Hash.new

file = "ArabidopsisSubNetwork_GeneList.txt"


puts get_interactions_FromFile_IntoHash_WithDepth(file, gene_interactions, 1)
