class ReportsController < ApplicationController
	before_filter :authenticate_user!

  def new
  	@server = Server.find(params[:server_id])
    return redirect_to @server, :alert => 'You can not report your own server.' if current_user == @server.user
  	@report = @server.reports.new(:user => current_user)
  end

  def edit
    @server = Server.find(params[:server_id])
    return redirect_to @server, :alert => 'You do not have permission to edit this report.' unless current_user.try(:admin)
    @report = @server.reports.find(params[:report_id])
  end

  def create
    @server = Server.find(params[:server_id])
    @report = @server.reports.create(report_params)
    current_user.reports << @report
    if @report.save
      return redirect_to @server, :notice => 'Successfully created report.'
    else
      render 'edit'
    end
  end

  def show
    @server = Server.find(params[:server_id])
    return redirect_to @server, :alert => 'You do not have permission to view this report.' if !current_user.admin
    @reports = server.reports
  end

  def index
    @server = Server.find(params[:server_id])
    return redirect_to @server, :alert => 'You do not have permission to view server reports.' if !current_user.admin
    @reports = Report.where(:server => @server)
  end

  private
  def report_params
    params.require(:report).permit(:reason)
  end
end
