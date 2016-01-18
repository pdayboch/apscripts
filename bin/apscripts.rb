require 'sinatra'
require './lib/apscripts.rb'

set :port, 80
#set :bind, '10.92.105.192'
set :static, true
set :public_folder, "static"
set :views, "views"


get '/' do
  erb :welcome_form
end

post '/fetch' do
  rawIps = params[:ips]
  setup = Setup.new(rawIps)
  apinfo = setup.aps
	erb :welcome_form, :locals => {'aps' => apinfo}
end
