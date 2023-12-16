require 'bio'
$stdout.reopen("stdoutput.txt", "a")

puts "Making databases, BLAST is required for this..."
system("makeblastdb -in Sequence_files/pombe_aa.fa -dbtype 'prot' -out Sequence_files/pombe_aa")
system("makeblastdb -in Sequence_files/thali_na.fa -dbtype 'nucl' -out Sequence_files/thali_na")

start = Time.now
# Creating BLAST factories:
puts "Creating BLAST factories..."
factory_pombe_aa = Bio::Blast.local('blastx' , 'Sequence_files/pombe_aa', '-b5 -e 0.05' ' -F "m S"' '-s T') 
factory_thali_na = Bio::Blast.local('tblastn', 'Sequence_files/thali_na', '-b5 -e 0.05' ' -F "m S"' '-s T') 
# Getting first hit sorted by e-value if this is < 0.05 with soft filtering and a Smith–Waterman alignment.
# https://manpages.org/blastall
# https://doi.org/10.1093/bioinformatics/btm585
factories = Time.now
puts "Time elapsed: #{factories - start} seconds"

# Iterating over each S.pombe protein from local proteome:
puts "Iterating over each S.pombe protein from local proteome..."
pombe_fasta = Bio::FlatFile.open(Bio::FastaFormat, 'Sequence_files/pombe_aa.fa')
n = 0
x = 0
pombe_fasta.each_entry do |pombe_fasta_entry|
    n += 1
    puts "Protein: #{n}/5146" # value known after running

    # Quering A.thaliana local proteome for BLAST best hit:
    first_hit_thali = factory_thali_na.query(pombe_fasta_entry.seq.to_s).hits.first
    next if first_hit_thali == nil #|| first_hit_thali.evalue > 0.05

    x += 1
    # Appending best hit to results file if it's e-value < 0.05
    File.open("./results.table", 'a') { |file| file.puts("#{first_hit_thali.definition.split("|")[0].strip}\t#{pombe_fasta_entry.entry_id}") }

    puts "Protein: #{x}/3525 logged" # value known after running
end
puts "Logged best hit of #{x} proteins with e-value < 0.05 from total of #{n} proteins in S.pombe local database"

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
    n += 1
    puts "Protein: #{n}/3525"

    thali_entries_array.each do |thali_entry|
        if thali_entry.entry_id == line.split("\t")[0]
            
            # Once the fasta entry is found, it's queried in the S.pombe database:
            first_hit_pombe = factory_pombe_aa.query(thali_entry.seq.to_s).hits.first

            break if first_hit_pombe == nil #|| first_hit_pombe.evalue > 0.05

            # If the result is reciprocal, the hit is kept:
            if first_hit_pombe.definition.split("|")[0] == line.split("\t")[1].strip
                new_file_lines += line
            else break
            end
        end
    end
end
check_rec = Time.now
puts "Time elapsed: #{(check_rec - rec_start)/60} minutes"
puts "Total time elapsed: #{(check_rec - start)/60} minutes"

# Overwriting results table with reciprocal hits and adding headers:
File.open("./results.table", 'w') { |file| file.puts("A.thaliana\tS.pombe\n#{new_file_lines}") }