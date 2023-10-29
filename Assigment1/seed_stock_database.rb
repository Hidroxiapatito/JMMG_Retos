require "./seed_stock"
require "csv"

class SeedStockDatabase
    @@stocks = []
    attr_accessor :name

    def initialize (name: "database1")
        @name = name
    end

    def load_from_file(seed_stock_data: false)
        unless seed_stock_data
            abort ".tsv file must be provided"
        end
        file = File.open(seed_stock_data)
        table = CSV.table(file, col_sep: "\t")
        file.close

        (0..table.length).each do |row|
            @@stocks << SeedStock.new(stock: table[:seed_stock][row], gene_id: table[:mutant_gene_id][row], 
            date: table[:last_planted][row], storage: table[:storage][row], grams_remaining: table[:grams_remaining][row])
        end
    end

    def list
        return @@stocks
    end
end

db = SeedStockDatabase.new(name: "My database")

db.load_from_file(seed_stock_data: "seed_stock_data.tsv")

puts db.list[1].stock

        