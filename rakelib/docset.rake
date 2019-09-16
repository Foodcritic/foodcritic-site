require "rake/clean"
require "yaml"
require "pathname"

require_relative "../lib/foodcritic/site/docset_generator"

output_root = Pathname.new("docset/build")
CLEAN.include(output_root.to_s)
CLOBBER.include("build/dash/Foodcritic.tgz")

desc "Build the Dash Docset"
task :docset => ["build/dash/Foodcritic.tgz"]

docset_root = output_root + "Foodcritic.docset"

docs = (docset_root + "Contents/Resources/Documents").to_s
directory docs

task :assets => docs

{
  "docset/source/Info.plist" => docset_root + "Contents/Info.plist",
  "source/images/foodcritic.png" => docset_root + "icon.png",
  "source/images/" => docset_root + "Contents/Resources/Documents/images/",
  "source/stylesheets/" => docset_root + "Contents/Resources/Documents/stylesheets/",
}.each do |src, dest|
  file dest do
    cp_r src, dest
  end
  task :assets => dest.to_s
end

task :index_html => :assets do
  index_file = docset_root + "Contents/Resources/Documents/index.html"
  content = File.read("build/index.html").gsub("/stylesheets", "stylesheets")
  File.open(index_file, "w") { |f| f.write(content) }
end

task :create_index => docset_root + "Contents/Resources" do
  index_path = docset_root + "Contents/Resources/docSet.dsidx"
  rules = YAML.load_file("rules.yml")["rules"]
  api_methods = YAML.load_file("api_methods.yml")["api_methods"]
  FoodCritic::Site::DocsetGenerator.new.create_index(
    index_path, rules, api_methods)
end

task :create_tarball => [:create_index, :index_html] do
  Dir.chdir(output_root) do
    sh 'tar --exclude=".DS_Store" -cvzf Foodcritic.tgz Foodcritic.docset'
  end
end

file "build/dash/Foodcritic.tgz" => [:create_tarball] do
  cp output_root + "Foodcritic.tgz", "build/dash/Foodcritic.tgz"
end
