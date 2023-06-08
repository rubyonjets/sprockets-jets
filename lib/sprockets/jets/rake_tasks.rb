require 'sprockets'
require 'rake/sprocketstask'

module Sprockets::Jets
  class RakeTasks < Rake::SprocketsTask
    def define
      namespace :assets do
        %w( environment precompile clean clobber ).each do |task|
          Rake::Task[task].clear if Rake::Task.task_defined?(task)
        end

        # Override this task change the loaded dependencies
        desc "Load asset compile environment"
        task :environment do
          # Load full Jets environment by default
          Rake::Task[:environment].invoke
        end

        desc "Compile all the assets named in config.assets.precompile"
        task precompile: :environment do
          with_logger do
            manifest.compile(assets)
          end
        end

        desc "Remove old compiled assets"
        task :clean, [:keep] => :environment do |t, args|
          with_logger do
            manifest.clean(Integer(args.keep || self.keep))
          end
        end

        desc "Remove compiled assets"
        task clobber: :environment do
          with_logger do
            manifest.clobber
          end
        end
      end
    end

    class << self
      def load_tasks
        new do |task|
          task.environment = Env.build
          task.output      = "public/assets"
          task.assets = [ "manifest.js", "application.js" ]
          task.assets += Jets.config.assets.precompile

          # task.assets      = ["manifest.js"] # dont have to deal with backwards compatibility since this is a new gem
          # See: https://github.com/rails/sprockets/blob/main/UPGRADING.md#manifestjs
          # In Sprockets 4, the manifest file using the manifest.js is encouraged
          # And using individual files like ["application.js", "application.css"] is discouraged.
        end
      end
    end
  end
end
