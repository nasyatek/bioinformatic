class EvosubmatriceController < ApplicationController
  def index
  end

  def show
    @matrixblosum62 = EvoMatrices.getBlosum62('blosum62')
  end
end
