class EvoMatrices
  def self.getBlosum62 (filename)
    puts "File name : #{filename}"
    s = Rails.root + "app/" + "bionas/" + filename
    file = File.open(s, 'r')
    @matrix_blosum62 = []
    lines = file.readlines
    lines.each do |ll|
      l = ll.split(' ')
      @matrix_blosum62.push(l) # Matrix'e push ettik.
    end
    file.close
    @matrix_blosum62[0].insert(0, " ")
    @matrix_blosum62
  end
end