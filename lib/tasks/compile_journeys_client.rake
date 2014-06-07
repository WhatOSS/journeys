require 'sprockets'
require 'fileutils'

OUTPUT_DIR = "./client_lib/"
OUTPUT_FILENAME = "journeys_client.js"

namespace :assets do
  namespace :precompile do
    desc "Compile journeys JS client"
    task :journeys_client => :environment do 
      `RAILS_ENV=production bundle exec rake assets:precompile:internal_journey_client`

      files = Dir.glob("#{OUTPUT_DIR}*")

      file_matcher = /journeys_client.*.js$/
      files.each do |file_name|
        if file_matcher.match(file_name)
          target = "#{OUTPUT_DIR}#{OUTPUT_FILENAME}"

          FileUtils.move( file_name, target)

          puts "Wrote client to #{target}"
        else
          File.delete(file_name)
        end
      end
    end

    desc "Internal BIG HAX compiler because sprockets is unintelligable"
    task :internal_journey_client => :environment do
      Rake::SprocketsTask.new(:journeys_client) do |t|
        t.environment = Rails.application.assets

        t.output      = "./client_lib"
        t.assets      = %w( journeys_client.js )
      end

      Rake::Task["journeys_client"].execute
    end
  end
end
