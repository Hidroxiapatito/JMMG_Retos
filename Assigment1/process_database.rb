require "csv"

# Abre el archivo CSV
file = File.open("seed_stock_data.tsv")

# Lee los datos del archivo
table = CSV.table(file, col_sep: "\t")

# Cierra el archivo
file.close

# Imprime el nombre de la primera persona
(0..table.length-1).each do |row|
    if table[:seed_stock][row] == "B3334"
        puts table[:mutant_gene_id][row]
    end
end

