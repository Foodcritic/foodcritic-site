module FoodCritic
  module Site
    class SqliteNotInstalledError < StandardError; end
    class DocsetGenerator

      def create_index(path, rules, api_methods)
        check_sqlite_installed!
        create_database(path)
        insert_rules(path, rules)
        insert_api_methods(path, api_methods)
      end

      private

      def check_sqlite_installed!
        raise SqliteNotInstalledError unless sqlite_installed?
      end

      def sqlite_installed?
        %x{sqlite3 -version}
        $?.success?
      end

      def create_database(path)
        sqlite(path, %q{
          CREATE TABLE IF NOT EXISTS searchIndex(
            id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);
          CREATE UNIQUE INDEX IF NOT EXISTS anchor ON searchIndex (name, type, path);
        })
      end

      def insert_rules(path, rules)
        insert_rows(path, 'Error', rules.map{|m| m['code']})
      end

      def insert_api_methods(path, api_methods)
        insert_rows(path, 'Method', api_methods.map{|m| m['name']})
      end

      def insert_rows(path, type, names)
        inserts = names.map do |name|
          "INSERT OR IGNORE INTO searchIndex(name, type, path)
             VALUES ('#{name}', '#{type}', 'index.html##{name}');"
        end
        sqlite(path, inserts.join("\n"))
      end

      def sqlite(index_path, stmt)
        result = %x{sqlite3 -bail -batch #{index_path} << "EOF"
#{stmt}
EOF
}
        raise "Problem running sqlite statement: #{stmt}" unless $?.success?
        result
      end

    end
  end
end
