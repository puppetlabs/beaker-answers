require 'beaker-answers/versions/version20190'

module BeakerAnswers
    # This class provides answer file information for PE version 2019.1
    #
    # @api private
    class Version20191 < Version20190
        # The version of PE that this set of answers is appropriate for
        def self.pe_version_matcher
            /\A2019\.1/
        end
    end
end
