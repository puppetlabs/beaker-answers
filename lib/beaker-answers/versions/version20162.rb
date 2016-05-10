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

      if @type == :bash
        return generate_bash_answers(the_answers)
      elsif @type == :hiera
        return generate_hiera_answers
      else
        raise "Don't know how to generate answers for format #{@type}"
      end
    end

    def generate_bash_answers(answers)
      console = only_host_with_role(@hosts, 'dashboard')

      # To allow SSL cert based auth in the new installer while maintaining the legacy
      # bash script, the console node now needs to know about the orchestrator database user
      # and name if they are specified to be non default
      orchestrator_db = {
        :q_orchestrator_database_name     => answer_for(@options, :q_orchestrator_database_name),
        :q_orchestrator_database_user     => answer_for(@options, :q_orchestrator_database_user),
      }

      answers[console.name].merge!(orchestrator_db)

      return answers
    end

    def generate_hiera_answers
      master = only_host_with_role(@hosts, 'master')
      puppetdb = only_host_with_role(@hosts, 'database')
      console = only_host_with_role(@hosts, 'dashboard')

      # The hiera answer file format will get all answers, regardless of role it is being installed on
      hiera_hash = {}
      hiera_hash["console_admin_password"] = answer_for(@options, "console_admin_password")
      hiera_hash["puppet_enterprise::use_application_services"] = answer_for(@options, "puppet_enterprise::use_application_services")
      hiera_hash["puppet_enterprise::certificate_authority_host"] = answer_for(@options, "puppet_enterprise::certificate_authority_host", master.name)
      hiera_hash["puppet_enterprise::puppet_master_host"] = answer_for(@options, "puppet_enterprise::puppet_master_host", master.name)
      hiera_hash["puppet_enterprise::console_host"] = answer_for(@options, "puppet_enterprise::console_host", console.name)
      hiera_hash["puppet_enterprise::puppetdb_host"] = answer_for(@options, "puppet_enterprise::puppetdb_host", puppetdb.name)
      hiera_hash["puppet_enterprise::database_host"] = answer_for(@options, "puppet_enterprise::database_host", puppetdb.name)
      hiera_hash["puppet_enterprise::pcp_broker_host"] = answer_for(@options, "puppet_enterprise::pcp_broker_host", master.name)
      hiera_hash["puppet_enterprise::mcollective_middleware_hosts"] = [answer_for(@options, "puppet_enterprise::mcollective_middleware_hosts", master.name)]

      # Database names/users. Required for password and cert-based auth
      hiera_hash["puppet_enterprise::puppetdb_database_name"] = answer_for(@options, "puppet_enterprise::puppetdb_database_name")
      hiera_hash["puppet_enterprise::puppetdb_database_user"] = answer_for(@options, "puppet_enterprise::puppetdb_database_user")
      hiera_hash["puppet_enterprise::classifier_database_name"] = answer_for(@options, "puppet_enterprise::classifier_database_name")
      hiera_hash["puppet_enterprise::classifier_database_user"] = answer_for(@options, "puppet_enterprise::classifier_database_user")
      hiera_hash["puppet_enterprise::activity_database_name"] = answer_for(@options, "puppet_enterprise::activity_database_name")
      hiera_hash["puppet_enterprise::activity_database_user"] = answer_for(@options, "puppet_enterprise::activity_database_user")
      hiera_hash["puppet_enterprise::rbac_database_name"] = answer_for(@options, "puppet_enterprise::rbac_database_name")
      hiera_hash["puppet_enterprise::rbac_database_user"] = answer_for(@options, "puppet_enterprise::rbac_database_user")
      hiera_hash["puppet_enterprise::orchestrator_database_name"] = answer_for(@options, "puppet_enterprise::orchestrator_database_name")
      hiera_hash["puppet_enterprise::orchestrator_database_user"] = answer_for(@options, "puppet_enterprise::orchestrator_database_user")

      # We only need to specify passwords if we are using password auth
      unless @options[:database_cert_auth]
        hiera_hash["puppet_enterprise::puppetdb_database_password"] = answer_for(@options, "puppet_enterprise::puppetdb_database_password")
        hiera_hash["puppet_enterprise::classifier_database_password"] = answer_for(@options, "puppet_enterprise::classifier_database_password")
        hiera_hash["puppet_enterprise::activity_database_password"] = answer_for(@options, "puppet_enterprise::activity_database_password")
        hiera_hash["puppet_enterprise::rbac_database_password"] = answer_for(@options, "puppet_enterprise::rbac_database_password")
        hiera_hash["puppet_enterprise::orchestrator_database_password"] = answer_for(@options, "puppet_enterprise::orchestrator_database_password")
      end

      # Override with any values provided in the :answers key hash
      if @options[:answers]
        if @options[:answers].keys.any? { |k| k.start_with?('q_') }
          raise "q_ answers are not supported when using the hiera answers type"
        else
          hiera_hash.merge!(flatten_keys_to_joined_string(@options[:answers]))
        end
      end

      return hiera_hash
    end
  end
end
