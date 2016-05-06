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

      if @type == :bash
        return the_answers
      elsif @type == :hiera
        flattened_answers = {}
        the_answers.each_pair do |host, answers|
          flattened_answers.merge!(answers)
        end

        # The hiera answer file format will get all answers, regardless of role it is being installed on
        hiera_hash = {}
        hiera_hash["console_admin_password"] = "#{answer_for(@options, :q_puppet_enterpriseconsole_auth_password)}"
        hiera_hash["puppet_enterprise::certificate_authority_host"] = flattened_answers[:q_puppetmaster_certname]
        hiera_hash["puppet_enterprise::puppet_master_host"] = flattened_answers[:q_puppetmaster_certname]
        hiera_hash["puppet_enterprise::console_host"] = flattened_answers[:q_puppetmaster_enterpriseconsole_hostname]
        hiera_hash["puppet_enterprise::puppetdb_host"] = flattened_answers[:q_puppetdb_hostname]
        hiera_hash["puppet_enterprise::database_host"] = flattened_answers[:q_database_host]
        hiera_hash["puppet_enterprise::pcp_broker_host"] = flattened_answers[:q_puppetmaster_certname]
        hiera_hash["puppet_enterprise::mcollective_middleware_hosts"] = [flattened_answers[:q_puppetmaster_certname]]
        hiera_hash["puppet_enterprise::puppetdb_database_password"] = flattened_answers[:q_puppetdb_database_password]
        hiera_hash["puppet_enterprise::classifier_database_password"] = flattened_answers[:q_classifier_database_password]
        hiera_hash["puppet_enterprise::activity_database_password"] = flattened_answers[:q_activity_database_password]
        hiera_hash["puppet_enterprise::rbac_database_password"] = flattened_answers[:q_rbac_database_password]
        hiera_hash["puppet_enterprise::orchestrator_database_password"] = flattened_answers[:q_orchestrator_database_password]

        return hiera_hash
      else
        raise "Don't know how to generate answers for format #{@format}"
      end
    end
  end
end
