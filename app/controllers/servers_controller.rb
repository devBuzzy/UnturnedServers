class ServersController < ApplicationController
  def index
  	@servers = Server.all
  end

  def show
  	@server = Server.find(params[:id])
  end

  def new
  	@server = current_user.servers.new
  end

  def edit
  	@server = Server.find(params[:id])
  end

  def create
  	@server = current_user.servers.create(server_params)
  	if @server.save
  		redirect_to servers_path, :notice => 'You successfully created a new server yet.'
  	else
  		render 'edit'
  	end
  end

  private
  def server_params
  	params.require(:server).permit(:title, :ip, :port, :pvp, :info, :gold, :location, :version, :difficulty, :sync, :map)
  end

end
