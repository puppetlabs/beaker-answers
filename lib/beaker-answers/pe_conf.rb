module BeakerAnswers
  # Used to generate a Hash of configuration appropriate for generating
  # the initial MEEP pe.conf for a given set of hosts and a particular
  # MEEP pe.conf schema version.
  class PeConf
    # The default pe.conf schema version.
    DEFAULT_VERSION = '1.0'.freeze

    # This lists various aliases for different PE components that might
    # be installed on a host.
    #
    # The first entry in the list is the canonical name for the
    # component from the PuppetX::Puppetlabs::Meep::Config.pe_components()
    # from the pe_infrastructure module.
    #
    # Secondary aliases are the various working names that have been used
    # with beaker in CI to establish that a host has that component
    # installed on it.
    COMPONENTS = [
      %w[primary_master master],
      ['primary_master_replica'],
      # the 'database' alias will be troublesome if/when we begin
      # breaking out a managed database (as opposed to external)
      # in future PE layouts.
      %w[puppetdb database],
      %w[console classifier dashboard],
      ['compile_master'],
      %w[mco_hub hub],
      %w[mco_broker spoke]
    ].freeze

    attr_accessor :hosts, :meep_schema_version, :options

    # The array of Beaker hosts are inspected to provide configuration
    # for master, database, console nodes, and other configuration data
    # as required by the particular pe.conf version.
    #
    # @param hosts [Array<Beaker::Host>]
    # @param meep_schema_version [String] Determines the implementation which
    #   will be used to generate pe.conf data. Defaults to '1.0'
    # @param options [Hash] of additional option parameters. Used to supply
    #   specific master, puppetdb, console hosts for the 1.0 implementation.
    #   (Optional)
    def initialize(hosts, meep_schema_version, options = {})
      self.hosts = hosts
      self.meep_schema_version = meep_schema_version || DEFAULT_VERSION
      self.options = options || {}
    end

    # @return [Hash] of pe.conf configuration data
    # @raise RuntimeError if no implementation can be found for the
    #   meep_schema_version.
    def configuration_hash
      case meep_schema_version
      when '1.0'
        _generate_1_0_data
      when '2.0'
        _generate_2_0_data
      else raise "Unknown how to produce pe.conf data for meep_schema_version: '#{meep_schema_version}'"
      end
    end

    private

    # Relies on a :master, :puppetdb and :console host having been passed
    # in the options.
    def _generate_1_0_data
      pe_conf = {}
      ns = 'puppet_enterprise'

      master = the_host_with_role('master')
      puppetdb = the_host_with_role('database')
      console = the_host_with_role('dashboard')

      pe_conf["#{ns}::puppet_master_host"] = master.hostname

      # Monolithic installs now only require the puppet_master_host, so only
      # pass in the console and puppetdb host if it is a split install
      if [master, puppetdb, console].uniq.length != 1
        pe_conf["#{ns}::console_host"] = console.hostname
        pe_conf["#{ns}::puppetdb_host"] = puppetdb.hostname
      end

      if the_host_with_role('pe_postgres', raise_error = false)
        pe_conf["#{ns}::database_host"] = the_host_with_role('pe_postgres', raise_error = false).hostname
        if options[:pe_postgresql_options]
          if options[:pe_postgresql_options][:security] == 'cert'
            postgres_cert_answers(pe_conf, '1.0')
          elsif options[:pe_postgresql_options][:security] == 'password'
            postgres_password_answers(pe_conf, '1.0')
          end
        else
          postgres_password_answers(pe_conf, '1.0')
        end
      end

      pe_conf
    end

    def _generate_2_0_data
      pe_conf = {
        'node_roles' => {}
      }
      hosts_by_component = {}

      COMPONENTS.each do |aliases|
        meep_component_name = aliases.first
        # Only generate node_role settings for installing primary nodes
        # Secondary infrastructure will be added dynamically later
        next unless %w[primary_master puppetdb console].include?(meep_component_name)
        hosts_by_component[meep_component_name] = all_hostnames_with_component(aliases)
      end

      # Reject console and puppetdb lists if they are the same as master
      hosts_by_component.reject! do |component, hosts|
        %w[puppetdb console].include?(component) &&
          hosts_by_component['primary_master'].sort == hosts.sort
      end

      # Which is also sufficient to determine our architecture at the moment
      architecture = (hosts_by_component.keys & %w[puppetdb console]).empty? ?
        'monolithic' :
        'split'

      # Set the node_roles
      hosts_by_component.each_with_object(pe_conf) do |entry, conf|
        component, hosts = entry
        unless hosts.empty?
          conf['node_roles']["pe_role::#{architecture}::#{component}"] = hosts
        end
      end

      # Set the PE managed postgres roles/answers
      if the_host_with_role('pe_postgres', raise_error = false)
        pe_conf['puppet_enterprise::profile::database'] = the_host_with_role('pe_postgres', raise_error = false).hostname
        if options[:pe_postgresql_options][:security]
          if options[:pe_postgresql_options][:security] == 'cert'
            postgres_cert_answers(pe_conf, '2.0')
          elsif options[:pe_postgresql_options][:security] == 'password'
            postgres_password_answers(pe_conf, '2.0')
          end
        end
      end

      # Collect a uniq array of all host platforms modified to pe_repo class format
      platforms = hosts.map do |h|
        platform = h['platform']
        if platform =~ /^windows.*/
          platform = platform =~ /64/ ? 'windows_x86_64' : 'windows_i386'
        end
        platform.tr('-', '_').delete('.')
      end.uniq
      pe_conf['agent_platforms'] = platforms

      pe_conf['meep_schema_version'] = '2.0'

      pe_conf
    end

    # @param host_role_aliases [Array<String>] list of strings to search for in
    #   each host's role array
    # @return [Array<String>] of hostnames from @hosts that include at least
    #   one of the passed aliases
    def all_hostnames_with_component(host_role_aliases)
      found_hosts = hosts.reject do |h|
        (Array(h['roles']) & host_role_aliases).empty?
      end
      found_hosts.map(&:hostname)
    end

    # Find a single host with the role provided.  Raise an error if more than
    # one host is found to have the provided role.
    #
    # @param [String] role The host returned will have this role in its role list
    # @param [String] raise_error defaults to true if you want this method to return
    #   an error if there are no hosts, or if there are too many hosts
    # @return [Host] The single host with the desired role in its roles list
    # @raise [ArgumentError] Raised if more than one host has the given role
    #   defined, or if no host has the role defined.
    def the_host_with_role(role, raise_error = true)
      found_hosts = hosts.select do |h|
        Array(h['roles']).include?(role.to_s)
      end

      if (found_hosts.empty? || (found_hosts.length > 1)) && raise_error
        raise ArgumentError, "There should be one host with #{role} defined, found #{found_hosts.length} matching hosts (#{found_hosts})"
      end
      found_hosts.first
    end

    def postgres_cert_answers(pe_conf, meep_schema_version)
      case meep_schema_version
      when '1.0', '2.0'
        pe_conf['puppet_enterprise::database_ssl'] = true
        pe_conf['puppet_enterprise::database_cert_auth'] = true
      end
      pe_conf
    end

    def postgres_password_answers(pe_conf, meep_schema_version)
      case meep_schema_version
      when '1.0', '2.0'
        pe_conf['puppet_enterprise::activity_database_password'] = 'PASSWORD'
        pe_conf['puppet_enterprise::classifier_database_password'] = 'PASSWORD'
        pe_conf['puppet_enterprise::orchestrator_database_password'] = 'PASSWORD'
        pe_conf['puppet_enterprise::puppetdb_database_password'] = 'PASSWORD'
        pe_conf['puppet_enterprise::rbac_database_password'] = 'PASSWORD'
      end
      pe_conf
    end
  end
end
