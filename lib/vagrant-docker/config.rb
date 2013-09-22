require 'vagrant'

module VagrantPlugins
  module Docker
    class Config < Vagrant.plugin('2', :config)
      # Docker image to run
      #
      # @return [String]
      attr_accessor :image

      # Docker daemon connection type
      #
      # @return [Symbol]
      attr_accessor :dockerd_type

      # Docker daemon host address
      #
      # @return [Symbol]
      attr_accessor :dockerd_host

      # Docker daemon port
      #
      # @return [Integer]
      attr_accessor :dockerd_port

      # Docker daemon Endpoint to connect to
      #
      # @return [String]
      attr_accessor :dockerd_path

      def initialize
        @image         = UNSET_VALUE
        # Select unix:// or tcp:// dockerd type
        @dockerd_type  = UNSET_VALUE
        # if tcp: specify host address
        @dockerd_host  = UNSET_VALUE
        # if tcp: specify port
        @dockerd_port  = UNSET_VALUE
        # if unix: specify socket path
        @dockerd_path  = UNSET_VALUE
      end

      def finalize!
        @image         = :base if @image == UNSET_VALUE
        @dockerd_type  = :unix if @dockerd_type == UNSET_VALUE

        @dockerd_host  = "127.0.0.1" if @dockerd_host == UNSET_VALUE
        @dockerd_port  = 4243 if @dockerd_port == UNSET_VALUE

        @dockerd_path  = "/var/run/docker.sock" if @dockerd_path == UNSET_VALUE
      end

      def validate(machine)
        errors = _detected_errors

        errors << I18n.t("vagrant_docker.config.image_fallback") if @image.nil?
        errors << I18n.t("vagrant_docker.config.invalid_transport") if ![:unix, :tcp].include?(@dockerd_type)
        errors << I18n.t("vagrant_docker.config.dockerd_not_running.socket_path_missing") if ![:unix, :tcp].include?(@dockerd_type.to_sym)
        # TODO: Extra validations
        # validate host resolves or is ip & port are valid and can be connected to (api ping)
        # validate if dockerd service is actually running (use process checks) if host is localhost or using socket.

        { "Docker Provider" => errors }

      end
    end
  end
end
