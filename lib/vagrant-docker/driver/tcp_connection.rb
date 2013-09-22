require 'docker'

require 'log4r'

module VagrantPlugins
  module Docker
    module Driver
      class TcpConnection
        def initialize(config)
          @logger = Log4r::Logger.new("vagrant_docker::driver::tcp_connection")
          @host    = config.dockerd_host
          @port    = config.dockerd_port

          @dockerd = ::Docker::Connection.new(docker_url, docker_opts)
        end

        def verify!
          ::Docker.validate_version!
          ::Docker.info
          ::Docker.version
        end

        # get json from id for single container
        #
        # container_id [Integer]
        # Response     [JSON]
        def container(container_id)
          if container_id
            container = ::Docker::Container.send(:new, @dockerd, container_id)
            # return the container json if we can retrieve it.
            begin
              # check the container exists by querying its json
              container.json
              container
            # if the container doesn't exist we get an Excon 404
            rescue Excon::Errors::NotFound
              nil
            end
          else
            nil
          end
        end

        def create_container(base_image=nil)
          options = {'Cmd' => ['/bin/bash'], 'Image' => base_image}
          container = ::Docker::Container.create(options, @dockerd)
          @logger.debug container.inspect
          container
        end

        private

        def docker_url
          @docker_url ||= "http://#{@host}"
        end
        def docker_opts
          @docker_opts ||= { port: @port }
        end
      end
    end
  end
end
