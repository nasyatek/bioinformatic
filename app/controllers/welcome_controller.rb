class WelcomeController < ApplicationController
  def index
    @sequpairmodel = Sequpair.new
    @sequpairmodel.seq1 = "SAMPLE"
    @sequpairmodel.seq2 = "SAMPLE"
    @sequpairmodel.gap = -10
    @sequpairmodel.mismatch = -1
    @sequpairmodel.result = @sequpairmodel.seq1 + ":" + @sequpairmodel.seq2
    @biosum62 = BionasBlosum62.new
    @biosum62.createMatris('blosum62')
    @matrixhtml = @biosum62.getHtmlMatrix(@sequpairmodel)
    puts "HTML MATRIS: #{@matrixhtml}"
  end

  def tester
    @sequence1 = "SAMPLE"
    @sequence2 = "SAMPLE"
    @biosum62 = BionasBlosum62.new
    @biosum62.createMatris('blosum62')
  end
end
