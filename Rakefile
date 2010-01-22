require 'rubygems'
require 'sinatra'

namespace 'db' do
  desc "Create db schema"
  task :create do        
    require 'active_record'
    require 'config/config.rb'
    require 'models'
  
    ActiveRecord::Migration.create_table :votes do |t|
      t.string  :value
      t.integer :image_id
      
      t.timestamps
    end
    ActiveRecord::Migration.create_table :images do |t|
      t.string  :title
      t.text    :description
      t.integer :vote_total
      t.string  :url
      
      t.timestamps
    end

  end
end
# 
# (1..10).each do |i|
#   Image.create(
#     :title        => "Test #{i}",
#     :description  => "This image is pretty baddass, I dont think ill ever see something as cool.",
#     :url          => "http://s3.amazonaws.com/voter/testimg.png"
#   )
# end

# (1..10).each do |i|
#   Vote.create(
#     :value    => 1,
#     :image_id => 1
#   )
# end
