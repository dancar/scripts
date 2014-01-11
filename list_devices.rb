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

# The structure of the input is something like:
# Device1 IP
# Device1 Name
# Device1 MAC
# Device2 IP
# Device2 Name
# Device2 MAC
# ...
# So we do some Ruby magic:
devices = (rows.length / 3).times.map do |row|
  Hash[*[:ip, :name, :mac].each_with_index.map { |attr, place|
    [attr, rows[(row * 3) + place].children.first.text]
  }.flatten]
end

name = ARGV[0]
if name
  devices.each do |device|
    puts device[:ip] if device[:name].casecmp(name) == 0
  end
else
  puts Terminal::Table.new rows: devices.map(&:values)
end
