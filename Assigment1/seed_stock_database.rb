require "./seed_stock"
require "./gene"
require "./hybrid_cross"
require "csv"

class SeedStockDatabase
    attr_accessor :name, :stocks, :gene_information_file, :crosses

    def initialize (name = "database1", gene_information_file = false)
        @name = name
        @gene_information_file = gene_information_file
        @stocks = []
        @crosses = []
    end

    def load_from_file(seed_stock_data)
        unless seed_stock_data
            abort ".tsv file must be provided"
        end
        file = File.open(seed_stock_data)
        table = CSV.table(file, col_sep: "\t")
        file.close

        unless gene_information_file
            abort ".tsv file with information about the genes must be provided: self.gene_information_file = 'your_file.tsv'"
        end

        (0..table.length-1).each do |row|
            @stocks << SeedStock.new(stock: table[:seed_stock][row], 
            gene: Gene.new(gene_id: table[:mutant_gene_id][row], gene_information_file: @gene_information_file), 
            date: table[:last_planted][row], storage: table[:storage][row], grams_remaining: table[:grams_remaining][row])
        end
    end

    def get_seed_stock(stock_name)
        self.stocks.each do |instance|
            if instance.stock == stock_name
                return instance
            else "Seed stock not found"
            end
        end
    end

    def plant_seeds(stock_name = "all", grams)
        unless grams
            abort "wrong usage of 'plant seeds'. Proper usage: ('stock name' or 'all'), grams"
        end

        if stock_name == "all"
            self.stocks.each do |instance|
                instance.grams_remaining -= grams

                if instance.grams_remaining <= 0
                    instance.grams_remaining = 0
                    puts "WARNING: we have run out of Seed Stock #{instance.stock}"
                end
            end

        else x = 0
            self.stocks.each do |instance|
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

    def get_crosses(cross_information_file)
        unless cross_information_file
            abort ".tsv file with information about crosses must be provided"
        end

        file = File.open(cross_information_file)
        table = CSV.table(file, col_sep: "\t")
        file.close

        (0..table.length-1).each do |row|
            @crosses << HybridCross.new(p1: table[:parent1][row], p2: table[:parent2][row], 
            fwt: table[:f2_wild][row], fp1: table[:f2_p1][row], fp2: table[:f2_p2][row], fp1p2: table[:f2_p1p2][row])
        end

        self.crosses.each do |cross|
            puts cross.p1
        end
    end

end

#db = SeedStockDatabase.new(name: "My database", gene_information_file: "gene_information.tsv")

db = SeedStockDatabase.new

db.gene_information_file = "gene_information.tsv"

db.load_from_file(seed_stock_data = "seed_stock_data.tsv")

db.stocks.each do |instance|
    puts instance.gene.gene_name
end

puts db.name

db.get_crosses("cross_data.tsv")
