Dir[File.expand_path("../tasks/**/*.rake")].each { |ext| load ext } #if defined?(Rake)
require "db/backuper/version"

module Db
  module Backuper
    # Your code goes here...
  end
end
