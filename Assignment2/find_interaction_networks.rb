require './helper'
require './interaction_network'
require './annotations'

file = "ArabidopsisSubNetwork_GeneList.txt"
subNetwork_GeneList = []
IO.readlines(file).each do |geneid|
    subNetwork_GeneList << geneid.strip.downcase.capitalize
end

gene_interactions = Hash.new
depth = 2
gene_interactions = get_interactions_FromList_IntoHash_WithDepth(subNetwork_GeneList, gene_interactions, depth)
File.open("./hash", 'w') { |file| file.write(gene_interactions.to_s) }

networks , nonInteracting = extracting_interactions(gene_interactions, subNetwork_GeneList) 
File.open("./networks.txt", 'w') { |file| file.write(networks.to_s) }
File.open("./nonInteracting.txt", 'w') { |file| file.write(nonInteracting.to_s) }

print networks.flatten.length, " genes form ", networks.length, " networks."
puts
print nonInteracting.length, " genes are considered non interacting."
puts

# Annotations and networks objects instances creation

# final_networks = []
# merged_networks.each do network
#     final_networks << InteractionNetwork.new(network, Annotations.new())
# end

