require "./seed_stock_database"

# Gene Object tests the format of the Gene Identifier and rejects incorrect formats without crashing

g = Gene.new("AT1G69120", "gene_information.tsv")

puts g.gene_name

#uncomment the newt line to see the abort message:
#g = Gene.new("AT1G_9120", "gene_information.tsv")
#it detects valid id's. And if the id is not in the information file the object is still created but with no additional information
#if that happens the user is notified:
g = Gene.new("AT1G39120", "gene_information.tsv")

# Object that represents your entire Seed Stock "database"
# load_from_file method:
db = SeedStockDatabase.new("My database", "gene_information.tsv")

db.load_from_file("seed_stock_data.tsv") #with it's error messages if no file is given

# access individual SeedStock objects based on their ID
puts db.get_seed_stock("B3334").stock

#write_database method is demonstrated on the process_database script