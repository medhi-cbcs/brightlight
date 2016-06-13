class TemplateTargetsController < ApplicationController
  before_action :set_template_target, only: [:show, :edit, :update, :destroy]

  # GET /template_targets
  # GET /template_targets.json
  def index
    @template_targets = TemplateTarget.all
  end

  # GET /template_targets/1
  # GET /template_targets/1.json
  def show
  end

  # GET /template_targets/new
  def new
    @template_target = TemplateTarget.new
  end

  # GET /template_targets/1/edit
  def edit
  end

  # POST /template_targets
  # POST /template_targets.json
  def create
    @template_target = TemplateTarget.new(template_target_params)

    respond_to do |format|
      if @template_target.save
        format.html { redirect_to @template_target, notice: 'Template target was successfully created.' }
        format.json { render :show, status: :created, location: @template_target }
      else
        format.html { render :new }
        format.json { render json: @template_target.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /template_targets/1
  # PATCH/PUT /template_targets/1.json
  def update
    respond_to do |format|
      if @template_target.update(template_target_params)
        format.html { redirect_to @template_target, notice: 'Template target was successfully updated.' }
        format.json { render :show, status: :ok, location: @template_target }
      else
        format.html { render :edit }
        format.json { render json: @template_target.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /template_targets/1
  # DELETE /template_targets/1.json
  def destroy
    @template_target.destroy
    respond_to do |format|
      format.html { redirect_to template_targets_url, notice: 'Template target was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template_target
      @template_target = TemplateTarget.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def template_target_params
      params.require(:template_target).permit(:name, :code, :description)
    end
end
