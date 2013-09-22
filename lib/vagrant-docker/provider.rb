require 'log4r'
require 'vagrant'

require_relative 'driver/meta'

module VagrantPlugins
  module Docker
    class Provider < Vagrant.plugin('2', :provider)
      attr_reader :driver

      def initialize(machine)
        @logger  = Log4r::Logger.new("vagrant::provider::docker")
        @machine = machine

        machine_id_changed
      end

      def action(name)
        # Attempt to get the action method from the Action class if it
        # exists, otherwise return nil to show that we don't support the
        # given action.
        action_method = "action_#{name}"
        return Action.send(action_method) if Action.respond_to?(action_method)
        nil
      end

      def machine_id_changed
        id = @machine.id

        begin
          @logger.debug("Instantiating driver for machine ID: #{@machine.id.inspect}")
          @driver = Driver::Meta.new(id, @machine)
          @driver.verify!
        rescue Driver::Meta::ContainerNotFound
          # The virtual machine does not exist so we have a stale id
          # Clear the id and reload
          @logger.debug("VM not found! Clearing saved machine ID and reloading.")
          id = nil
          retry
        end
      end

      def state
        # Run a custom action (read_state) to retrieve the virtual machine state
        # The state is stored in :machine_state_id key in the environment
        @logger.debug @machine
        env = @machine.action("read_state")

        state_id = env[:machine_state_id]

        # Get short and long translations for this state_id
        short = I18n.t("vagrant_docker.states.short_#{state_id}")
        long  = I18n.t("vagrant_docker.states.long_#{state_id}")

        # Return the MachineState object
        Vagrant::MachineState.new(state_id, short, long)
      end
    end
  end
end
