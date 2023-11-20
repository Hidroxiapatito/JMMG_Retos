require './helper'

file = "ArabidopsisSubNetwork_GeneList.txt"
subNetwork_GeneList = []
IO.readlines(file).each do |geneid|
    geneid.strip!.downcase!.capitalize!
    subNetwork_GeneList << geneid
end

gene_interactions = Hash.new

puts get_interactions_FromList_IntoHash_WithDepth(subNetwork_GeneList, gene_interactions, 1)

networks = []
nonInteracting = []

subNetwork_GeneList.each do |geneid|
    network = [geneid]
    gene_interactions[geneid].each do |interactor1|
        if subNetwork_GeneList.include?(interactor1)
            network << interactor1
        end
    end