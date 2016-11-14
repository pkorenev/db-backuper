#Dir[File.expand_path("../tasks/**/*.rake", __FILE__)].each { |ext| require ext } #if defined?(Rake)

require "db/backuper/version"
require 'rails/railtie'

module Db
  module Backuper
    # Your code goes here...

    class Railtie < Rails::Railtie
      rake_tasks do
        Dir[File.expand_path("../tasks/**/*.rake", __FILE__)].each do |ext|
          load ext
        end

        load File.expand_path("../tasks/db.rake")
      end
    end
  end
end
