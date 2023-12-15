require 'bio'

# Creating BLAST factories:
factory_pombe_aa = Bio::Blast.local('blastx', 'Sequence_files/pombe_aa', '-F "m S"' '-s T') 
factory_thali_na = Bio::Blast.local('tblastn', 'Sequence_files/thali_na', '-F "m S"' '-s T') 
# https://doi.org/10.1093/bioinformatics/btm585

# Iterating over each S.pombe protein from local proteome:
pombe_fasta = Bio::FlatFile.open(Bio::FastaFormat, 'Sequence_files/pombe_aa.fa')
x = 0# XDDDDDDDDDDDDDDddd
pombe_fasta.each_entry do |pombe_fasta_entry|

    # Quering A.thaliana local proteome for BLAST best hit:
    hits_thali = factory_thali_na.query(pombe_fasta_entry.seq.to_s).hits
    next if hits_thali.empty? || hits_thali.first.evalue > 0.05

    x += 1
    # Appending best hit to results file if it's e-value < 0.5
    File.open("./results.table", 'a') { |file| file.puts("#{hits_thali.first.definition.split("|")[0].strip}\t#{pombe_fasta_entry.entry_id}") }
end
puts x

# Reading all logged hits in order to check if they are reciprocal:
thali_fasta = Bio::FlatFile.open(Bio::FastaFormat, 'Sequence_files/thali_na.fa')
results = IO.readlines("./results.table")
new_file_lines = "" # storing good hits to write later 
#source: https://stackoverflow.com/questions/17638621/deleting-a-specific-line-in-a-text-file)
results.each do |line|

    thali_fasta.each_entry do |thali_fasta_entry|
        puts thali_fasta_entry.entry_id, line.split("\t")[0]
        if thali_fasta_entry.entry_id == line.split("\t")[0]

            first_hit_pombe = factory_pombe_aa.query(thali_fasta_entry.seq.to_s).hits.first

            next if first_hit_pombe == nil
            puts first_hit_pombe.definition.split("|")[0]
            puts line.split("\t")[1].strip
            if first_hit_pombe.definition.split("|")[0] == line.split("\t")[1].strip
                new_file_lines += line
            end
        end
    end
end

# Overwriting results table with headers:
File.open("./results.table", 'w') { |file| file.puts("A.thaliana\tS.pombe\n#{new_file_lines}") }