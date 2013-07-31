require 'rake/testtask'

task :default => [:test]

Rake::TestTask.new do |t|
    t.pattern = 'spec/*_spec.rb'
end

desc "Deploy the website"
task :deploy => [:test] do
  sh "middleman build"
end
