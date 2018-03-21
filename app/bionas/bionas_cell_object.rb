class BionasCellObject
  attr_accessor :value, :cell_type, :score, :on_path

  def initialize
    @cell_type = 'UP'
    @on_path = false
  end
end