class InteractionNetwork
    attr_accessor :genes, :annotations

    def initialize(genes:, annotations:)
        @genes = genes
        @annotations = annotations
    end

end