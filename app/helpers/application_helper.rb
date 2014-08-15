module ApplicationHelper
	def get_time(server, subtract)
		return server.votes.all.where(created_at: ((Time.now - subtract.day).beginning_of_day..(Time.now - subtract.day).end_of_day)).to_a.size
	end
end
