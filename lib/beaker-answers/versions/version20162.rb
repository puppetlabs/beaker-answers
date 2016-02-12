require 'beaker-answers/versions/version20153'

module BeakerAnswers
  # This class provides answer file information for PE version 2016.1
  #
  # @api private
  class Version20162 < Version20161
    # The version of PE that this set of answers is appropriate for
    def self.pe_version_matcher
      /\A2016\.2/
    end
  end
end
