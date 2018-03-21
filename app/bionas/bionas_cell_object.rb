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