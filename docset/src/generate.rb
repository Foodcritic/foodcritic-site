require 'yaml'

puts "CREATE TABLE IF NOT EXISTS searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);"
puts "CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);"

#
# Parse the rules and create SQL
# 
rules = YAML.load_file(File.expand_path(File.join(File.dirname(__FILE__), "../../rules.yml")))

rules['rules'].each do |rule|
	puts "INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES ('#{rule['code']}', 'Error', 'index.html##{rule['code']}');"
end

#
# Process the api_methods and create SQL
#
api_methods = YAML.load_file(File.expand_path(File.join(File.dirname(__FILE__), "../../api_methods.yml")))

api_methods['api_methods'].each do |method|
	puts "INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES ('#{method['name']}', 'Method', 'index.html##{method['name']}');"
end
