require "./seed_stock_database"

filenames = [ARGV[0], ARGV[1], ARGV[2], ARGV[3]]

unless filenames[0] && filenames[1] && filenames[2] && filenames[3]
    abort "proper execution of this script is: ruby process_database.rb \
gene_information.tsv  seed_stock_data.tsv  cross_data.tsv  new_stock_file_name.tsv"
end

db = SeedStockDatabase.new(gene_information_file: filenames[0]) #Additionally, a name can be provided

puts db.name

db.load_from_file(filenames[1])

db.plant_seeds("all", 7)

db.get_crosses(filenames[2])

puts
puts "Final Report:"
puts
db.stocks.each do |stock|
    if stock.gene.linked_to
        puts "#{stock.gene.gene_name} is linked to #{stock.gene.linked_to}"
    end
end

db.write_database(filenames[3])