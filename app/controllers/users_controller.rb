class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :sortable_columns, only: [:index]

  def index
    authorize! :manage, User

    respond_to do |format|
      format.html do
        @users = User.joins('LEFT JOIN employees ON employees.user_id = users.id')          
          .order("#{sort_column} #{sort_direction}")
          .select('users.*, employees.id as employee_id')
          .order('name')
          .paginate(page: params[:page], per_page: 20)
        @users = @users.search_query(params[:search]) if params[:search]
        @users = @users.where(:employees => { is_active: 't' } ) if params[:active] == 't'
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

    def sortable_columns 
      [:name, :email, :roles_mask]
    end
end
