require 'log4r'

module VagrantPlugins
  module Docker
    module Action
      # This action reads the state of the container via the api gem.
      class CreateContainer
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_docker::action::create_container")
        end

        def call(env)
          env[:machine].id = create_container(env[:dockerd_connection], env[:machine])

          @app.call(env)
        end

        def create_container(dockerd, machine)
          container = dockerd.create_container(machine.provider_config.image)
          container.start

          @logger.error container.id
          container.id
        end
      end
    end
  end
end
