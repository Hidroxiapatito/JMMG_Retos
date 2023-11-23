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

        # NOT ALL PROTEINS HAVE LOCUS NAMES AS ALIASES, IF ABOVE CODE DOESNT CAPTURE THE LOCUS, PROTEIN GETS DISCARDED
            #BELOW CODE CAN'T ALLWAYS GET LOCUS NAME WHEN CODE ABOVE FAILS, HENCE THAT'S WHY I DON'T USE IT
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
    puts
    return hash
end

# SOURCE: https://stackoverflow.com/questions/1673793/merging-array-items-in-ruby
def reduce(array)
    h = Hash.new {|h,k| h[k] = []}
    array.each_with_index do |x, i| 
      x.each do |j|
        h[j] << i
        if h[j].size > 1
          # merge the two sub arrays
          array[h[j][0]].replace((array[h[j][0]] | array[h[j][1]]).sort)
          array.delete_at(h[j][1])
          return reduce(array)
          # recurse until nothing needs to be merged
        end
      end
    end
    array
end
