dbconfig = YAML.load(File.read('config/database.yml'))
ActiveRecord::Base.establish_connection dbconfig["development"]
# ActiveRecord::Base.establish_connection dbconfig["production"]

# Replace this section with your s3 info
AWS::S3::Base.establish_connection!(
  :access_key_id     => '15JQ4C5YE4T94J0TC582',
  :secret_access_key => 'CwBZjX4xWW/CZL3pigonVMXJ/boE+lPneggijjb9'
)

