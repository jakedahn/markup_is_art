require 'sinatra'
require 'active_record'
require 'sass'
require 'aws/s3'

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
      @images = Image.all(:limit => 5)
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
    
    post '/vote/:id/up' do
      Vote.create(
        :value    => 1,
        :image_id => params[:id]
      )
      update_votes_total(params[:id])
    end

    post '/vote/:id/down' do
      Vote.create(
        :value    => -1,
        :image_id => params[:id]
      )
      update_votes_total(params[:id])
    end

    post '/upload' do
      @bucket = "voter"
      @file = params[:file]
      @filename = @file[:filename]
      @filetype = File.extname(@filename)
      @stored_name = Digest::SHA1.hexdigest(@file[:filename]+Time.now.to_s+@filename)+@filetype
      
      Image.create(
        :title => params[:title],
        :description => params[:title],
        :vote_total => 0,
        :url => "http://s3.amazonaws.com/#{@bucket}/#{@stored_name}"
      )
      AWS::S3::S3Object.store(@stored_name, open(@file[:tempfile]), @bucket)

    end    
    
  end
end