class Annotations
    attr_accessor :name, :annotations

    def initialize(name:, text:)
        @name = name
        @text = text
    end

end