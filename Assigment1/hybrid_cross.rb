class HybridCross
    attr_accessor :p1, :p2, :fwt, :fp1, :fp2, :fp1p2

    def initialize(p1:, p2:, fwt:, fp1:, fp2:, fp1p2:)
        @p1 = p1
        @p2 = p2 
        @fwt = fwt 
        @fp1 = fp1
        @fp2 = fp2
        @fp1p2 = fp1p2
    end
end