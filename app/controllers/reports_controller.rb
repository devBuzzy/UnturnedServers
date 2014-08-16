class ReportsController < ApplicationController
	before_filter :authenticate_user!, :except => [:index, :show]

  def new
  	@server = Server.find(params[:server_id])
  	@report = @server.reports.new(:user => current_user)
  end

  def edit
    @server = Server.find(params[:server_id])
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
    @reports = server.reports
  end

  def index
    @reports = Report.all
  end

  private
  def report_params
    params.require(:report).permit(:reason)
  end
end
