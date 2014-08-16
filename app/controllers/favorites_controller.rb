class FavoritesController < ApplicationController
  before_filter :authenticate_user!
  def new
    @server = Server.find(params[:server_id])
    return redirect_to @server if current_user.has_favored(@server)
    @favorite = @server.favorites.create
    current_user.favorites << @favorite
    redirect_to @server, :notice => 'Added server to favorites.'
  end

  def show
    @server = Server.find(params[:server_id])
    @favorite = @server.favorites.find(params[:favorite_id])
    return redirect_to @server
  end

  def destroy
    @server = Server.find(params[:server_id])
    return redirect_to @server, :alert => 'You have not favorited this server yet.' if not current_user.has_favored(@server)
    @favorite = Favorite.find(params[:id])
    @favorite.destroy
    redirect_to @server
  end

  private
  def favorite_params
    params.require(:favorite)
  end
end
