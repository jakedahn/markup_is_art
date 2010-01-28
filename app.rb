require 'sinatra'
require 'active_record'
require 'haml'
require 'sass'
require 'aws/s3'
require 'restclient'
require 'RMagick'

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
      @title = "Mustache.me"
      @images = Image.all(:order => "id DESC")
      
      haml :index
    end

    get '/about' do
      @title = "Mustache.me | About Team Jake Dahn"
      
      haml :about
    end
        
    get '/view/:id' do
      @image = Image.find(params[:id])
      @title = "Mustache.me | #{@image.title}"
      @bodyClass = "single"
      haml :view
    end
        
    post '/mustachify' do
      @image = mustachify(params[:file])
      
      RestClient.post 'http://looce.com:4568/upload', :file => File.new(@image)
    end
    
    get '/upload' do
      @title = "Mustache.me | Grow a 'stache."
      @bodyClass = "upload"
      haml :upload
    end
    
    post '/upload' do
      
      if params[:file].nil?
        set_flash "Try actually filling in the form this time..."
        redirect "/upload"
      else
        @bucket = "images.mustache.me"
        @file = params[:file]
        @filename = @file[:filename]
        @filetype = File.extname(@filename)
        @stored_name = Digest::SHA1.hexdigest(@file[:filename]+Time.now.to_s+@filename)+@filetype
      
        Image.new(
          :title => params[:title],
          :description => params[:description],
          :url => "http://#{@bucket}/#{@stored_name}"
        ).save
        
        AWS::S3::S3Object.store(@stored_name, File.new("tmp/"+@stored_name), @bucket, :access => :public_read)
      
        redirect "/"
      end
    end    
    
  end
end