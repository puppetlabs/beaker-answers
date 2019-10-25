require 'beaker-answers/versions/version20172'

module BeakerAnswers
  # This class provides answer file information for PE version 2017.3 AND BEYOND
  #
  # @api private
  class Version20173to9999 < Version20172
    # The version of PE that this set of answers is appropriate for
    def self.pe_version_matcher
      /\A(2017\.3|2018\.[1-2]|2019\.[0-9]|20[2-9][1-9]\.[0-9]|[2-9][0-9]{3}\.[0-9])/
    end
  end
end
