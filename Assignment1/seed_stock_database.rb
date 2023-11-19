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

    def load_from_file(seed_stock_data = false)
        unless seed_stock_data
            abort ".tsv file must be provided"
        end
        file = File.open(seed_stock_data)
        table = CSV.table(file, col_sep: "\t")
        file.close

        unless @gene_information_file
            abort ".tsv file with information about the genes must be provided before \
loading seed stock data: self.gene_information_file = 'your_file.tsv'"
        end

        (0..table.length-1).each do |row|
            @stocks << SeedStock.new(stock: table[:seed_stock][row], 
            gene: Gene.new(gene_id = table[:mutant_gene_id][row], gene_information_file = @gene_information_file), 
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
                instance.date = Time.now.strftime("%d/%m/%Y")

                if instance.grams_remaining <= 0
                    instance.grams_remaining = 0
                    puts "WARNING: we have run out of Seed Stock #{instance.stock}"
                end
            end

        else x = 0
            self.stocks.each do |instance|
                if instance.stock == stock_name
                    instance.grams_remaining -= grams
                    instance.date = Time.now.strftime("%d/%m/%Y")
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

    def get_crosses(cross_information_file = false)
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
            observed = [cross.fwt, cross.fp1, cross.fp2, cross.fp1p2]
            total = observed.sum.to_f
            expected = [total * 9/16, total * 3/16, total * 3/16, total * 1/16]
            equ = []

            (0..3).each do |i|
                equ << (observed[i] - expected[i])**2 / expected[i]
            end

            result = equ.sum

            if result >= 7.815 #p-value >= 0.05 for 3 degrees of freedom
                self.get_seed_stock(cross.p1).gene.linked_to = self.get_seed_stock(cross.p2).gene.gene_name
                self.get_seed_stock(cross.p2).gene.linked_to = self.get_seed_stock(cross.p1).gene.gene_name
                puts "Recording: #{self.get_seed_stock(cross.p1).gene.gene_name} is genetically linked to \
#{self.get_seed_stock(cross.p2).gene.gene_name} with chisquare score #{result}"
            end
        end
    end

    def write_database(new_database_name = "new_stock_file.tsv")
        out_file = File.new(new_database_name, "w")
        out_file.puts "Seed_Stock	Mutant_Gene_ID	Last_Planted	Storage	Grams_Remaining"
        self.stocks.each do |stock|
            out_file.puts "#{stock.stock}\t#{stock.gene.gene_id}\t#{stock.date}\t#{stock.storage}\t#{stock.grams_remaining}"
        end
        out_file.close
    end
end