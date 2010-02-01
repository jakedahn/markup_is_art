require 'rubygems'
require 'sinatra'

set :environment, :production
set :port, 50000
disable :run, :reload

log = File.new("../shared/log/sinatraError.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)

require 'app'
 
run Voter::App