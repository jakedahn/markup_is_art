require 'rubygems'
require 'sinatra'

namespace 'db' do
  desc "Create db schema"
  task :create do        
    require 'active_record'
    require 'config/config.rb'
    require 'models'

    ActiveRecord::Migration.create_table :images do |t|
      t.string  :title
      t.text    :description
      t.string  :url
      
      t.timestamps
    end

  end
end
