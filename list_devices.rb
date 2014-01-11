#!/usr/bin/env ruby

# Scrape devices list out of a RangeMax Next Wireless-N Modem Router (DGN2200) web interface
require 'net/http'
require 'uri'
require 'terminal-table'
require 'nokogiri'

uri = URI.parse("http://10.0.0.138:80/devices.cgi")
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Post.new(uri.request_uri)
password = File.read(File.expand_path("~/rt.pw")).chomp
username = "Admin"
request.basic_auth(username, password)
request.set_form_data(refresh: "Refresh")
response = http.request(request)
doc = Nokogiri::XML(response.body)
rows = doc.css(".ttext")
devices = (rows.length / 3).times.map do |i|
  arr = 3.times.map do |j|
    rows[(i * 3) + j].children.first.text
  end
  {
    ip: arr[0],
    name: arr[1],
    mac: arr[2]
  }
end

name = ARGV[0]
if name
  devices.each do |device|
    puts device[:ip] if device[:name].casecmp(name) == 0
  end
else
  puts Terminal::Table.new rows: devices.map(&:values)
end
