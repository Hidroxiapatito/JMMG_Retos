require 'rest-client'
require 'json'

class Annotations
    attr_accessor :name, :text

    def initialize(name, text)
        @name = name
        @text = text
    end

    def self.get_KEGG(gene)
        text = []
        response=RestClient::Request.execute({
            method: :get,
            url: "http://togows.org/entry/kegg-genes/ath:#{gene}/pathways.json"
        })
        data = JSON.parse(response.body)
        unless data[0] == nil || data[0] == []
            return [data[0].keys, data[0].values]
        else
            return []
        end
    end

    def self.get_GO(gene)
        text = []
    
        response=RestClient::Request.execute({
            method: :get,
            url: "http://togows.dbcls.jp/entry/uniprot/#{gene}/dr.json"
        })
        data = JSON.parse(response.body)
        unless data[0]['GO'] == nil || data[0]['GO'] == []
            data[0]['GO'].each do |line|
                if line[1].start_with?('P:')
                    text << line[0..1]
                end
            end
            return text
        else
            return []
        end
    end

end