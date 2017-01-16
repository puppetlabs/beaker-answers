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
  end
end
