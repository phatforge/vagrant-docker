require 'pathname'

require 'vagrant/action/builder'

module VagrantPlugins
  module Docker
    module Action
      # Include the built-in modules so we can use them as top-level things.
      include Vagrant::Action::Builtin

      # This method is called to bring the machine up from nothing
      def self.action_up
        Vagrant::Action::Builder.new.tap do |b|
          # Disable this until we can support external boxes.
          b.use HandleBoxUrl
          b.use ConfigValidate
          b.use ConnectDockerd
          b.use Call, IsCreated do |env1, b1|
            # if the vm instance exists
            if env1[:result]
              b1.use Call, IsStopped do |env2, b2|
                if env2[:result]
                  b2.use StartContainer
                #else
                  #b2.use MessageContainerAlreadyCreated
                end
              end
            ## if vm is NOT created perform these steps to create it
            else
              b1.use CreateContainer
            end
          end
        end
      end

      def self.action_read_state
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use ConnectDockerd
          b.use ReadState
        end
      end

      action_root = Pathname.new(File.expand_path("../action", __FILE__))
      autoload :ConnectDockerd,  action_root.join("connect_dockerd")
      autoload :CreateContainer, action_root.join("create_container")
      autoload :IsCreated,       action_root.join("is_created")
      autoload :IsStopped,       action_root.join("is_stopped")
      autoload :ReadState,       action_root.join("read_state")
      autoload :StartContainer,  action_root.join("start_container")
    end
  end
end
