class SequpairsController < ApplicationController
  before_action :set_sequpair, only: [:show, :edit, :update, :destroy]

  # GET /sequpairs
  # GET /sequpairs.json
  def index
    @sequpairs = Sequpair.all
  end

  # GET /sequpairs/1
  # GET /sequpairs/1.json
  def show
    @biosum62 = BionasBlosum62.new
    @biosum62.createMatris('blosum62')
    @matrixhtml = @biosum62.getHtmlMatrix(@sequpair)
    # puts "HTML MATRIS: #{@matrixhtml}"
  end

  # GET /sequpairs/new
  def new
    @sequpair = Sequpair.new
  end

  # GET /sequpairs/1/edit
  def edit
  end

  # POST /sequpairs
  # POST /sequpairs.json
  def create
    @sequpair = Sequpair.new(sequpair_params)

    respond_to do |format|
      if @sequpair.save
        format.html {redirect_to @sequpair, notice: 'Sequpair was successfully created.'}
        format.json {render :show, status: :created, location: @sequpair}
      else
        format.html {render :new}
        format.json {render json: @sequpair.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /sequpairs/1
  # PATCH/PUT /sequpairs/1.json
  def update
    respond_to do |format|
      if @sequpair.update(sequpair_params)
        format.html {redirect_to @sequpair, notice: 'Sequpair was successfully updated.'}
        format.json {render :show, status: :ok, location: @sequpair}
      else
        format.html {render :edit}
        format.json {render json: @sequpair.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /sequpairs/1
  # DELETE /sequpairs/1.json
  def destroy
    @sequpair.destroy
    respond_to do |format|
      format.html {redirect_to sequpairs_url, notice: 'Sequpair was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_sequpair
    @sequpair = Sequpair.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sequpair_params
    params.require(:sequpair).permit(:seq1, :seq2, :mattype, :result, :gap, :mismatch)
  end
end
