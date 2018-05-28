require 'Nokogiri'
require 'HTTParty'
require 'Pry'
require 'csv'
require 'mail'

# read past count from csv file
rows = CSV.read("past_disc.csv")
last_count = rows[0][0]
TOUR_PAGE_URL = "https://proshop.innovadiscs.com/limited/tour-series.html"

time = Time.now.strftime "%H:%M"
disc_page = HTTParty.get(TOUR_PAGE_URL)
doc = Nokogiri::HTML(disc_page)
new_discs = doc.css('div.regular > a > div.new-label')

if new_discs.count > last_count.to_i
  puts "#{time}: New listing found! Previous count was #{last_count}. New count is #{new_discs.count}"
  body = ""
  new_discs.each do |new_disc|
    new_disc_url = new_disc.parent.attributes['href'].value 
    body << new_disc_url + "\n"
    puts new_disc_url
  end
  Mail.deliver do
    from 'mmcquinn77@gmail.com'
    to 'mmcquinn77@gmail.com'
    subject 'New tour series disc posted!'
    body body
  end
else
  puts "#{time}: No new listing found."
end
last_count = new_discs.count
# save our last_count in csv
CSV.open("past_disc.csv", "wb") do |csv|
  csv << [last_count]
end 
