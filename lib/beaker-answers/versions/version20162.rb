require 'beaker-answers/versions/version20161'

module BeakerAnswers
  # This class provides answer file information for PE version 2016.2
  #
  # @api private
  class Version20162 < Version20161
    # The version of PE that this set of answers is appropriate for
    def self.pe_version_matcher
      /\A2016\.2/
    end

    def generate_answers
      the_answers = super

      return the_answers if @options[:masterless]
      console = only_host_with_role(@hosts, 'dashboard')

      # To allow SSL cert based auth in the new installer while maintaining the legacy
      # bash script, the console node now needs to know about the orchestrator database user
      # and name if they are specified to be non default
      orchestrator_db = {
        :q_orchestrator_database_name     => answer_for(@options, :q_orchestrator_database_name),
        :q_orchestrator_database_user     => answer_for(@options, :q_orchestrator_database_user),
      }

      the_answers[console.name].merge!(orchestrator_db)

      the_answers
    end
  end
end
