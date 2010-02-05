require 'sinatra'
require 'active_record'
require 'haml'
require 'sass'
require 'aws/s3'
require 'RMagick'

load 'config/config.rb'
load 'models.rb'
load 'methods.rb'

module Voter
  class App < Sinatra::Default 
    
    set :sessions, true
    
    before do
      @flash = get_flash.nil? ? "" : "<span class='flash'>#{get_flash}</span>"
    end

    get '/style.css' do
      content_type 'text/css'
      sass :style
    end

    get '/' do
      @title = "Mustache.me"

      @image_count = Image.all.size
      @offset = params[:page].to_i*10
      @page_num = params[:page].to_i

      @images = Image.all(:limit => 10, :order => 'created_at DESC', :offset => @offset)
      
      haml :index
    end

    get '/page/:page' do
      @title = "Mustache.me"

      @image_count = Image.all.size
      @offset = params[:page].to_i*10
      @page_num = params[:page].to_i

      @images = Image.all(:limit => 10, :order => 'created_at DESC', :offset => @offset)
      if params[:page].to_i == 0
        redirect "/"
      end
      haml :index
    end
      
    get '/about' do
      @title = "Mustache.me | About Team Jake Dahn"
      
      haml :about
    end
        
    get '/view/:id' do
      @image = Image.find_by_id(params[:id])
      puts @image
      if @image.nil?
        redirect '/random'
      else
        @title = "Mustache.me | #{@image.title}"
        @bodyClass = "single"
        haml :view
      end
    end
    
    get '/random' do
      random_post = Image.find(:first, :order => "RAND()")
      redirect "/view/#{random_post.id}"
    end
    get '/upload' do
      @title = "Mustache.me | Grow a 'stache."
      @bodyClass = "upload"
      haml :upload
    end
    
    post '/up' do
      setup_image(params[:file], params)
    end
    
    post '/upload' do
      aws = AWS::S3::S3Object.store(
        params[:filename], 
        File.new(mustachify(params[:local_file], params[:position][:x], params[:position][:y])),
        "images.mustache.me",
        :access => :public_read
      )

      stache = Image.new(
        :title => params[:title],
        :description => params[:description],
        :url => "http://images.mustache.me/#{params[:filename]}"
      )
      
      stache.save
      
      return "http://mustache.me/view/#{stache.id}"
    end    
    
  end
end