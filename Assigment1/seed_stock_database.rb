require "./seed_stock"
require "./gene"
require "csv"

class SeedStockDatabase
    attr_accessor :name

    def initialize (name: "database1", gene_information_file: false)
        @name = name
        @gene_information_file = gene_information_file
        @stocks = []
    end

    def load_from_file(seed_stock_data: false)
        unless seed_stock_data
            abort ".tsv file must be provided"
        end
        file = File.open(seed_stock_data)
        table = CSV.table(file, col_sep: "\t")
        file.close

        (0..table.length-1).each do |row|
            @stocks << SeedStock.new(stock: table[:seed_stock][row], gene: Gene.new(gene_id: table[:mutant_gene_id][row], gene_information_file: @gene_information_file), 
            date: table[:last_planted][row], storage: table[:storage][row], grams_remaining: table[:grams_remaining][row])
        end
    end

    def list
        return @stocks
    end

    def get_seed_stock(stock_name)
        self.list.each do |instance|
            if instance.stock == stock_name
                return instance
            else "Seed stock not found"
            end
        end
    end

    def plant_seeds(stock_name = "all", grams)
        unless grams
            puts "wrong usage of 'plant seeds'. Proper usage: ('stock name' or 'all'), grams"
        end

        if stock_name == "all"
            self.list.each do |instance|
                instance.grams_remaining -= grams

                if instance.grams_remaining <= 0
                    instance.grams_remaining = 0
                    puts "WARNING: we have run out of Seed Stock #{instance.stock}"
                end
            end

        else x = 0
            self.list.each do |instance|
                if instance.stock == stock_name
                    instance.grams_remaining -= grams
                    x = 1

                    if instance.grams_remaining <= 0
                        instance.grams_remaining = 0
                        puts "WARNING: we have run out of Seed Stock #{instance.stock}"
                    end
                end
            end
            if x == 0
                puts "Seed stock not found"
            end
        end
    end
end

db = SeedStockDatabase.new(name: "My database", gene_information_file: "gene_information.tsv")

db.load_from_file(seed_stock_data: "seed_stock_data.tsv")

db.list.each do |instance|
    puts instance.gene.gene_name
end
