require 'beaker-answers/versions/version20165'

module BeakerAnswers
  # This class provides answer file information for PE version 2017.1
  #
  # @api private
  class Version20171 < Version20165
    # The version of PE that this set of answers is appropriate for
    def self.pe_version_matcher
      /\A2017\.1/
    end
  end
end
