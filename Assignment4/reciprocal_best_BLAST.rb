require 'bio'

# factory_pombe_aa = Bio::Blast.local('blastx', 'Sequence files/pombe_aa') 
# factory_thali_na = Bio::Blast.local('tblastn', 'Sequence files/thali_na') 

file = Bio::FlatFile.open(Bio::FastaFormat, 'Sequence files/pombe_aa.fa')

file.each_entry do |entry|
    report = factory_pombe_aa.query(entry.seq.to_s) 
end
