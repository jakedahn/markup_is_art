require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'

module MarkupIsArt
  class App < Sinatra::Default 
    
    set :sessions, true
    
    get '/style.css' do
      content_type 'text/css'
      sass :style
    end

    get '/' do      
      haml :index
    end
    
  end
end