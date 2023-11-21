require './helper'

file = "ArabidopsisSubNetwork_GeneList.txt"
subNetwork_GeneList = []
IO.readlines(file).each do |geneid|
    geneid.strip!.downcase!.capitalize!
    subNetwork_GeneList << geneid
end

gene_interactions = Hash.new

depth = 1   #what it depth?

hassh = get_interactions_FromList_IntoHash_WithDepth(subNetwork_GeneList, gene_interactions, depth)

File.open("./hash", 'w') { |file| file.write(hassh.to_s) }

networks = []
nonInteracting = []

subNetwork_GeneList.each do |geneid|   #didn't have time to make this recursive
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

print "networks: ", networks
puts
print "Non interacting ", nonInteracting
puts

#We need to merge the networks