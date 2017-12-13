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

    def generate_hiera_config
      hiera_hash = super

      if hiera_hash.include?('meep_schema_version') && @options[:answers]
        # The meep 2.0 schema format includes structured data, which you could
        # conceivably overwrite in your :answers and not want flattened.
        # We're removing the flattened keys added in the Version20162 and
        # reading them here rather than breaking compatibilty with existing
        # Version20162 behavior. We're sorry.
        hiera_hash.reject! do |k, _v|
          flatten_keys_to_joined_string(@options[:answers]).include?(k)
        end
        stringified_answers = @options[:answers].each_with_object({}) do |entry, hash|
          key = entry[0]
          value = entry[1]
          hash[key.to_s] = value
        end
        hiera_hash.merge!(stringified_answers)
      end
      hiera_hash
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
