require 'rubygems'
require 'sinatra'

set :environment, :production
set :port, 55000
disable :run, :reload

log = File.new("sinatraError.log", "a")
STDOUT.reopen(log)

require 'app'
 
run Voter::App