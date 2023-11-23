require './helper'
require './interaction_network'
require './annotations'

file = "ArabidopsisSubNetwork_GeneList.txt"
subNetwork_GeneList = []
IO.readlines(file).each do |geneid|
    subNetwork_GeneList << geneid.strip.downcase.capitalize
end

puts "Building interactions..."
puts 
gene_interactions = Hash.new
depth = 2 # DEFINE DEPTH OF INTERACTION SEARCH
gene_interactions = get_interactions_FromList_IntoHash_WithDepth(subNetwork_GeneList, gene_interactions, depth)
File.open("./hash.txt", 'w') { |file| file.write(gene_interactions.to_s) }

merged_networks, nonInteracting = extracting_interactions(gene_interactions, subNetwork_GeneList) 
File.open("./networks.txt", 'w') { |file| file.write(merged_networks.to_s) }
File.open("./nonInteracting.txt", 'w') { |file| file.write(nonInteracting.to_s) }

puts
print merged_networks.flatten.length, " genes form ", merged_networks.length, " networks."
puts
print nonInteracting.length, " genes are considered non interacting."
puts

# Annotations and networks objects instances creation
puts "Building annotations..."
puts
start = Time.now
final_networks = []
merged_networks.each do |network|
    annot = []
    network.each do |gene|
        annot << Annotations.new("GO BP terms", Annotations.get_GO(gene))
        annot << Annotations.new("KEGG pathay", Annotations.get_KEGG(gene))
    end
    final_networks << InteractionNetwork.new(network, annot)
end
stop = Time.now
print (stop - start)/60, " minutes elapsed"
puts

# Output
puts
puts "Networks genes and annotations:"
final_networks.each_with_index do |net, i|
    print "Network: ", i
    puts
    puts "Genes:", net.genes
    puts "Annotations:"
    net.annotations.each do |an|
        puts an.name
        puts an.text
    end
end

$stdout.reopen("result_output.txt", "w")