# lib/tasks/db.rake
module DbBackuper
  def self.resolve_file_path

  end

  def self.dump
    password = YAML.load_file(Rails.root.join("config/database.yml").to_s)[Rails.env.to_s]['password']
    cmd = nil
    folder = "#{Rails.root}/db/backups/#{Rails.env.to_s}/"
    file_name = "#{DateTime.now.strftime("%Y%m%d%H%M%S")}.dump"
    existing_files = Dir["#{folder}*"].sort
    limit = 10
    if (diff = limit - existing_files.count) <= 0
      diff = diff * -1 if diff < 0
      existing_files[0, diff + 1].each {|f| FileUtils.rm(f)  }
    end

    file_path = "#{folder}#{file_name}"

    with_config do |app, host, db, user|
      cmd = "PGPASSWORD=\"#{password}\" pg_dump --host #{host} --username #{user} --verbose --clean --no-owner --no-acl --format=c #{db} > #{file_path}"
    end
    puts cmd
    exec cmd

  end

  def self.restore
    cmd = nil
    password = YAML.load_file(Rails.root.join("config/database.yml").to_s)[Rails.env.to_s]['password']

    with_config do |app, host, db, user|
      folder = "#{Rails.root}/db/backups/#{Rails.env.to_s}/"
      file_path = Dir["#{folder}*"].sort.last
      version = ENV["VERSION"]
      file_path = "#{folder}#{version}.dump" if version.present?

      if file_path.present? && File.exist?(file_path)
        cmd = "PGPASSWORD=\"#{password}\" pg_restore --verbose --host #{host} --username #{user} --clean --no-owner --no-acl --dbname #{db} #{file_path} "

        Rake::Task["db:drop"].invoke
        Rake::Task["db:create"].invoke

        puts cmd
        exec cmd
      else
        puts "File '#{file_path}' does not exist"
      end
    end


  end
end


namespace :db do

  desc "Dumps the database to db/APP_NAME.dump"
  task :dump => :environment do
    DbBackuper.dump
  end

  desc "Restores the database dump at db/APP_NAME.dump."
  task :restore => :environment do
    DbBackuper.restore

  end

  private

  def with_config
    yield Rails.application.class.parent_name.underscore,
        ActiveRecord::Base.connection_config[:host],
        ActiveRecord::Base.connection_config[:database],
        ActiveRecord::Base.connection_config[:username]
  end

end
