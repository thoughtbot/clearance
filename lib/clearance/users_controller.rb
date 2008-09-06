module Clearance
  module UsersController

    before_filter :authenticate
    before_filter :ensure_user_is_accessing_self, :only => [:edit, :update, :show]
    
    filter_parameter_logging :password

    def new
      @user = User.new
      render :action => 'new'
    end

    def create
      @user = User.new params[:user]

      if @user.save
        flash[:notice] = "User has been created."
        redirect_to users_url
      else
        render :action => 'new'
      end
    end

    def index
      @users = User.find :all
    end

    def show
      @user = User.find params[:id]
      redirect_to edit_user_url(@user)
    end

    def edit
      @user = User.find params[:id]
      render :action => 'edit'
    end

    def update
      @user = User.find params[:id]
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User updated.'
        redirect_to root_url
      else
        render :action => 'edit'
      end
    end

    def destroy
      @user = User.find params[:id]
      @user.destroy
      flash[:notice] = "#{@user.name} was successfully deleted."
      redirect_to users_url
    end

    private

    def ensure_user_is_accessing_self
      deny_access 'You cannot edit that user.' unless current_user.id.to_i == params[:id].to_i
    end

  end
end
