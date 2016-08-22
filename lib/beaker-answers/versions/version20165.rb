require 'beaker-answers/versions/version20164'

module BeakerAnswers
  # This class provides answer file information for PE version 2016.4
  #
  # @api private
  class Version20165 < Version20164
    # The version of PE that this set of answers is appropriate for
    def self.pe_version_matcher
      /\A2016\.5/
    end
  end
end
