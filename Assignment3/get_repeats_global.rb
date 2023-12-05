require 'bio'

File.open("./cttctt_repeats_global.gff", 'a') { |file| file.puts('##gff-version	3') }

file = "ArabidopsisSubNetwork_GeneList.txt"
subNetwork_GeneList = []
IO.readlines(file).each do |geneid|
    subNetwork_GeneList << geneid.strip
end

subNetwork_GeneList.each do |gene_locus|

    embl = Bio::EMBL.new(Bio::Fetch::EBI.query("ensemblgenomesgene",gene_locus ,'raw', 'embl'))

    bioseq = embl.to_biosequence
    sequence =  bioseq.seq
    chr_start = bioseq.primary_accession.split(':')[3].to_i

    bioseq.features.each do |feature|

        next unless feature.feature == "exon" && (/^[0-9]+..[0-9]+/.match?(feature.position) || /^complement\([0-9]+..[0-9]+\)/.match?(feature.position))
        position_str = /[0-9]+..[0-9]+/.match(feature.position).to_s

        range = Range.new(eval(position_str).begin() -1, eval(position_str).end() -1) 
        positions_plus_exon = sequence[range].enum_for(:scan, /cttctt/).map { Regexp.last_match.begin(0) }
        # source: https://stackoverflow.com/questions/5241653/ruby-regex-match-and-get-positions-of#5241843

        positions_plus_exon.each do |pos|
            feat = Bio::Feature.new('myrepeat', Range.new(range.begin()+pos+chr_start, range.begin()+pos+chr_start+5).to_s)
            feat.append(Bio::Feature::Qualifier.new('repeat_motif', 'CTTCTT'))
            feat.append(Bio::Feature::Qualifier.new('strand', '+'))
            bioseq.features << feat
        end

        positions_neg_exon = sequence[range].enum_for(:scan, /aagaag/).map { Regexp.last_match.begin(0) }

        positions_neg_exon.each do |pos|
            feat = Bio::Feature.new('myrepeat', Range.new(range.begin()+pos+chr_start, range.begin()+pos+chr_start+5).to_s)
            feat.append(Bio::Feature::Qualifier.new('repeat_motif', 'CTTCTT'))
            feat.append(Bio::Feature::Qualifier.new('strand', '-'))
            bioseq.features << feat
        end

    end

    bioseq.features.each do |feature|
        next unless feature.feature == "myrepeat"
        File.open("./cttctt_repeats_global.gff", 'a') { |file| file.puts("#{bioseq.entry_id}\tget_repeats_global.rb\trepeat_region\t#{eval(feature.position).begin}\t#{eval(feature.position).end}\t.\t#{feature.assoc['strand']}\t.\t.") }
    end

end
