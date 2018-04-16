require 'beaker-answers/versions/version20181'

module BeakerAnswers
  # This class provides answer file information for PE version 2018.2
  #
  # @api private
  class Version20182 < Version20181
    # The version of PE that this set of answers is appropriate for
    def self.pe_version_matcher
      /\A2018\.2/
    end

  end
end
