class ServersController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show, :banner]

  def index
  	@servers = Server.asc("vote_count").page(params[:page])
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
    @server = Server.find(params[:server_id])
    return redirect_to @server, :alert => 'You can not vote for your own server.' if @server.user == current_user
    return redirect_to @server, :alert => 'You can only vote once every 24 hours.' if @server.votes.where(created_at: ((Time.now - 24.hour) ..(Time.now))).where(user: current_user).any?
    captcha = params['form']['captcha']
    return redirect_to @server if captcha != 'zombie'
    @vote = Vote.create(:server => @server, :user => current_user)
    return redirect_to @server, :notice => 'Successfully voted.'
  end

  def banner
    @server = Server.find(params[:server_id])
    content = @server.banner.read
    if stale?(etag: content, last_modified: @server.updated_at, public: true)
      send_data content, type: @server.banner.file.content_type, disposition: "inline"
      expires_in 0, public: true
    end
  end

  private
  def server_params
  	params.require(:server).permit(:banner, :banner_cache, :slots, :title, :ip, :port, :pvp, :info, :gold, :location, :version, :difficulty, :sync, :map)
  end

end
