require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require "nokogiri"
require 'open-uri'
require_relative 'cookbook'
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end
cookbook = Cookbook.new('recipes.csv')
get '/' do
  @recipes = cookbook.all
  erb :index
end
get '/new' do
  erb :new
end
post '/recipes' do
  cookbook.add_recipe(params)
  redirect to('/')
end
get '/destroy/:index' do
  cookbook.remove_recipe(params[:index].to_i)
  redirect to('/')
end
get '/import' do
  erb :import
end

post '/select_recipe' do
  @result = parse_html(params)
  erb :select_recipe
end

post '/add_recipe' do
  index = params[:index].to_i
  url = params[:url]
  details = fetch_details(url, index)
  cookbook.add_recipe(details)
  redirect to('/')
end

get '/update/:index' do
  cookbook.cooked_recipe(params[:index].to_i)
  redirect to('/')
end

get '/about' do
  erb :about
end
get '/team/:username' do
  puts params[:username]
  "The username is #{params[:username]}"
end

def parse_html(params)
  keyword = params[:key_word]
  keyword += "&dif=#{params[:difficulty]}" unless params[:difficulty].to_i.zero?
  lookup_html(keyword)
end

def lookup_html(keyword)
  @url = "http://www.letscookfrench.com/recipes/find-recipe.aspx?aqt=#{params[:key_word]}"
  doc = Nokogiri::HTML(open(@url), nil, 'utf-8')
  @web_search = []
  doc.search("//div[@class = 'm_item recette_classique']//div[@class = 'm_titre_resultat']/a").each do |el|
    @web_search << el.attributes['title'].value
  end
  @web_search
end

def fetch_details(url, index)
  doc = Nokogiri::HTML(open(url), nil, 'utf-8')
  description = doc.xpath("(//div[@class = 'm_item recette_classique']//div[@class = 'm_texte_resultat'])[#{index}]").text.strip
  prep_time = doc.xpath("(//div[@class = 'm_item recette_classique']//div[@class = 'm_detail_time'])[#{index}]").text.strip
  name = doc.xpath("(//div[@class = 'm_item recette_classique']//div[@class = 'm_titre_resultat'])[#{index}]").text.strip
  { name: name, description: description, prep_time: prep_time }
end
