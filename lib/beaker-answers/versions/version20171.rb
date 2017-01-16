require 'beaker-answers/versions/version20165'

module BeakerAnswers
  # This class provides answer file information for PE version 2017.1
  #
  # @api private
  class Version20171 < Version20165
    # The version of PE that this set of answers is appropriate for
    def self.pe_version_matcher
      /\A2017\.1/
    end

    # This used to generate the profile host parameters, but now generates a MEEP
    # 2.0 node_roles hash mapping roles -> node certs based on the same host and
    # role information.
    def hiera_host_config
      pe_conf = BeakerAnswers::PeConf.new(@hosts, @options[:meep_schema_version])
      pe_conf.configuration_hash
    end
  end
end
