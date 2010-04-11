require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'

module MarkupIsArt
  class App < Sinatra::Default 
    
    set :sessions, true

    get '/' do      
      haml :index
    end
    
  end
end