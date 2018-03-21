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
    @sequpairmodel = sequpairmodel
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
        biocell = best_value_for_cell(a, b, valLeft, valDiag, valUp, biocell)
        #puts "i: #{i} j:#{j} a:#{a} b:#{b} lookUpScore:#{lookup_score(a, b)} valLeft:#{valLeft} valDiag:#{valDiag} valup:#{valUp} bestValue:#{biocell.value}"
        next_row.push(biocell)
      end
      @matrix_last.push(next_row)
    end
    find_best_path
    @matrix_last
  end

  # C(i,j) matrix hücresi
  # S(a,b) A ve B için skor
  # g = -10 gab için ceza değeri
  # qDiag = C(i-1, j-1) + S(i,j)
  # qUp = C(i-1, j) + q
  # qLeft = C(i,j-1) + g
  # qResult = max(qDiag, qUp, qLeft)

  def best_value_for_cell(a, b, left, diag, up, biocell)
    gap = -10
    qDiag = diag + lookup_score(a, b) # c(i-1, j-1)+lookup_score(a,b) !çarpraz
    qUp = up + gap # c(i-1, j) + gap  !yukarı
    qLeft = left + gap # c(i, j - 1) + gap  !sol
    #puts "CELL:#{qDiag}  LEFT: #{left}    DIAG: #{diag}    UP: #{up} lookupScore : #{lookup_score(a, b)}"
    biocell.value = [qDiag, qUp, qLeft].max
    biocell.score = lookup_score(a, b)
    case biocell.value
      when qDiag
        biocell.cell_type = 'DIAG'
      when qUp
        biocell.cell_type = 'UP'
      when qLeft
        biocell.cell_type = 'LEFT'
    end
    biocell
  end

  def find_best_path
    vertical = @matrix_last.length - 1 # 3
    horizon = @matrix_last[0].length - 1 # 4
    sequst = @sequpairmodel.seq2.split('')
    seqleft = @sequpairmodel.seq1.split('')
    puts "vertical : #{vertical} #{horizon}"
    puts "ust: #{sequst} yan: #{seqleft}"
    vertical.downto(1) do |i|
      puts "i,j:#{i},#{horizon} cell:#{@matrix_last[i][horizon].value}"
      if @matrix_last[i][horizon].cell_type == 'LEFT'
        @matrix_last[i][horizon].on_path = 1
        seqleft.insert(i, '-')
      end
      if @matrix_last[i][horizon].cell_type == 'DIAG'
        @matrix_last[i][horizon].on_path = 2
      end
      if @matrix_last[i][horizon].cell_type == 'UP'
        @matrix_last[i][horizon].on_path = 3
        sequst.insert(i, '-')
      end
      horizon -= 1
    end
    puts "ust: #{sequst} yan: #{seqleft}"
    @sequpairmodel.result = sequst.join.to_s + ':' + seqleft.join.to_s
    @sequpairmodel
  end
end
