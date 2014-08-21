module ApplicationHelper
  def get_time(server, subtract, type)
    case type
    when "votes"
      return server.votes.all.where(created_at: ((Time.now - subtract.day).beginning_of_day..(Time.now - subtract.day).end_of_day)).to_a.size
    when "favorites"
      return server.favorites.all.where(created_at: ((Time.now - subtract.day).beginning_of_day..(Time.now - subtract.day).end_of_day)).to_a.size
    end
 end

  def can_manage(server)
    current_user and (current_user.admin? or server.user == current_user)
  end

  def set_active(controller)
    return params[:controller] == controller ? "active" : ""
  end
end
