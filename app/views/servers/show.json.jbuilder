json.id @server.id.to_s
json.created_at @server.created_at
json.updated_at @server.updated_at
json.name @server.title
json.tags @server.tags
json.location @server.location
json.connection do
	json.ip @server.ip
	json.port @server.port
end
json.slots @server.slots
json.version @server.version
json.social do
	json.twitter @server.twitter
	json.website @server.website
	json.youtube @server.youtube
	json.reddit @server.reddit
	json.steam @server.steam
	json.facebook @server.facebook
end
json.description @server.info
json.author do
	json.username @server.user.username
end