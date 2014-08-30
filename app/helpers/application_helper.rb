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
      if tag[1] == 0 and max[1] == 0
        index = 0
      else
        index = tag[1].to_f / max[1] * (classes.size - 1)
      end
      yield(tag, classes[index])
    end
  end

  def get_countries
    countries = Server.distinct(:country)
    data = Array.new
    countries.each do |country|
      count = Server.where(:country => country).size
      country_hash = Hash.new
      country_hash['value'] = count
      country_hash['label'] = country
      country_hash['color'] = random_color
      country_hash['highlight'] = random_color
      data << country_hash
    end
    data
  end

  def get_versions
    versions = Server.distinct(:version)
    data = Array.new
    versions.each do |version|
      count = Server.where(:version => version).size
      version_hash = Hash.new
      version_hash['value'] = count
      version_hash['label'] = version
      version_hash['color'] = random_color
      version_hash['highlight'] = random_color
      data << version_hash
    end
    data
  end

  def random_color(hash = true)
    color = "%06x" % (rand * 0xffffff)
    if hash
      return "#" + color
    else
      return color
    end
  end
end
