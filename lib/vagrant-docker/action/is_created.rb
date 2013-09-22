require 'log4r'

module VagrantPlugins
  module Docker
    module Action
      # This action connects to the docker daemon using  api gem.
      # We save this connection in env[:dockerd_connection]
      class IsCreated
        def initialize(app, env)
          @logger = Log4r::Logger.new("vagrant_docker::action::is_created")
          @app    = app
        end

        def call(env)
          env[:result] = env[:machine].state.id != :not_created
          @app.call(env)
        end
      end
    end
  end
end
