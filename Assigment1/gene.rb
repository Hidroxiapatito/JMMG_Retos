require "csv"

class Gene
    attr_accessor :gene_id, :gene_name, :mutant_phenotype

    def initialize(gene_id:, gene_information_file: false)
        unless gene_information_file
            abort ".tsv file with information about the genes must be provided"
        end

        file = File.open(gene_information_file)
        table = CSV.table(file, col_sep: "\t")
        file.close

        @gene_id = gene_id

        (0..table.length-1).each do |row|
            if table[:gene_id][row] == gene_id
                @gene_name = table[:gene_name][row]
                @mutant_phenotype = table[:mutant_phenotype][row]
            end
        end
    end
end