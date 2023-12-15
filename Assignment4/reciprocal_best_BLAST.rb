require 'bio'

puts "Making databases, BLAST is required for this..."
system("makeblastdb -in Sequence_files/pombe_aa.fa -dbtype 'prot' -out Sequence_files/pombe_aa")
system("makeblastdb -in Sequence_files/thali_na.fa -dbtype 'nucl' -out Sequence_files/thali_na")

start = Time.now
# Creating BLAST factories:
puts "Creating BLAST factories..."
factory_pombe_aa = Bio::Blast.local('blastx', 'Sequence_files/pombe_aa', '-F "m S"' '-s T') 
factory_thali_na = Bio::Blast.local('tblastn', 'Sequence_files/thali_na', '-F "m S"' '-s T') 
# https://doi.org/10.1093/bioinformatics/btm585
factories = Time.now
puts "Time elapsed: #{factories - start} seconds"

# Iterating over each S.pombe protein from local proteome:
puts "Iterating over each S.pombe protein from local proteome..."
pombe_fasta = Bio::FlatFile.open(Bio::FastaFormat, 'Sequence_files/pombe_aa.fa')
n = 0
pombe_fasta.each_entry do |pombe_fasta_entry|

    # Quering A.thaliana local proteome for BLAST best hit:
    hits_thali = factory_thali_na.query(pombe_fasta_entry.seq.to_s).hits
    next if hits_thali.empty? || hits_thali.first.evalue > 0.05

    # Appending best hit to results file if it's e-value < 0.5
    File.open("./results.table", 'a') { |file| file.puts("#{hits_thali.first.definition.split("|")[0].strip}\t#{pombe_fasta_entry.entry_id}") }
    n += 1
    puts "Protein: #{n}/total"
end
puts n
pombe_proteins = Time.now
puts "Time elapsed: #{(pombe_proteins - start)/60} minutes"

# For some reason ".each_entry" method of flat file doesn't reset to the first entry 
# each time the loop is runned. So I'm replacing it with an array:
thali_fasta = Bio::FlatFile.open(Bio::FastaFormat, 'Sequence_files/thali_na.fa')
thali_entries_array = []
thali_fasta.each_entry do |thali_fasta_entry|
    thali_entries_array << thali_fasta_entry
end

puts "Checking if logged hits are reciprocal.."
rec_start = Time.now
# Reading all logged hits in order to check if they are reciprocal:
new_file_lines = "" # storing reciprocal hits to write later 
#source: https://stackoverflow.com/questions/17638621/deleting-a-specific-line-in-a-text-file)
n = 0
IO.readlines("./results.table").each do |line|

    thali_entries_array.each do |thali_entry|
        if thali_entry.entry_id == line.split("\t")[0]
            
            # Once the fasta entry is found, it's queried in the S.pombe database:
            first_hit_pombe = factory_pombe_aa.query(thali_entry.seq.to_s).hits.first

            break if first_hit_pombe == nil

            # If the result is reciprocal, the hit is kept:
            if first_hit_pombe.definition.split("|")[0] == line.split("\t")[1].strip
                new_file_lines += line
            else break
            end
        end
    end
    n += 1
    puts "Protein: #{n}/total"
end
check_rec = Time.now
puts "Time elapsed: #{(check_rec - rec_start)/60} minutes"
puts "Total time elapsed: #{(check_rec - start)/60} minutes"

# Overwriting results table with reciprocal hits and adding headers:
File.open("./results.table", 'w') { |file| file.puts("A.thaliana\tS.pombe\n#{new_file_lines}") }