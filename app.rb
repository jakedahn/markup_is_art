require 'sinatra'
require 'active_record'
require 'sass'
require 'aws/s3'
require 'rcomposite'
require 'restclient'

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
      @images = Image.all()
      
      haml :index
    end
    
    get '/top' do
      @images = Image.all(:limit => 5).sort { |a,b| b.vote_total <=> a.vote_total }
      haml :index
    end

    get '/images' do
      haml :images
    end

    get '/upload' do
      @title = "Voter | Upload an image."
      haml :upload
    end
        
    post '/mustachify' do
      @image = mustachify(params[:file])
      
      RestClient.post 'http://looce.com:4568/upload', :file => File.new(@image)
    end
    
    post '/upload' do
      
      @bucket = "voter"
      @file = params[:file]
      @filename = @file[:filename]
      @filetype = File.extname(@filename)
      @stored_name = Digest::SHA1.hexdigest(@file[:filename]+Time.now.to_s+@filename)+@filetype
      
      
      
      puts  Image.new(
        :title => params[:title],
        :description => params[:description],
        :vote_total => 0,
        :url => "http://s3.amazonaws.com/#{@bucket}/#{@stored_name}"
      ).save
      AWS::S3::S3Object.store(@stored_name, File.new(mustachify(params[:file])), @bucket, :access => :public_read)
      
      redirect "/"
    end    
    
  end
end