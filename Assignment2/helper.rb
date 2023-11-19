require 'rest-client'

def get_interactions(geneid)

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

            # Hacer caso de que a y b son iguales. Eso y pasar a minúscula geneid
            [a, b].each do |gen|
                if gen != geneid && (intType == "MI:0407" || intType == "MI:0915")
                    interactions << gen
                end
            end
        end
    end
    return [interactions, empty]
end