require 'beaker-answers/versions/version20162'

module BeakerAnswers
  # This class provides answer file information for PE version 2016.3
  #
  # @api private
  class Version20163 < Version20162
    # The version of PE that this set of answers is appropriate for
    def self.pe_version_matcher
      /\A2016\.3/
    end

    def generate_answers
      the_answers = super

      # use_application_services is deprecated
      the_answers.delete('puppet_enterprise::use_application_services')

      the_answers
    end
  end
end
