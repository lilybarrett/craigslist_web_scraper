require 'sinatra'
require 'HTTParty'
require 'Nokogiri'
require 'JSON'
require 'pry'
require 'csv'

set :views, File.join(File.dirname(__FILE__), "app/views")

before do
  page = HTTParty.get('https://newyork.craigslist.org/search/pet?s=0')
  parse_page = Nokogiri::HTML(page)
  @pets_array = []

  parse_page.css('.content').css('.row').css('.hdrlnk').map do |a|
    post_name = a.text
    @pets_array.push(post_name)
  end

  CSV.open('pets.csv', 'w') do |csv|
    csv << @pets_array
  end
end

get '/' do
  erb :index
end
