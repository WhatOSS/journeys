require 'sprockets'

namespace :assets do
  namespace :precompile do
    desc "Compile journeys JS client"
    task :journeys_client => :environment do 
      Rake::SprocketsTask.new(:journeys_client) do |t|
        t.environment = Rails.application.assets
        t.output      = "./client_lib"
        debugger
        t.assets      = %w( journeys_client.js )
      end

      Rake::Task["journeys_client"].execute
    end
  end
end
