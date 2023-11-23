require 'rest-client'
require 'json'

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

        # NOT ALL PROTEINS HAVE LOCUS NAMES, IF ABOVE CODE DOESNT CAPTURE THE LOCUS, IT GETS DISCARDED
            # if a == nil || b == nil
            #     a = line.split("\t")[0][/([A-Z][^\t]*)/, 0]
            #     b = line.split("\t")[1][/([A-Z][^\t]*)/, 0]
            #     response = RestClient::Request.execute(  #  or you can use the 'fetch' function we created last class
            #         method: :get,
            #         url: "http://togows.org/entry/ebi-uniprot/#{a}/dr.json")
            #     data = JSON.parse(response.body)
            #     puts data[0]["TAIR"] #[/A[Tt]\d[Gg]\d\d\d\d\d/, 0]
            # end

            x = 0
            [a, b].each do |gen|
                if x == 0 && (gen != geneid || a == b) && (intType == "MI:0407" || intType == "MI:0915") && gen != nil
                    interactions << gen.downcase.capitalize
                    x = 1
                end
            end
        end
    end

    unless empty || interactions == []
        hash[geneid] = interactions
    else 
        hash[geneid] = "No interactions"
    end
    
    return hash
end


# def get_interactions_FromList_IntoHash_WithDepth(list, hash, depth)
#     start = Time.now
#     names = []
#     list.each do |geneid|
#         start_gene = Time.now
#         puts "#{list.index(geneid)+1}/#{list.length}"
    
#         hash = get_interactions_FromGene_IntoHash(geneid, hash)

#         (0..depth-1).each do
#             hash.keys.each do |gen|
    
#                 if !names.include?(gen) && hash[gen].kind_of?(Array)
#                     hash[gen].each do |name|

#                         unless hash.key?(name)
#                             hash = get_interactions_FromGene_IntoHash(name, hash)
#                         end
#                     end
#                 end
#             end
#         end
#         hash.keys.each do |name|
#                names << name
#         end
#         finish_gene = Time.now
#         print finish_gene - start_gene, " seconds"
#         puts
#     end
#     finish = Time.now
#     print "Total time elapsed: ", (finish - start)/60, " minutes"
#     puts
#     return hash
# end

def get_interactions_FromList_IntoHash_WithDepth(list, hash, depth)
    depth -= 1
    start = Time.now

    list.each do |geneid|
        hash = get_interactions_FromGene_IntoHash(geneid, hash)
    end
    puts "Depth 1"
    d1 = Time.now
    print d1 - start, " seconds"
    puts

    (0..depth-1).each do |d|
        hash.keys.each do |gene|

            if hash[gene].kind_of?(Array)
                hash[gene].each do |name|

                    unless hash.key?(name)
                        hash = get_interactions_FromGene_IntoHash(name, hash)
                    end
                end
            end
        end
        puts "Depth #{d+2}"
        d2 = Time.now
        print d2 - start, " seconds"
        puts
    end
    finish = Time.now
    print "Total time elapsed: ", (finish - start)/60, " minutes"
    return hash
end