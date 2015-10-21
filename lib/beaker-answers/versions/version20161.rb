require 'beaker-answers/versions/version20153'

module BeakerAnswers
  # This class provides answer file information for PE version 2016.1
  #
  # @api private
  class Version20161 < Version20153
    # The version of PE that this set of answers is appropriate for
    def self.pe_version_matcher
      /\A2016\.1/
    end
  end
end
