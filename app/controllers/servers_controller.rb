class ServersController < ApplicationController
	before_filter :authenticate_user!, :except => [:index, :show, :banner]

	def index
		if params[:search]
			query = params[:search][:query]
			return @servers = Server.full_text_search(query, allow_empty_search: true).desc("vote_count").page(params[:page])
		elsif params[:tag]
			return @servers = Server.any_in(tags: [params[:tag]]).desc("vote_count").page(params[:page])
		elsif params[:version]
			return @servers = Server.where(version: params[:version].gsub("-", ".")).desc("vote_count").page(params[:page]) 
		elsif params[:owner]
			return @servers = Server.where(:user => User.where(:username => params[:owner]).first).desc("vote_count").page(params[:page])
		end
		@servers = Server.desc("vote_count").page(params[:page])
	end
	
	def show
		@server = Server.find(params[:id])
		return redirect_to servers_path, :alert => 'That server does not exist.' if @server == nil
	end

	def new
		@server = current_user.servers.new
	end

	def edit
		@server = Server.find(params[:id])
		@server.tag_list
	end

	def update
		@server = Server.find(params[:id])
		if @server.update(server_params)
			redirect_to @server, :notice => 'Successfully made changes to a server.'
		else
			render 'edit'
		end
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
		params.require(:server).permit(:twitter, :facebook, :reddit, :youtube, :website, :steam, :tags, :tag_string, :banner, :banner_cache, :slots, :title, :ip, :port, :pvp, :info, :gold, :location, :version, :difficulty, :sync, :map)
	end
end
