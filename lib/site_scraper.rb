require 'nokogiri'
require 'open-uri'
require 'pry'

class EventsData

  event_names = []
  event_locations = []
  event_links =[]

  date_array = Time.now.to_s.split.first.split('-')
  month=date_array[1]
  year=date_array[0]
  day=date_array[2]
  url = "http://www.residentadvisor.net/events.aspx?ai=8&v=day&mn=#{month}&yr=#{year}&dy=#{day}"
  html = open(url)
  events_page = Nokogiri::HTML(html)


  # events = events_page.css("div.bbox h1 a")[1].tex
  events_page.css("div.bbox h1 span").collect do |location|
    event_locations << location.text  
  end
  event_locations = event_locations.join.gsub("at ", ",").split(",")
  event_locations.delete_at(0)

  events_page.css("div.bbox h1 a").collect do |event|
    event_names << event.text unless event_locations.include? event.text
  end

  events_page.css("div.bbox h1 a").collect do |link|
    event_links << link.attribute("href").value if link.attribute("href").value.include? "event" 
  end
 
  puts "\nWhat's up party people!!!! Chillin hard over here. Ready to get turnt?"
  puts "Here's what's happening tonight:"
  puts ""
  i=0
  while i < event_locations.count
    puts "#{i+1}. #{event_names[i]} <3 @#{event_locations[i]}"
    i+=1
  end
  input = ""
  while input != "exit"

  puts "\nTo get more info (via the internets) type in the list number and hit return... or type 'exit' to gtfo."

  input = gets.strip
  break if input=="exit"
  input = input.to_i

  system "open http://www.residentadvisor.net#{event_links[input-1]}"
  end
end



