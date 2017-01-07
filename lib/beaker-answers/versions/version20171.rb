require 'beaker-answers/versions/version20165'

module BeakerAnswers
  # This class provides answer file information for PE version 2017.1
  #
  # @api private
  class Version20171 < Version20165
    # The version of PE that this set of answers is appropriate for
    def self.pe_version_matcher
      /\A2017\.1/
    end

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
      ["primary_master", "master"],
      ["primary_master_replica"],
      # the 'database' alias will be troublesome if/when we begin
      # breaking out a managed database (as opposed to external)
      # in future PE layouts.
      ["puppetdb", "database"],
      ["console", "classifier", "dashboard"],
      ["compile_master"],
      ["mco_hub", "hub"],
      ["mco_broker", "spoke"],
    ]

    # @param host_role_aliases [Array<String>] list of strings to search for in
    #   each host's role array
    # @return [Array<String>] of hostnames from @hosts that include at least
    #   one of the passed aliases
    def all_hosts_with_component(host_role_aliases)
      hosts = @hosts.select do |h|
        !(Array(h['roles']) & host_role_aliases).empty?
      end
      hosts.map { |h| h.hostname }
    end

    # This used to generate the profile host parameters, but now generates a MEEP
    # 2.0 node_roles hash mapping roles -> node certs based on the same host and
    # role information.
    def hiera_host_config
      pe_conf = {
        "node_roles" => {}
      }
      hosts_by_component = {}

      COMPONENTS.each do |aliases|
        meep_component_name = aliases.first
        hosts_by_component[meep_component_name] = all_hosts_with_component(aliases)
      end

      # Reject console and puppetdb lists if they are the same as master
      hosts_by_component.reject! do |component,hosts|
        ["puppetdb", "console"].include?(component) &&
          hosts_by_component["primary_master"].sort == hosts.sort
      end

      # Which is also sufficient to determine our architecture at the moment
      architecture = (hosts_by_component.keys & ["puppetdb", "console"]).empty? ?
        "monolithic" :
        "split"

      # Collect a uniq array of all host platforms modified to pe_repo class format
      platforms = @hosts.map do |h|
        h['platform'].gsub(/-/, '_').gsub(/\./,'')
      end.uniq

      hosts_by_component.reduce(pe_conf) do |conf,entry|
        component, hosts = entry
        if !hosts.empty?
          conf["node_roles"]["pe_role::#{architecture}::#{component}"] = hosts
          conf["agent_platforms"] = platforms
        end
        conf
      end

      pe_conf
    end
  end
end
