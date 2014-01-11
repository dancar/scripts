#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'terminal-table'
require 'nokogiri'

uri = URI.parse("http://10.0.0.138:80/devices.cgi")
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Post.new(uri.request_uri)
password = File.read("~/rt.pw")
username = "Admin"
request.basic_auth(username, password)
request.set_form_data(refresh: "Refresh")
response = http.request(request)
doc = Nokogiri::XML(response.body)
rows = doc.css(".ttext")
terminal_rows = (rows.length / 3).times.map do |i|
  3.times.map do |j|
    rows[(i * 3) + j].children.first.text
  end
end
puts Terminal::Table.new rows: terminal_rows
