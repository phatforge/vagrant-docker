require 'log4r'

module VagrantPlugins
  module Docker
    module Action
      # This action reads the state of the container via the api gem.
      class StartContainer
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_docker::action::start_container")
        end

        def call(env)
          container = get_container(env[:dockerd_connection], env[:machine])
          @logger.debug(container.inspect)

          env[:ui].info(I18n.t('vagrant_docker.starting'))
          @logger.debug env[:machine].config.ssh.max_tries.inspect

          begin
            container.start
            @logger.debug env[:machine].communicate.ready?
          end

          @app.call(env)
        end

        def get_container(dockerd, machine)
          container ||= dockerd.container(machine.id)
        end
      end
    end
  end
end
