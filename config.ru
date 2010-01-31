set :environment, :production
set :port, 50000
disable :run, :reload
 
require 'app'
 
run Voter::App