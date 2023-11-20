require 'rest-client'

def get_interactions_FromGene_IntoHash(geneid, hash)

    geneid.downcase!.capitalize!

    interactions = []

    response = RestClient::Request.execute(
        method: :get,
        url: "http://www.ebi.ac.uk/Tools/webservices/psicquic/intact/webservices/current/search/interactor/#{geneid}?format=tab25"
        )
        
    empty = false
    if response.body == ""
        empty = true
    end

    if not empty
        response.body.split("\n").each do |line|

            a = line.split("\t")[4][/A[Tt]\d[Gg]\d\d\d\d\d/, 0]
            b = line.split("\t")[5][/A[Tt]\d[Gg]\d\d\d\d\d/, 0]
            intType = line.split("\t")[11][/(M[^"]*)/, 0]

            # Hacer caso de que a y b son iguales. Eso y pasar a minúsculas geneid
            x = 0
            [a, b].each do |gen|
                if x == 0 && (gen != geneid || a == b) && (intType == "MI:0407" || intType == "MI:0915")
                    interactions << gen
                    x = 1
                end
            end
        end
    end

    unless empty
        hash[geneid] = interactions
    else 
        hash[geneid] = "No interactions"
    end
    
    return hash
end



# def get_interactions_FromGene_IntoHash_WithDepth(gene, hash, depth)

#     hash = get_interactions_FromGene_IntoHash(gene, hash)
#     (0..depth-1).each do |i|
#         hash.each do |gen, int|

#             if int.kind_of?(Array)
#                 int.each do |name|
#                     unless hash.key?(name)
#                         hash = get_interactions_FromGene_IntoHash(name, hash)
#                     end
#                 end
#             end
#         end
#     end


#     return hash
# end

def get_interactions_FromFile_IntoHash_WithDepth(file, hash, depth)

    IO.readlines(file)[2..3].each do |geneid|

        geneid.strip!.downcase!.capitalize!
    
        hash = get_interactions_FromGene_IntoHash(geneid, hash)

        names = []
        (0..depth-1).each do |i|
            hash.keys do |gen|

                if !names.include?(gen) && hash[gen].kind_of?(Array)
                    hash[gen].each do |name|
                        unless hash.key?(name)
                            hash = get_interactions_FromGene_IntoHash(name, hash)
                        end
                    end
                end
            end
            names << hash.keys
        end
        
    end
    return hash
end
