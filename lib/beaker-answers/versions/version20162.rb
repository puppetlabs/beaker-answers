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
      master = only_host_with_role(@hosts, 'master')
      puppetdb = only_host_with_role(@hosts, 'database')
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

        unless @options[:database_cert_auth]
          hiera_hash["puppet_enterprise::puppetdb_database_password"] = answer_for(@options, "puppet_enterprise::puppetdb_database_password")
          hiera_hash["puppet_enterprise::classifier_database_password"] = answer_for(@options, "puppet_enterprise::classifier_database_password")
          hiera_hash["puppet_enterprise::activity_database_password"] = answer_for(@options, "puppet_enterprise::activity_database_password")
          hiera_hash["puppet_enterprise::rbac_database_password"] = answer_for(@options, "puppet_enterprise::rbac_database_password")
          hiera_hash["puppet_enterprise::orchestrator_database_password"] = answer_for(@options, "puppet_enterprise::orchestrator_database_password")
        end

        # Override with any values provided in the :answers key hash
        if @options[:answers]
          hiera_hash.merge!(flatten_keys_to_joined_string(@options[:answers]))
        end

        return hiera_hash
      else
        raise "Don't know how to generate answers for format #{@format}"
      end
    end
  end
end
