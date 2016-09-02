class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  helper_method :sort_column, :sort_direction

  def index
    authorize! :manage, User

    respond_to do |format|
      format.html do
        @users = User.joins(:employee).where(:employees => { is_active: 't' } ).order("#{sort_column} #{sort_direction}").all.paginate(page: params[:page], per_page: 20)
      end
      format.csv do
        @users = User.all
        render text: @users.to_csv
      end
    end
  end

  def show
    authorize! :show, @user
  end

  def edit
    authorize! :edit, @user
  end

  def update
    authorize! :edit, @user

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :first_name, :last_name, :roles => [])
    end

 private
    def sortable_columns
      ["name", "email", "roles_mask"]
    end

    def sort_column
      sortable_columns.include?(params[:column]) ? params[:column] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

end
