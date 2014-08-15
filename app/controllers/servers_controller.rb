class ServersController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]

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

  def destroy
    @server = Server.find(params[:id])
    @server.destroy
    redirect_to servers_path
  end

  def vote
    @server = Server.find(params[:server_id])
  end

  def cast_vote
    captcha = params['form']['captcha']
    return redirect_to @server if captcha != 'zombie'
    @server = Server.find(params[:server_id])
    @vote = Vote.create(:server => @server, :user => current_user)
    return redirect_to @server, :notice => 'Successfully voted.'
  end

  private
  def server_params
  	params.require(:server).permit(:title, :ip, :port, :pvp, :info, :gold, :location, :version, :difficulty, :sync, :map)
  end

end
