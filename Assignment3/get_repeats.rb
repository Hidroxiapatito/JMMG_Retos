require 'bio' # Using bioruby

# This script has 2 output files: cttctt_repeats_local.gff and report.txt

# First line of output files
File.open("./cttctt_repeats_local.gff", 'a') { |file| file.puts('##gff-version	3') }
File.open("./report.txt", 'a') { |file| file.puts('Genes of the list that don\'t have exons with CTTCTT repeats:') }

# Loading list of problem genes
file = "ArabidopsisSubNetwork_GeneList.txt" # INPUT LIST
subNetwork_GeneList = []
IO.readlines(file).each do |geneid|
    subNetwork_GeneList << geneid.strip
end

# We define a hash for storing que sequences of genes that have cttctt repeats later 
sequences = Hash.new()
# Iterating through all genes of our list
subNetwork_GeneList.each do |gene_locus|

    # fetching embl file into an EMBL entry bioruby object, which is stored temporarily on the 'embl' variable
    embl = Bio::EMBL.new(Bio::Fetch::EBI.query("ensemblgenomesgene",gene_locus ,'raw', 'embl'))

    bioseq = embl.to_biosequence #entry object to sequence object
    sequence =  bioseq.seq # getting raw sequence in order to extract exons

    #iterating over the features of all genes
    bioseq.features.each do |feature|

        # Getting only exons that belong to our gene, and not nearby genes:
        next unless feature.feature == "exon" && (/^[0-9]+..[0-9]+/.match?(feature.position) || /^complement\([0-9]+..[0-9]+\)/.match?(feature.position))
        position_str = /[0-9]+..[0-9]+/.match(feature.position).to_s

        # This range gets the exon from the sequence
        range = Range.new(eval(position_str).begin() -1, eval(position_str).end() -1) 
        # Exon is scanned for repeats in the positive strand
        positions_plus_exon = sequence[range].enum_for(:scan, /cttctt/).map { Regexp.last_match.begin(0) }
        # source: https://stackoverflow.com/questions/5241653/ruby-regex-match-and-get-positions-of#5241843

        # Positions of repeats on the forward strand are added to this sequence object features
        positions_plus_exon.each do |pos|
            feat = Bio::Feature.new('myrepeat', Range.new(range.begin()+pos+1, range.begin()+pos+6).to_s)
            feat.append(Bio::Feature::Qualifier.new('repeat_motif', 'CTTCTT'))
            feat.append(Bio::Feature::Qualifier.new('strand', '+'))
            bioseq.features << feat
        end

        # Getting repeat positions on the reverse strand
        positions_neg_exon = sequence[range].enum_for(:scan, /aagaag/).map { Regexp.last_match.begin(0) }

        # Reverse strand repeat positions are added to features
        positions_neg_exon.each do |pos|
            feat = Bio::Feature.new('myrepeat', Range.new(range.begin()+pos+1, range.begin()+pos+6).to_s)
            feat.append(Bio::Feature::Qualifier.new('repeat_motif', 'CTTCTT'))
            feat.append(Bio::Feature::Qualifier.new('strand', '-'))
            bioseq.features << feat
        end

    end

    # Once we have all repeats added to features, we iterate trough them once again and we append them on gff format to our 
    # output file. If no repeats where annotated, x is equal to 0 and the gene is added to the report list.
    x = 0
    bioseq.features.each do |feature|
        next unless feature.feature == "myrepeat"
        x = 1
        File.open("./cttctt_repeats_local.gff", 'a') { |file| file.puts("#{bioseq.primary_accession}\tget_repeats.rb\trepeat_region\t#{eval(feature.position).begin}\t#{eval(feature.position).end}\t.\t#{feature.assoc['strand']}\t.\t.") }
    end

    if x == 0
        File.open("./report.txt", 'a') { |file| file.puts(gene_locus) }

    # If some repeats where annotated and added to the gff file, the sequence is saved to the hash for later.
    else
        sequences[bioseq.primary_accession] = sequence.to_s.upcase
    end
end

# Once all genes are annotated to the gff file, we need to add the fasta sequences that we refer to:
# We use the hash variable 'sequences' created earlier.
File.open("./cttctt_repeats_local.gff", 'a') { |file| file.puts('##FASTA') }
sequences.each do |key, seq|
    File.open("./cttctt_repeats_local.gff", 'a') { |file| file.puts(">#{key}") }
    File.open("./cttctt_repeats_local.gff", 'a') { |file| file.puts(seq) }
end

# As genes can have multiple splice variants, the same repeat can be annotated multiple times.
# This code utilizes sets to remove duplicate lines:
# source: https://stackoverflow.com/questions/59902863/ruby-how-to-remove-duplicate-lines-from-a-document-text
require 'set'
st = IO.foreach("./cttctt_repeats_local.gff", chomp: true).with_object(Set.new) do |line, st|
  st.add(line)
end

File.open("./cttctt_repeats_local.gff", 'w') do |f|
    st.each { |s| f.puts(s) }
  end