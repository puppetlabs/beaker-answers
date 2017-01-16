require 'beaker-answers/versions/version20171'

module BeakerAnswers
  # This class provides answer file information for PE version 2017.2
  #
  # @api private
  class Version20172 < Version20171
    # The version of PE that this set of answers is appropriate for
    def self.pe_version_matcher
      /\A2017\.2/
    end

    # This is used to generate the profile host parameters, but now passes the
    # options[:meep_schema_version] to determine which form of pe.conf is to be
    # generated.
    def hiera_host_config
      pe_conf = BeakerAnswers::PeConf.new(@hosts, @options[:meep_schema_version])
      pe_conf.configuration_hash
    end
  end
end
