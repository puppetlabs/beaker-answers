module BeakerAnswers
  # This class provides methods for generating PE answer file
  # information.
  class Answers
    # This is a temporary default for deciding which configuration file format
    # to fall back to in 2016.2.0.  Once we have cutover to MEEP, it should be
    # removed.
    DEFAULT_FORMAT = :bash
    DEFAULT_ANSWERS = StringifyHash.new.merge(:q_install => 'y',
                                              :q_puppet_enterpriseconsole_auth_user_email => 'admin@example.com',
                                              :q_puppet_enterpriseconsole_auth_password => '~!@#$%^*-/ aZ',
                                              :q_puppet_enterpriseconsole_smtp_port => 25,
                                              :q_puppet_enterpriseconsole_smtp_use_tls => 'n',
                                              :q_verify_packages => 'y',
                                              :q_puppetdb_database_password => '~!@#$%^*-/ aZ',
                                              :q_puppetmaster_enterpriseconsole_port => 443,
                                              :q_puppet_enterpriseconsole_auth_database_name => 'console_auth',
                                              :q_puppet_enterpriseconsole_auth_database_user => 'mYu7hu3r',
                                              :q_puppet_enterpriseconsole_database_name => 'console',
                                              :q_puppet_enterpriseconsole_database_user => 'mYc0nS03u3r',
                                              :q_database_root_password => '=ZYdjiP3jCwV5eo9s1MBd',
                                              :q_database_root_user => 'pe-postgres',
                                              :q_database_export_dir => '/tmp',
                                              :q_orchestrator_database_name => 'pe-orchestrator',
                                              :q_orchestrator_database_user => 'Orc3Str8R',
                                              :q_orchestrator_database_password => '~!@#$%^*-/ aZ',
                                              :q_puppetdb_database_name => 'pe-puppetdb',
                                              :q_puppetdb_database_user => 'mYpdBu3r',
                                              :q_database_port => 5432,
                                              :q_puppetdb_port => 8081,
                                              :q_classifier_database_name => 'pe-classifier',
                                              :q_classifier_database_user => 'DFGhjlkj',
                                              :q_classifier_database_password => '~!@#$%^*-/ aZ',
                                              :q_activity_database_user => 'adsfglkj',
                                              :q_activity_database_name => 'pe-activity',
                                              :q_activity_database_password => '~!@#$%^*-/ aZ',
                                              :q_rbac_database_user => 'RbhNBklm',
                                              :q_rbac_database_name => 'pe-rbac',
                                              :q_rbac_database_password => '~!@#$%^*-/ aZ',
                                              :q_install_update_server => 'y',
                                              :q_exit_for_nc_migrate => 'n',
                                              :q_enable_future_parser => 'n',
                                              :q_pe_check_for_updates => 'n')

    DEFAULT_HIERA_ANSWERS = StringifyHash.new.merge(flatten_keys_to_joined_string('console_admin_password' => DEFAULT_ANSWERS[:q_puppet_enterpriseconsole_auth_password],
                                                                                  'puppet_enterprise' => {
                                                                                    'puppetdb_database_name' => DEFAULT_ANSWERS[:q_puppetdb_database_name],
                                                                                    'puppetdb_database_user'         => DEFAULT_ANSWERS[:q_puppetdb_database_user],
                                                                                    'puppetdb_database_password'     => DEFAULT_ANSWERS[:q_puppetdb_database_password],
                                                                                    'classifier_database_name'       => DEFAULT_ANSWERS[:q_classifier_database_name],
                                                                                    'classifier_database_user'       => DEFAULT_ANSWERS[:q_classifier_database_user],
                                                                                    'classifier_database_password'   => DEFAULT_ANSWERS[:q_classifier_database_password],
                                                                                    'activity_database_name'         => DEFAULT_ANSWERS[:q_activity_database_name],
                                                                                    'activity_database_user'         => DEFAULT_ANSWERS[:q_activity_database_user],
                                                                                    'activity_database_password'     => DEFAULT_ANSWERS[:q_activity_database_password],
                                                                                    'rbac_database_name'             => DEFAULT_ANSWERS[:q_rbac_database_name],
                                                                                    'rbac_database_user'             => DEFAULT_ANSWERS[:q_rbac_database_user],
                                                                                    'rbac_database_password'         => DEFAULT_ANSWERS[:q_rbac_database_password],
                                                                                    'orchestrator_database_name'     => DEFAULT_ANSWERS[:q_orchestrator_database_name],
                                                                                    'orchestrator_database_user'     => DEFAULT_ANSWERS[:q_orchestrator_database_user],
                                                                                    'orchestrator_database_password' => DEFAULT_ANSWERS[:q_orchestrator_database_password],
                                                                                    'use_application_services'       => true,
                                                                                  }))

    # Determine the list of supported PE versions, return as an array
    # @return [Array<String>] An array of the supported versions
    def self.supported_versions
      BeakerAnswers.constants.select { |c| BeakerAnswers.const_get(c).is_a?(Class) && BeakerAnswers.const_get(c).respond_to?(:pe_version_matcher) }
    end

    # Determine the list of supported upgrade PE versions, return as an array
    # @return [Array<String>] An array of the supported versions
    def self.supported_upgrade_versions
      BeakerAnswers.constants.select { |c| BeakerAnswers.const_get(c).is_a?(Class) && BeakerAnswers.const_get(c).respond_to?(:upgrade_version_matcher) }
    end

    # When given a Puppet Enterprise version, a list of hosts and other
    # qualifying data this method will return the appropriate object that can be used
    # to generate answer file data.
    #
    # @param [String] version Puppet Enterprise version to generate answer data for
    # @param [Array<Beaker::Host>] hosts An array of host objects.
    # @param [Hash] options options for answer files
    # @option options [Symbol] :type Should be one of :upgrade or :install.
    # @return [Hash] A hash (keyed from hosts) containing hashes of answer file
    #   data.
    def self.create(version, hosts, options)
      # if :upgrade is detected, then we return the simpler upgrade answers
      if options[:type] == :upgrade
        supported_upgrade_versions.each do |upgrade_version_class|
          if BeakerAnswers.const_get(upgrade_version_class).send(:upgrade_version_matcher) =~ version
            return BeakerAnswers.const_get(upgrade_version_class).send(:new, version, hosts, options)
          end
        end
        warn 'Only upgrades to version 3.8.x generate specific upgrade answers. Defaulting to full answers.'
      end

      # finds all potential version classes
      # discovers new version classes as they are added, no more crazy case statement
      version_classes = supported_versions
      version_classes.each do |vc|
        # check to see if the version matches the regex for this class of answers
        if BeakerAnswers.const_get(vc).send(:pe_version_matcher) =~ version
          return BeakerAnswers.const_get(vc).send(:new, version, hosts, options)
        end
      end
      raise NotImplementedError, "Don't know how to generate answers for #{version}"
    end

    # The answer value for a provided question.  Use the user answer when
    # available, otherwise return the default.
    #
    # @param [Hash] options options for answer file
    # @option options [Symbol] :answers Contains a hash of user provided
    #   question name and answer value pairs.
    # @param [String] default Should there be no user value for the provided
    #   question name return this default
    # @return [String] The answer value
    def answer_for(options, q, default = nil)
      case @format
      when :bash
        answer = DEFAULT_ANSWERS[q]
        answers = options[:answers]
      when :hiera
        answer = DEFAULT_HIERA_ANSWERS[q]
        answers = flatten_keys_to_joined_string(options[:answers]) if options[:answers]
      else
        raise NotImplementedError, "Don't know how to determine answers for #{@format}"
      end

      # check to see if there is a value for this in the provided options
      answer = answers[q] if answers && answers[q]
      # use the default if we don't have anything
      answer ||= default
      answer
    end

    def get_defaults_or_answers(defaults_to_set)
      config = {}

      defaults_to_set.each do |key|
        config[key] = answer_for(@options, key)
      end

      config
    end

    # When given a Puppet Enterprise version, a list of hosts and other
    # qualifying data this method will return a hash (keyed from the hosts)
    # of default Puppet Enterprise answer file data hashes.
    #
    # @param [String] version Puppet Enterprise version to generate answer data for
    # @param [Array<Beaker::Host>] hosts An array of host objects.
    # @param [Hash] options options for answer files
    # @option options [Symbol] :type Should be one of :upgrade or :install.
    # @option options [Symbol] :format Should be one of :bash or :hiera. This
    #   is a temporary setting which only has an impact on version201620 answers.
    #   Setting :bash will result in the "classic" PE answer file being generated
    #   Setting :hiera will generate the new PE hiera config file format
    # @return [Hash] A hash (keyed from hosts) containing hashes of answer file
    #   data.
    def initialize(version, hosts, options)
      @version = version
      @hosts = hosts
      @options = options
      @format = (options[:format] || DEFAULT_FORMAT).to_sym
    end

    # Generate the answers hash based upon version, host and option information
    def generate_answers
      raise 'This should be handled by subclasses!'
    end

    # Access the answers hash for this version, host and option information.  If the answers
    # have not yet been calculated, generate them.
    # @return [Hash] A hash of answers keyed by host.name
    def answers
      @answers ||= generate_answers
    end

    # This converts a data hash provided by answers, and returns a Puppet
    # Enterprise compatible answer file ready for use.
    #
    # @param [Beaker::Host] host Host object in question to generate the answer
    #   file for.
    # @return [String] a string of answers
    # @example Generating an answer file for a series of hosts
    #   hosts.each do |host|
    #     answers = Beaker::Answers.new("2.0", hosts, "master")
    #     create_remote_file host, "/mypath/answer", answers.answer_string(host, answers)
    #  end
    def answer_string(host)
      answers[host.name].map { |k, v| "#{k}=#{v}" }.join("\n")
    end

    def answer_hiera
      raise(NotImplementedError, "Hiera configuration is not available in this version of PE (#{self.class})")
    end

    def installer_configuration_string(host)
      answer_string(host)
    end

    # Find a single host with the role provided.  Raise an error if more than one host is found to have the
    # provided role.
    #
    # @param [Array<Host>] hosts The hosts to examine
    # @param [String] role The host returned will have this role in its role list
    # @return [Host] The single host with the desired role in its roles list
    # @raise [ArgumentError] Raised if more than one host has the given role defined, or if no host has the
    #                       role defined.
    def only_host_with_role(hosts, role)
      found_hosts =  hosts.select { |host| role.nil? || host['roles'].include?(role.to_s) }
      if found_hosts.empty? || (found_hosts.length > 1)
        raise ArgumentError, "There should be one host with #{role} defined, found #{found_hosts.length} matching hosts (#{found_hosts})"
      end
      found_hosts.first
    end
  end

  # pull in all the available answer versions
  require_rel 'versions'
end
