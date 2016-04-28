class AttachmentTypesController < ApplicationController
  before_action :set_attachment_type, only: [:show, :edit, :update, :destroy]

  # GET /attachment_types
  # GET /attachment_types.json
  def index
    @attachment_types = AttachmentType.all
  end

  # GET /attachment_types/1
  # GET /attachment_types/1.json
  def show
  end

  # GET /attachment_types/new
  def new
    @attachment_type = AttachmentType.new
  end

  # GET /attachment_types/1/edit
  def edit
  end

  # POST /attachment_types
  # POST /attachment_types.json
  def create
    @attachment_type = AttachmentType.new(attachment_type_params)

    respond_to do |format|
      if @attachment_type.save
        format.html { redirect_to @attachment_type, notice: 'Attachment type was successfully created.' }
        format.json { render :show, status: :created, location: @attachment_type }
      else
        format.html { render :new }
        format.json { render json: @attachment_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attachment_types/1
  # PATCH/PUT /attachment_types/1.json
  def update
    respond_to do |format|
      if @attachment_type.update(attachment_type_params)
        format.html { redirect_to @attachment_type, notice: 'Attachment type was successfully updated.' }
        format.json { render :show, status: :ok, location: @attachment_type }
      else
        format.html { render :edit }
        format.json { render json: @attachment_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attachment_types/1
  # DELETE /attachment_types/1.json
  def destroy
    @attachment_type.destroy
    respond_to do |format|
      format.html { redirect_to attachment_types_url, notice: 'Attachment type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attachment_type
      @attachment_type = AttachmentType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attachment_type_params
      params.require(:attachment_type).permit(:code, :name)
    end
end
