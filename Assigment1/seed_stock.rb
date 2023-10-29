class SeedStock
    attr_accessor :stock, :gene_id, :date, :storage, :grams_remaining

    def initialize(stock:, gene_id:, date:, storage:, grams_remaining:)
        @stock = stock
        @gene_id = gene_id
        @date = date
        @storage = storage
        @grams_remaining = grams_remaining
    end

end