activate :syntax
activate :livereload
set :hostname, 'www.foodcritic.io'
activate :s3_sync do |s3_sync|
  s3_sync.bucket = hostname
  s3_sync.region = 'eu-west-1'
  s3_sync.after_build = true
  s3_sync.aws_access_key_id = ENV['AWS_ACCESS_KEY_ID']
  s3_sync.aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
end
set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

set :docset_version, '1.0.0'
page 'dash/Foodcritic.xml', :layout => false
