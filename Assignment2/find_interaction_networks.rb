require './helper'
require './interaction_network'
require './annotations'

file = "ArabidopsisSubNetwork_GeneList.txt"
subNetwork_GeneList = []
IO.readlines(file).each do |geneid|
    subNetwork_GeneList << geneid.strip.downcase.capitalize
end

gene_interactions = Hash.new

depth = 3

gene_interactions = get_interactions_FromList_IntoHash_WithDepth(subNetwork_GeneList, gene_interactions, depth)

File.open("./hash", 'w') { |file| file.write(gene_interactions.to_s) }

networks = []
nonInteracting = []

subNetwork_GeneList.each do |geneid|   #didn't have time to make this depth dependent, it goes until depth 2
    network = []

    if gene_interactions[geneid] == "No interactions"
        nonInteracting << geneid
    else
        network << geneid 

        gene_interactions[geneid].each do |interactor1|

            if subNetwork_GeneList.include?(interactor1)
                network << interactor1 unless network.include?(interactor1)
            end

            unless gene_interactions[interactor1] == "No interactions"
                gene_interactions[interactor1].each do |interactor2|

                    if subNetwork_GeneList.include?(interactor2)
                        network << interactor2 unless network.include?(interactor2)
                    end
                end
            end

        end
        networks << network
    end
end

File.open("./networks.txt", 'w') { |file| file.write(networks.to_s) }

File.open("./nonInteracting.txt", 'w') { |file| file.write(nonInteracting.to_s) }

merged_networks = reduce(networks)

print merged_networks.flatten.length, " genes form ", merged_networks.length, " networks."
puts
print nonInteracting.length, " genes are considered non interacting."
puts

# Annotations and networks objects instances creation

# final_networks = []
# merged_networks.each do network
#     final_networks << InteractionNetwork.new(network, Annotations.new())
# end

