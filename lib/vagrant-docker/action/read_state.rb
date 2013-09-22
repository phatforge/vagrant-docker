require 'log4r'

module VagrantPlugins
  module Docker
    module Action
      # This action reads the state of the container via the api gem.
      class ReadState
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_docker::action::read_state")
        end

        def call(env)
          env[:machine_state_id] = read_state(env[:dockerd_connection], env[:machine])

          @app.call(env)
        end

        def read_state(dockerd, machine)
          return :not_created if machine.id.nil?

          #valid states are
          #:not_created
          #:running
          #:stopped

          container = dockerd.container(machine.id)
          if container.nil?
            # The machine can't be found
            @logger.warn("Machine not found or terminated, assuming it got destroyed.")
            machine.id = nil
            return :not_created
          end
          state = container.json["State"]["Running"] ? :running : :stopped
          @logger.debug "Container is in state #{state}"
          return state
        end
      end
    end
  end
end
