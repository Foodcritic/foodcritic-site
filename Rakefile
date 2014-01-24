require 'rake/testtask'

def build_docset 
		# Cleanup
		system("rm -rf docset/_output/Foodcritic.docset/Contents/Resources/docSet.dsidx")
		system("rm -rf docset/_output/Foodcritic.docset/Contents/Resources/Documents/*")
		# Create Fresh
		system("mkdir -p docset/_output/Foodcritic.docset/Contents/Resources/Documents")
		# Copy over static files
		system("cp -rf docset/_input/Info.plist docset/_output/Foodcritic.docset/Contents/Info.plist")
		system("cp -rf source/images/foodcritic.png docset/_output/Foodcritic.docset/icon.png")
		# Copy over the build files
		system("cp -rf source/images/ docset/_output/Foodcritic.docset/Contents/Resources/Documents/images/")
		system("cp -rf source/stylesheets/ docset/_output/Foodcritic.docset/Contents/Resources/Documents/stylesheets/")
		system("sed -e 's/\\/stylesheets/stylesheets/g' build/index.html > docset/_output/Foodcritic.docset/Contents/Resources/Documents/index.html")
		# Build database
		system("ruby docset/src/generate.rb | sqlite3 docset/_output/Foodcritic.docset/Contents/Resources/docSet.dsidx")
		# Tarball for distribution
		Dir.chdir('docset/_output'){
			system("tar --exclude='.DS_Store' -cvzf Foodcritic.tgz Foodcritic.docset")
		}
		# Copy tarball to source
		system("cp -rf docset/_output/Foodcritic.tgz source/dash/Foodcritic.tgz")
end

task :default => [:test]

Rake::TestTask.new do |t|
    t.pattern = 'spec/*_spec.rb'
end

desc "Build the Dash Docset"
task :docset do
	build_docset
end

desc "Deploy the website"
task :deploy => [:test] do
	build_docset
  sh "middleman build"

end