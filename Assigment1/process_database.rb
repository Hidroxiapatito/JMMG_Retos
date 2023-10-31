require "csv"

# Abre el archivo CSV
file = File.open("seed_stock_data.tsv")

# Lee los datos del archivo
table = CSV.table(file, col_sep: "\t")

# Cierra el archivo
file.close

string = "patata"

unless string.match(/A[Tt]\d[Gg]\d\d\d\d\d/)
    puts "does not match"
end

