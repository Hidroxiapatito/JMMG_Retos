class SeedStock
    attr_accessor :stock, :gene, :date, :storage, :grams_remaining

    def initialize(stock:, gene:, date:, storage:, grams_remaining:)
        @stock = stock
        @gene = gene
        @date = date
        @storage = storage
        @grams_remaining = grams_remaining
    end

end