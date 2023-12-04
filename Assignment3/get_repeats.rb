require 'bio'

embl = Bio::EMBL.new(Bio::Fetch::EBI.query("ensemblgenomesgene",'AT5g54270','raw', 'embl'))
# explicar que no nos guardamos el objeto embl porque para hacer un gff no nos hace falta
bioseq = embl.to_biosequence

sequence =  bioseq.seq

bioseq.features.each do |feature|

    next unless feature.feature == "exon" && /^[0-9]+..[0-9]+/.match?(feature.position)

    range = Range.new(eval(feature.position).begin() -1, eval(feature.position).end() -1) 
    positions_plus_exon = sequence[range].enum_for(:scan, /cttctt/).map { Regexp.last_match.begin(0) }
    # source: https://stackoverflow.com/questions/5241653/ruby-regex-match-and-get-positions-of#5241843

    positions_plus_exon.each do |pos|
        feat = Bio::Feature.new('myrepeat', Range.new(range.begin()+pos+1, range.begin()+pos+6).to_s)
        feat.append(Bio::Feature::Qualifier.new('repeat_motif', 'CTTCTT'))
        feat.append(Bio::Feature::Qualifier.new('strand', '+'))
        bioseq.features << feat
    end

    positions_neg_exon = sequence[range].enum_for(:scan, /aagaag/).map { Regexp.last_match.begin(0) }

    positions_neg_exon.each do |pos|
        feat = Bio::Feature.new('myrepeat', Range.new(range.begin()+pos+1, range.begin()+pos+6).to_s)
        feat.append(Bio::Feature::Qualifier.new('repeat_motif', 'CTTCTT'))
        feat.append(Bio::Feature::Qualifier.new('strand', '-'))
        bioseq.features << feat
    end

end

bioseq.features.each do |feature|
    featuretype = feature.feature
    next unless featuretype == "myrepeat"
    position = feature.position
    puts "FEATURE #{featuretype} @ POSITION = #{position}"

    qual = feature.assoc            # feature.assoc gives you a hash of Bio::Feature::Qualifier objects 
                                    # i.e. qualifier['key'] = value  for example qualifier['gene'] = "CYP450")
    puts "Associations = #{qual}"
    # skips the entry if "/translation=" is not found
end