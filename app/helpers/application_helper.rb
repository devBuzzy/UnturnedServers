module ApplicationHelper
	def get_time(server, subtract)
		return server.votes.all.where(created_at: ((Time.now - subtract.day).beginning_of_day..(Time.now - subtract.day).end_of_day)).to_a.size
	end

  def can_manage(server)
    current_user and (current_user.admin? or server.user == current_user)
  end

  def set_active(controller)
    return params[:controller] == controller ? "active" : ""
  end
end
