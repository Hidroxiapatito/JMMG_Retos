require 'bio'

File.open("./cttctt_repeats_local.gff", 'a') { |file| file.puts('##gff-version	3') }
File.open("./report.txt", 'a') { |file| file.puts('Genes of the list that don\'t have exons with CTTCTT repeats:') }

file = "ArabidopsisSubNetwork_GeneList.txt"
subNetwork_GeneList = []
IO.readlines(file).each do |geneid|
    subNetwork_GeneList << geneid.strip
end

sequences = Hash.new()
subNetwork_GeneList.each do |gene_locus|

    embl = Bio::EMBL.new(Bio::Fetch::EBI.query("ensemblgenomesgene",gene_locus ,'raw', 'embl'))

    bioseq = embl.to_biosequence
    sequence =  bioseq.seq

    bioseq.features.each do |feature|

        next unless feature.feature == "exon" && (/^[0-9]+..[0-9]+/.match?(feature.position) || /^complement\([0-9]+..[0-9]+\)/.match?(feature.position))
        position_str = /[0-9]+..[0-9]+/.match(feature.position).to_s

        range = Range.new(eval(position_str).begin() -1, eval(position_str).end() -1) 
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

    x = 0
    bioseq.features.each do |feature|
        next unless feature.feature == "myrepeat"
        x = 1
        File.open("./cttctt_repeats_local.gff", 'a') { |file| file.puts("#{bioseq.primary_accession}\tget_repeats.rb\trepeat_region\t#{eval(feature.position).begin}\t#{eval(feature.position).end}\t.\t#{feature.assoc['strand']}\t.\t.") }
    end

    if x == 0
        File.open("./report.txt", 'a') { |file| file.puts(gene_locus) }
    else
        sequences[bioseq.primary_accession] = sequence.to_s.upcase
    end
end

File.open("./cttctt_repeats_local.gff", 'a') { |file| file.puts('##FASTA') }
sequences.each do |key, seq|
    File.open("./cttctt_repeats_local.gff", 'a') { |file| file.puts(">#{key}") }
    File.open("./cttctt_repeats_local.gff", 'a') { |file| file.puts(seq) }
end

# source: https://stackoverflow.com/questions/59902863/ruby-how-to-remove-duplicate-lines-from-a-document-text
require 'set'
st = IO.foreach("./cttctt_repeats_local.gff", chomp: true).with_object(Set.new) do |line, st|
  st.add(line)
end

File.open("./cttctt_repeats_local.gff", 'w') do |f|
    st.each { |s| f.puts(s) }
  end