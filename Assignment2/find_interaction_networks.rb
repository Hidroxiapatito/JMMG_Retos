require './helper'

IO.readlines("ArabidopsisSubNetwork_GeneList.txt")[2..4].each do |geneid|

    puts geneid.strip!

    print(get_interactions(geneid)[0], get_interactions(geneid)[1])

    puts

end