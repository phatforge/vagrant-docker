require 'log4r'

module VagrantPlugins
  module Docker
    module Action
      # This action connects to the docker daemon using  api gem.
      # We save this connection in env[:dockerd_connection]
      class ConnectDockerd
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_docker::action::connect_dockerd")
        end

        def call(env)
          @driver = env[:machine].provider.driver
          @driver.verify!
          env[:dockerd_connection] = @driver

          @app.call(env)
        end
      end
    end
  end
end
