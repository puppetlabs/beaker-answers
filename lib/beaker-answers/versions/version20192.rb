require 'beaker-answers/versions/version20191'

module BeakerAnswers
  # This class provides answer file information for PE version 2019.1
  #
  # @api private
  class Version20192 < Version20191
    # The version of PE that this set of answers is appropriate for
    def self.pe_version_matcher
      /\A2019\.2/
    end
  end
end
