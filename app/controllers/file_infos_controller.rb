class FileInfosController < ApplicationController
  before_action :set_file_info, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, :only => [:multi_update]

  # GET /file_infos
  # GET /file_infos.json
  def index
    @file_infos = FileInfo.includes(:component).all
  end

  # GET /file_infos/1
  # GET /file_infos/1.json
  def show
  end

  # GET /file_infos/new
  def new
    @file_info = FileInfo.new
  end

  # GET /file_infos/1/edit
  def edit
  end

  # POST /file_infos/multi_update
  # POST /file_infos/multi_update.json
  def multi_update
    errors = false
    return_value = []
    file_infos_params = params.permit(file_infos: [:id, :review_done, :component_id]).require(:file_infos)
    file_infos_params.each do |key, file_info_entry|
      (return_value << nil) and (errors = true) and next unless file_info_entry[:id]
      file_info = FileInfo.find(file_info_entry[:id])
      (return_value << nil) and (errors = true) and next unless file_info
      if file_info.update(file_info_entry)
        return_value << file_info_entry
      else
        return_value << file_info.errors
        errors = true
      end
    end
    respond_to do |format|
      format.json { render json: return_value }
      if errors
        format.html { redirect_to :back, notice: 'Some entries have errors'}
      else
        format.html { redirect_to :back }
      end
    end
  end

  # POST /file_infos
  # POST /file_infos.json
  def create
    @file_info = FileInfo.new(file_info_params)

    respond_to do |format|
      if @file_info.save
        format.html { redirect_to @file_info, notice: 'File info was successfully created.' }
        format.json { render :show, status: :created, location: @file_info }
      else
        format.html { render :new }
        format.json { render json: @file_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /file_infos/1
  # PATCH/PUT /file_infos/1.json
  def update
    respond_to do |format|
      if @file_info.update(file_info_params)
        format.html { redirect_to @file_info, notice: 'File info was successfully updated.' }
        format.json { render :show, status: :ok, location: @file_info }
      else
        format.html { render :edit }
        format.json { render json: @file_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /file_infos/1
  # DELETE /file_infos/1.json
  def destroy
    @file_info.destroy
    respond_to do |format|
      format.html { redirect_to file_infos_url, notice: 'File info was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_file_info
      @file_info = FileInfo.includes(:component).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def file_info_params
      params.require(:file_info).permit(:folder, :loc, :name, :type, :review_done, :component_id)
    end
end
