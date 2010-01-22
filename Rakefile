require 'rubygems'
require 'sinatra'

namespace 'db' do
  desc "Create db schema"
  task :create do        
    require 'active_record'
    require 'config/config.rb'
  
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