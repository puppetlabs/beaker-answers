require 'beaker-answers/versions/version20172'

module BeakerAnswers
  # This class provides answer file information for PE version 2017.3
  #
  # @api private
  class Version20173 < Version20172
    # The version of PE that this set of answers is appropriate for
    def self.pe_version_matcher
      /\A2017\.3/
    end
  end
end
