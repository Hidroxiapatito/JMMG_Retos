require 'rest-client'

IO.readlines("ArabidopsisSubNetwork_GeneList.txt")[3..4].each do |geneid|
    puts geneid.strip!

    response = RestClient::Request.execute(
        method: :get,
        url: "http://www.ebi.ac.uk/Tools/webservices/psicquic/intact/webservices/current/search/interactor/#{geneid}?format=tab25"
        )
        
    response.body.split("\n").each do |line|
        line.split("\t")[4..5].each do |field|
            print "-", field[/A[Tt]\d[Gg]\d\d\d\d\d/, 0]
        end
        puts
    end
end