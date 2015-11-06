require 'beaker-answers/versions/version40'

module BeakerAnswers
  # This class provides answer file information for PE version 2015.3
  #
  # @api private
  class Version20153 < Version40
    # The version of PE that this set of answers is appropriate for
    def self.pe_version_matcher
      /\A2015\.3/
    end

    def generate_answers
      the_answers = super

      return the_answers if @options[:masterless]

      master = only_host_with_role(@hosts, 'master')
      database = only_host_with_role(@hosts, 'database')
      console = only_host_with_role(@hosts, 'dashboard')

      orchestrator_db = {
        :q_orchestrator_database_name     => answer_for(@options, :q_orchestrator_database_name),
        :q_orchestrator_database_user     => answer_for(@options, :q_orchestrator_database_user),
        :q_orchestrator_database_password => "'#{answer_for(@options, :q_orchestrator_database_password)}'",
      }

      the_answers[master.name].merge!(orchestrator_db)
      the_answers[database.name].merge!(orchestrator_db)

      the_answers[master.name][:q_database_host] = answer_for(@options, :q_database_host, database.to_s)
      the_answers[master.name][:q_database_port] = answer_for(@options, :q_database_port)
      the_answers[master.name][:q_use_application_services] = answer_for(@options, :q_use_application_services, 'y')
      the_answers[console.name][:q_use_application_services] = answer_for(@options, :q_use_application_services, 'y')

      the_answers
    end
  end
end
