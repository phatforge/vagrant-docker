require 'forwardable'

require_relative 'tcp_connection'
require_relative 'unix_connection'

module VagrantPlugins
  module Docker
    module Driver
      class Meta

        class ContainerNotFound < StandardError; end

        extend Forwardable

        # the container_id of our docker vm
        attr_reader :container_id

        # Initialize an instance of the driver to manage docker
        #
        # container_id
        def initialize(container_id=nil, machine)
          @logger = Log4r::Logger.new("vagrant::provider::docker::driver::meta")
          @container_id = container_id

          # TOOO: Pick tcp driver or unix socket driver as needed:w
          @driver = Driver::TcpConnection.new(machine.provider_config)
        end

        def_delegators :@driver, :verify!, :container, :create_container


      end
    end
  end
end
