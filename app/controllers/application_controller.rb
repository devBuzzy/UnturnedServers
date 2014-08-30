class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  include ApplicationHelper
  
  def contact
    form = params[:contact]
    username = form[:username]
    email = form[:email]
    question = form[:question]
    return redirect_to root_path, notice: 'Please make sure to fill all fields.' if username == nil or email == nil or question == nil
    UserMailer.contact(email, username, question).deliver
    return redirect_to root_path, notice: 'Successfully submitted an inquiry.'
  end

  def user
    @user = User.where(:username => params[:username]).first
    @servers = Server.where(:user => @user).page(params[:page])
  end

  def stats
    @servers = Server.all
    @user = User.all
  end

  def favorites
    return redirect_to root_path, :notice => "You must be signed in to view your favorites." if not current_user
    favs = current_user.favorites
    @servers = Array.new
    favs.each do |fav|
      @servers << fav.server
    end
    @servers = Kaminari.paginate_array(@servers).page(params[:page])
  end

  def countries
    @countries = Server.distinct(:country)
  end

  def tags
    @tags = Tag.gt(count: 0)
  end

  def versions
    @versions = Server.distinct(:version)
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:steam, :twitter, :youtube, :facebook, :skype, :reddit, :github, :twitch, :newsletter, :username, :email, :password, :password_confirmation)
    end
  end
end
