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

    def generate_answers
      the_answers = super

      # New flag added in 2018.1.1
      # Disable management of Puppet agent so that when Beaker stops the agent,
      # it stays stopped. This will prevent flip-flops of configuration between 
      # PE configure runs and agent runs.
      # Needed for test: acceptance/tests/faces/enterprise/configure/idempotent.rb
      the_answers['pe_infrastructure::agent::puppet_service_managed'] = false

      the_answers
    end

  end
end
