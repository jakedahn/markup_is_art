require 'sinatra'
require 'active_record'
require 'sass'

load 'config/config.rb'
load 'models.rb'
load 'methods.rb'

module Voter
  class App < Sinatra::Default
    set :sessions, true
    set :run, false

    before do
      @flash = get_flash.nil? ? "" : "<span class='flash'>#{get_flash}</span>"  
    end

    get '/style.css' do
      content_type 'text/css'
      sass :style
    end

    get '/' do
      @title = "Voter | Upload your images for critique"
      @images = Image.all
      haml :index
    end
    
    get '/top' do
      haml :images
    end

    get '/images' do
      haml :images
    end

    get '/upload' do
      @title = "Voter | Upload an image."
      haml :upload
    end
    
    post '/upload' do
      unless params[:file] &&
             (tmpfile = params[:file][:tempfile]) &&
             (name = params[:file][:filename])
        @error = "No file selected"
        return haml(:upload)
      end
      STDERR.puts "Uploading file, original name #{name.inspect}"
      while blk = tmpfile.read(65536)
        # here you would write it to its final location
        STDERR.puts blk.inspect
      end
      "Upload complete"
    end
    
    
  end
end