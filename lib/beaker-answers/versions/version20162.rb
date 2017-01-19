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

      return generate_hiera_config
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
      pe_conf = BeakerAnswers::PeConf.new(@hosts, '1.0')
      pe_conf.configuration_hash
    end

    def hiera_db_config
      ns = "puppet_enterprise"
      defaults_to_set = []

      # Set database users only if we are upgrading from < 2016.2.0; necessary
      # because BeakerAnswers sets database user to non-default values in
      # earlier versions.
      if @options[:include_legacy_database_defaults]
        # Database names/users. Required for password and cert-based auth
        defaults_to_set += [
          "#{ns}::puppetdb_database_user",
          "#{ns}::classifier_database_user",
          "#{ns}::activity_database_user",
          "#{ns}::rbac_database_user",
          "#{ns}::orchestrator_database_user",
        ]
      end

      get_defaults_or_answers(defaults_to_set)
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
      answer_hiera
    end
  end
end
