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

      case @format
      when :bash
        return generate_bash_answers(the_answers)
      when :hiera
        return generate_hiera_config
      else
        raise NotImplementedError, "Don't know how to generate answers for #{@format}"
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

    def generate_hiera_config
      # The hiera answer file format will get all answers, regardless of role
      # it is being installed on
      hiera_hash = {}

      # Add the correct host values for this beaker configuration
      hiera_hash.merge!(hiera_host_config)

      hiera_hash.merge!(get_defaults_or_answers([
        "console_admin_password",
        "puppet_enterprise::use_application_services",
      ]))

      # Set database connection details and credentials
      hiera_hash.merge!(hiera_db_config)

      # Override with any values provided in the :answers key hash
      if @options[:answers]
        if @options[:answers].keys.any? { |k| k.to_s.start_with?('q_') }
          raise(TypeError, "q_ answers are not supported when using the hiera answers format")
        else
          hiera_hash.merge!(flatten_keys_to_joined_string(@options[:answers]))
        end
      end

      return hiera_hash
    end

    def hiera_host_config
      config = {}
      ns = "puppet_enterprise"

      master = only_host_with_role(@hosts, 'master')
      puppetdb = only_host_with_role(@hosts, 'database')
      console = only_host_with_role(@hosts, 'dashboard')

      config["#{ns}::certificate_authority_host"] = answer_for(@options, "#{ns}::certificate_authority_host", master.name)
      config["#{ns}::puppet_master_host"] = answer_for(@options, "#{ns}::puppet_master_host", master.name)
      config["#{ns}::console_host"] = answer_for(@options, "#{ns}::console_host", console.name)
      config["#{ns}::puppetdb_host"] = answer_for(@options, "#{ns}::puppetdb_host", puppetdb.name)
      config["#{ns}::database_host"] = answer_for(@options, "#{ns}::database_host", puppetdb.name)
      config["#{ns}::pcp_broker_host"] = answer_for(@options, "#{ns}::pcp_broker_host", master.name)
      config["#{ns}::mcollective_middleware_hosts"] = [answer_for(@options, "#{ns}::mcollective_middleware_hosts", master.name)]

      return config
    end

    def hiera_db_config
      ns = "puppet_enterprise"
      defaults_to_set = []

      # Database names/users. Required for password and cert-based auth
      defaults_to_set += [
        "#{ns}::puppetdb_database_name",
        "#{ns}::puppetdb_database_user",
        "#{ns}::classifier_database_name",
        "#{ns}::classifier_database_user",
        "#{ns}::activity_database_name",
        "#{ns}::activity_database_user",
        "#{ns}::rbac_database_name",
        "#{ns}::rbac_database_user",
        "#{ns}::orchestrator_database_name",
        "#{ns}::orchestrator_database_user",
      ]

      # We only need to specify passwords if we are using password auth
      unless @options[:database_cert_auth]
        defaults_to_set += [
          "#{ns}::puppetdb_database_password",
          "#{ns}::classifier_database_password",
          "#{ns}::activity_database_password",
          "#{ns}::rbac_database_password",
          "#{ns}::orchestrator_database_password",
        ]
      end

      return get_defaults_or_answers(defaults_to_set)
    end

    # This converts a data hash provided by answers, and returns a Puppet
    # Enterprise compatible hiera config file ready for use.
    #
    # @return [String] a string of parseable hocon
    # @example Generating an answer file for a series of hosts
    #   hosts.each do |host|
    #     answers = Beaker::Answers.new("2.0", hosts, "master")
    #     create_remote_file host, "/mypath/answer", answers.answer_hiera
    #  end
    def answer_hiera
      # Render pretty JSON, because it is a subset of HOCON
      json = JSON.pretty_generate(answers)
      hocon = Hocon::Parser::ConfigDocumentFactory.parse_string(json)
      hocon.render
    end

    def installer_configuration_string(host)
      case @format
        when :bash then answer_string(host)
        when :hiera then answer_hiera
        else
          raise NotImplementedError, "Don't know how to generate for configuration #{@format}"
      end
    end
  end
end
