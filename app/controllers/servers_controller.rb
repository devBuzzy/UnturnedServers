class ServersController < ApplicationController
	before_filter :authenticate_user!, :except => [:index, :show, :banner, :embed, :display, :vote]
	def index
		if @servers
			return @servers
		elsif params[:country]
			return @servers = Server.where(:country => params[:country]).desc("vote_count").page(params[:page])
		elsif params[:tag]
			tag = Tag.find_by(text: params[:tag])
			return @servers = tag.servers.desc("vote_count").page(params[:page])
		elsif params[:version]
			return @servers = Server.where(version: params[:version].gsub("-", ".")).desc("vote_count").page(params[:page]) 
		elsif params[:owner]
			return @servers = Server.where(:user => User.where(:username => params[:owner]).first).desc("vote_count").page(params[:page])
		end
		@servers = Server.desc("vote_count").page(params[:page])
	end

	def search
		query = params[:search]
		@servers = Server.full_text_search(query, allow_empty_search: true).desc("vote_count").page(params[:page])
		return render action: 'index'
	end

	def embed
		@server = Server.find(params[:server_id])
		type = params[:type]
		@text = ""
		@url = ""
		@height = 34
		@width = 191
		if type
			if type == "favorites"
				@url = new_server_favorite_url(@server)
				@text = "Like on Unturned ServerZ"
			else
				@url = server_vote_url(@server)
				@text = "Vote on Unturned ServerZ"
			end
		else
			@url = server_vote_url(@server)
			@text = "Vote on Unturned ServerZ"
		end
		size = params[:size]
		@class = ""
		if size
			if size == "large"
				@class = "btn-lg"
				@height = 45
				@width = 243
			elsif size == "small"
				@class = "btn-sm"
				@height = 30
				@width = 162
			end
		end
		@color = params[:color] ? params[:color] : "primary"
		render :layout => "embed"
	end

	def display
		@height = 34
		@width = 191
		@server = Server.find(params[:server_id])
		@type = params[:type]
		@color = params[:type]
		@size = params[:size]
		if @size == "large"
			@height = 45
			@width = 243
		elsif @size == "small"
			@height = 30
			@width = 162
		end
		respond_to do |format|
    	format.js
  	end
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
		return redirect_to servers_path if not can_manage(@server)
	end

	def update
		@server = Server.find(params[:id])
		return redirect_to servers_path if not can_manage(@server)
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
		return redirect_to servers_path if not can_manage(@server)
		@server.destroy
		redirect_to servers_path, :notice => "Successfully deleted a server."
	end

	def vote
		@server = Server.find(params[:server_id])
	end

	def cast_vote
		@server = Server.find(params[:server_id])
		return redirect_to @server, :alert => 'You can not vote for your own server.' if @server.user.current_sign_in_ip == request.remote_ip or (current_user and @server.user == current_user)
		return redirect_to @server, :alert => 'You can only vote once every 24 hours.' if @server.votes.where(created_at: ((Time.now - 24.hour) ..(Time.now))).where(ip: request.remote_ip).any?
		captcha = params['form']['captcha']
		return redirect_to @server if captcha != 'zombie'
		@vote = Vote.create(:server => @server, :ip => request.remote_ip)
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
		params.require(:server).permit(:twitter, :facebook, :reddit, :youtube, :website, :steam, :tags, :tag_string, :banner, :banner_cache, :slots, :title, :ip, :port, :pvp, :info, :gold, :country, :version, :difficulty, :sync, :map)
	end
end
