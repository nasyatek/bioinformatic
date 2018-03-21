require 'matrix'
class BionasBlosum62

  def createMatris(filename)
    puts "File name : #{filename}"
    s = Rails.root + "app/" + "bionas/" + filename
    file = File.open(s, 'r')
    @matrix_blosum62 = []
    lines = file.readlines
    @list_header_row = lines.first.split(' ')
    lines.shift
    @list_header_col = []
    lines.each do |ll|
      @list_header_col.push(ll.split(' ').first)
      l = ll.split(' ')
      l.shift # İlk elemanı sildik.
      l = l.map(&:to_i) # Elemanların tümünü int çevirdik.
      @matrix_blosum62.push(l) # Matrix'e push ettik.
    end
    file.close
  end

  def lookup_score(a, b)
    a.upcase!
    b.upcase!
    row = @list_header_row.find_index(a)
    col = @list_header_col.find_index(b)
    if row.nil? || col.nil?
      "!"
    else
      @matrix_blosum62[row][col]
    end
  end

  def getHtmlMatrix(sequpairmodel)
    @matrix_last = []
    @sequence1 = sequpairmodel.seq1
    @sequence2 = sequpairmodel.seq2
    gap = sequpairmodel.gap.to_i
    mismatch = sequpairmodel.mismatch.to_i
    @firstrow = []
    (@sequence2.length + 1).times do |i|
      biocell = BionasCellObject.new
      biocell.value = i * gap
      @firstrow[i] = biocell
    end
    @matrix_last.push(@firstrow)
    1.upto(@sequence1.length) do |i|
      next_row = []
      biocell = BionasCellObject.new
      biocell.value = i * gap
      biocell.cell_type = 'LEFT'
      next_row.push(biocell)
      1.upto(@sequence2.length) do |j|
        valDiag = @matrix_last[(i - 1)][(j - 1)].value
        valUp = @matrix_last[(i - 1)][j].value
        valLeft = next_row[(j - 1)].value
        a = @sequence1[i - 1]
        b = @sequence2[j - 1]
        biocell = BionasCellObject.new
        biocell.value = best_value_for_cell(a, b, valLeft, valDiag, valUp)[0]
        biocell.cell_type = best_value_for_cell(a, b, valLeft, valDiag, valUp)[1]
        puts "i: #{i} j:#{j} a:#{a} b:#{b} lookUpScore:#{lookup_score(a, b)} valLeft:#{valLeft} valDiag:#{valDiag} valup:#{valUp} bestValue:#{biocell.value}"
        next_row.push(biocell)
      end
      @matrix_last.push(next_row)
    end
    @matrix_last
  end

  # C(i,j) matrix hücresi
  # S(a,b) A ve B için skor
  # g = -10 gab için ceza değeri
  # qDiag = C(i-1, j-1) + S(i,j)
  # qUp = C(i-1, j) + q
  # qLeft = C(i,j-1) + g
  # qResult = max(qDiag, qUp, qLeft)

  def best_value_for_cell(a, b, left, diag, up)
    gap = -10
    qDiag = diag + lookup_score(a, b) # c(i-1, j-1)+lookup_score(a,b) !çarpraz
    qUp = up + gap # c(i-1, j) + gap  !yukarı
    qLeft = left + gap # c(i, j - 1) + gap  !sol
    puts "CELL:#{qDiag}  LEFT: #{left}    DIAG: #{diag}    UP: #{up} lookupScore : #{lookup_score(a, b)}"
    v = [qDiag, qUp, qLeft].max

    case v
      when qDiag
        select = 'DIAG'
      when qUp
        select = 'UP'
      when qLeft
        select = 'LEFT'
    end
    [[qDiag, qUp, qLeft].max, select]
  end


  def getBloScore(sequpair)
    @matrixblosum = []
    @seq1 = sequpair.seq1
    @seq2 = sequpair.seq2
    row = @seq2.split('')
    row.insert(0, " ")
    @matrixblosum.push(row)
    1.upto(@seq1.length) do |i|
      next_row = []
      next_row.push(@seq1[i - 1])
      1.upto(@seq2.length) do |j|
        a = @seq1[i - 1]
        b = @seq2[j - 1]
        bestScore = lookup_score(a, b)
        next_row.push(bestScore)
      end
      @matrixblosum.push(next_row)
    end
    @matrixblosum
  end
end