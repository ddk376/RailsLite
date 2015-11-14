require 'webrick'

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html

server = WEBrick::HTTPServer.new(:Port => 3000)

server.mount_proc("/") do |request, response|
  response.content_type = "text/text"
  response.body = request.meta_vars["PATH_INFO"].to_s
  response.each do |res|
    response.body += res
  end
  response.body += request.meta_vars.to_s
  response.body += request.cookies.first.to_s
  response.body += request.body.to_s
end

trap('INT') do 
  server.shutdown
end

server.start
