require 'beaker-answers/versions/version20173'

module BeakerAnswers
  # This class provides answer file information for PE version 2018.1
  #
  # @api private
  class Version20181 < Version20173
    # The version of PE that this set of answers is appropriate for
    def self.pe_version_matcher
      /\A2018\.1/
    end
  end
end
