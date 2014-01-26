require_relative 'spec_helper'
require_relative '../lib/foodcritic/site/docset_generator'

module FoodCritic
  module Site

    describe DocsetGenerator do

      describe '#create_index' do
        describe 'sqlite installed' do
          it 'creates the docset search index' do
            if file_installed?
              database{ |d| assert run_command("file #{d}") =~ /SQLite/ }
            end
          end
          it 'contains all of the rules' do
            database do |d|
              index_rule_count = sqlite(d, "SELECT count(*) FROM searchIndex
                                            WHERE type = 'Error';").rstrip.to_i
              index_rule_count.must_equal rules.size
            end
          end
          it 'contains all of the api methods' do
            database do |d|
              index_api_count = sqlite(d, "SELECT count(*) FROM searchIndex
                                           WHERE type = 'Method';").rstrip.to_i
              index_api_count.must_equal api_methods.size
            end
          end
        end
        describe 'sqlite not installed' do
          it 'raises' do
            assert_raises(SqliteNotInstalledError) do
              index_path = Dir.tmpdir + '/will/not/be/written'
              DocsetGenerator.new.tap do |dg|
                dg.instance_eval do
                  def sqlite_installed?
                    false
                  end
                end
              end.create_index(index_path, rules, api_methods)
            end
          end
        end
      end

      let(:rules) do
        rule_yml = Pathname.new(__FILE__).dirname.dirname + 'rules.yml'
        YAML::load_file(rule_yml)['rules']
      end

      let(:api_methods) do
        rule_yml = Pathname.new(__FILE__).dirname.dirname + 'api_methods.yml'
        YAML::load_file(rule_yml)['api_methods']
      end

      def database
        Dir.mktmpdir do |dir|
          index_path = Pathname.new(dir) + 'docSet.dsidx'
          DocsetGenerator.new.create_index(index_path, rules, api_methods)
          yield index_path
        end
      end

      def file_installed?
        %x{file --help} && $?.success?
      end

      def sqlite(index_path, stmt)
        result = run_command(%Q{sqlite3 -bail -batch #{index_path} << "EOF"
#{stmt}
EOF
})
        raise "Problem running sqlite statement: #{stmt}" unless $?.success?
        result
      end

      def run_command(cmd)
        result = %x{#{cmd}}
        raise "Problem running cmd: #{cmd}" unless $?.success?
        result
      end

    end
  end
end
