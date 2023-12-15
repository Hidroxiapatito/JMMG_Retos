require 'bio'

factory_pombe_aa = Bio::Blast.local('blastx', 'Sequence_files/pombe_aa', '-F "m S"') 
factory_thali_na = Bio::Blast.local('tblastn', 'Sequence_files/thali_na', '-F "m S"') 
# factory_thali_na = Bio::Blast.local('tblastn','database/thali_na', '-F "m S" -s T') 
# factory_thali_na = Bio::Blast.local('tblastn','database/thali_na', '-F "m S"') 

pombe_fasta = Bio::FlatFile.open(Bio::FastaFormat, 'Sequence_files/pombe_aa.fa')

# pombe_fasta.each_entry do |entry|
entry = pombe_fasta.first

    first_hit_thali = factory_thali_na.query(entry.seq.to_s).hits.first
    # factory_thali_na.query(entry.seq.to_s).hits[..3].each do |first_hit_thali|

    puts first_hit_thali.hit_id
    puts first_hit_thali.evalue
    puts first_hit_thali.definition
    puts
    # if first_hit_thali.evalue < 0.05
    #     puts first_hit_thali.hit_id
    #     puts first_hit_thali.target_id
    #     puts first_hit_thali.query_seq
    #     puts first_hit_thali.target_seq
    # end
#  end
