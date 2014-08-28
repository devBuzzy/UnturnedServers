module ApplicationHelper
  def get_time(server, subtract, type)
    case type
    when "votes"
      return server.votes.all.where(created_at: ((Time.now - subtract.day).beginning_of_day..(Time.now - subtract.day).end_of_day)).to_a.size
    when "favorites"
      return server.favorites.all.where(created_at: ((Time.now - subtract.day).beginning_of_day..(Time.now - subtract.day).end_of_day)).to_a.size
    end
  end

  def require_admin
    current_user and current_user.admin?
  end

  def can_manage(server)
    current_user and (current_user.admin? or server.user == current_user)
  end

  def set_active(controller)
    return params[:controller] == controller ? "active" : ""
  end

  def tag_cloud(classes)
    tags = Tag.all.to_a.map{ |r| [r["text"], r["count"]] }
    max = tags.sort_by(&:count).last
    tags = tags.shuffle
    tags.each do |tag|
      index = tag[1].to_f / max[1] * (classes.size - 1)
      yield(tag, classes[index.round])
    end
  end
end
