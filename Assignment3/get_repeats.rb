require 'bio'

embl = Bio::EMBL.new(Bio::Fetch::EBI.query("ensemblgenomesgene",'AT5g19120','raw', 'embl'))

bioseq = embl.to_biosequence

sequence =  bioseq.seq
puts sequence

bioseq.features.each do |feature|

    featuretype = feature.feature
    next unless featuretype == "exon"

    range = Range.new(eval(feature.position).begin() -1, eval(feature.position).end) 
    positions_exon = sequence[range].enum_for(:scan, /cttctt/).map { Regexp.last_match.begin(0) }
    # source: https://stackoverflow.com/questions/5241653/ruby-regex-match-and-get-positions-of#5241843
    
    puts positions_exon

end