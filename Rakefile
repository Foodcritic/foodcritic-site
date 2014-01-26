require 'rake/clean'
require 'rake/testtask'

task :default => [:test]

CLOBBER.include('build')

Rake::TestTask.new do |t|
    t.pattern = 'spec/*_spec.rb'
end

desc 'Deploy the website'
task :deploy => [:test] do
  sh 'middleman build'
  Rake::Task['docset'].invoke
  sh 'middleman s3_sync'
end
