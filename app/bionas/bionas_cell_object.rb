# Matris içindeki her bir hücredeki parametreleri temsil edecek bir sınıftır.
# value    : formule göre elde edilen hücre içindeki sonuç değeri.
# cell_type: left,up,diag değerlerini tutar
# score    : ilgili matrise göre (blosum62 gibi) score değeri tutar
# on_path  : geri dönüşün görselleştirilmesi için path bilgisi tutuluyor.

class BionasCellObject
  attr_accessor :value, :cell_type, :score, :on_path

  # @on_path = 0 # path üzerinde değil
  # @on_path = 1 # left
  # @on_path = 2 # diag
  # @on_path = 3 # up
  def initialize
    @cell_type = 'UP'
    @on_path = 0
  end
end