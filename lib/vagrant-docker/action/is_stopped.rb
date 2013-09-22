require 'log4r'

module VagrantPlugins
  module Docker
    module Action
      # This action reads the state of the container via the api gem.
      class IsStopped
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_docker::action::is_stopped")
        end

        def call(env)
          env[:result] = env[:machine].state.id == :stopped
          @app.call(env)
        end
      end
    end
  end
end

