require "csv"

# Abre el archivo CSV
file = File.open("seed_stock_data.tsv")

# Lee los datos del archivo
table = CSV.table(file, col_sep: "\t")

# Cierra el archivo
file.close

# Imprime el nombre de la primera persona
puts table


