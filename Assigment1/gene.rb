require "csv"

class Gene
    attr_accessor :gene_id, :gene_name, :mutant_phenotype, :linked_to

    def initialize(gene_id:, gene_information_file: false)
        unless gene_information_file
            abort ".tsv file with information about the genes must be provided"
        end

        file = File.open(gene_information_file)
        table = CSV.table(file, col_sep: "\t")
        file.close

        (0..table.length-1).each do |row|
            unless table[:gene_id][row].match(/A[Tt]\d[Gg]\d\d\d\d\d/)
                abort "gene id #{table[:gene_id][row]} is not a valid id"
            end
        end

        @gene_id = gene_id
        
        unless gene_id.match(/^A[Tt]\d[Gg]\d\d\d\d\d$/)
            abort "gene id #{gene_id} is not a valid id"
        end

        x = 0
        (0..table.length-1).each do |row|
            if table[:gene_id][row] == gene_id
                @gene_name = table[:gene_name][row]
                @mutant_phenotype = table[:mutant_phenotype][row]
                x = 1
            end
        end
        if x == 0
            puts "Gene not found" #but Gene object is still created with only gene_id variable
        end
    end
end