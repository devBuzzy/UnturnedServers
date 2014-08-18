class RevisionsController < ApplicationController
  def show
    if not Object.const_defined?('GITHUB')
      @revisions = Array.new
    else
      begin
        @revisions = get_commits(params[:id])
      rescue
        return redirect_to revision_path("UnturnedServers"), :alert => 'Revisions for that repository do not exist.'
      end
    end
  	if not Object.const_defined?('REPOS')
      @repos = Array.new
    else
      config_repos = REPOS
      @repos = Array.new
      config_repos.each do |repo|
        git_repo = GITHUB.repos.get('Jake0oo0', repo[:name])
        oss = false
        if git_repo.private
          oss = true
        end
        url = git_repo.html_url
        @repos << {:name => repo[:name], :friendly => repo[:friendly], :url => url, :private => oss}
      end
    end
  end

  def index
  	redirect_to revision_path("UnturnedServers")
  end

  def get_commits(repo)
  	# https://developer.github.com/v3/repos/commits/
  	commits = Array.new
  	github_commits = GITHUB.repos.commits.all('Jake0oo0', repo)
  	github_commits.each do |response|
  		author = response.commit.author.name
  		sha = response.sha
  		url = response.html_url
  		message = response.commit.message
  		date = response.commit.author.date
  		commits << {:author => author, :sha => sha, :message => message, :date => date, :url => url}
  	end
  	commits = Kaminari.paginate_array(commits).page(params[:page]).per(10)
  end
end
