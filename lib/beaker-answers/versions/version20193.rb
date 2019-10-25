require 'beaker-answers/versions/version20192'

module BeakerAnswers
  # This class provides answer file information for PE version 2019.3
  #
  # @api private
  class Version20193 < Version20192
    # The version of PE that this set of answers is appropriate for
    def self.pe_version_matcher
      /\A2019\.3/
    end
  end
end
