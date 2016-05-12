module BeakerAnswers
  # In the case of upgrades, we lay down only necessary answers
  class Upgrade38 < Upgrade

    def self.upgrade_version_matcher
      /\A3\.8/
    end

    def generate_answers
      the_answers = super
      dashboard = only_host_with_role(@hosts, 'dashboard')
      master = only_host_with_role(@hosts, 'master')
      database = only_host_with_role(@hosts, 'database')
      @hosts.each do |host|
        # Both the dashboard and database need shared answers about the new console services
        if host == dashboard || host == database
          the_answers[host.name][:q_rbac_database_name] = answer_for(@options, :q_rbac_database_name)
          the_answers[host.name][:q_rbac_database_user] = answer_for(@options, :q_rbac_database_user)
          the_answers[host.name][:q_rbac_database_password] = "'#{answer_for(@options, :q_rbac_database_password)}'"
          the_answers[host.name][:q_activity_database_name] = answer_for(@options, :q_activity_database_name)
          the_answers[host.name][:q_activity_database_user] = answer_for(@options, :q_activity_database_user)
          the_answers[host.name][:q_activity_database_password] = "'#{answer_for(@options, :q_activity_database_password)}'"
          the_answers[host.name][:q_classifier_database_name] = answer_for(@options, :q_classifier_database_name)
          the_answers[host.name][:q_classifier_database_user] = answer_for(@options, :q_classifier_database_user)
          the_answers[host.name][:q_classifier_database_password] = "'#{answer_for(@options, :q_classifier_database_password)}'"
          the_answers[host.name][:q_puppetmaster_certname] = answer_for(@options, :q_puppetmaster_certname)
          # The dashboard also needs additional answers about puppetdb on the remote host
          if host == dashboard
            the_answers[host.name][:q_puppet_enterpriseconsole_auth_password] = "'#{answer_for(@options, :q_puppet_enterpriseconsole_auth_password)}'"
            the_answers[host.name][:q_puppetdb_hostname] = answer_for(@options, :q_puppetdb_hostname, database.reachable_name)
            the_answers[host.name][:q_puppetdb_database_password] = "'#{answer_for(@options, :q_puppetdb_database_password)}'"
            the_answers[host.name][:q_puppetdb_database_name] = answer_for(@options, :q_puppetdb_database_name)
            the_answers[host.name][:q_puppetdb_database_user] = answer_for(@options, :q_puppetdb_database_user)
            the_answers[host.name][:q_puppetdb_port] = answer_for(@options, :q_puppetdb_port)
          end
        end
        # merge custom host answers if available
        the_answers[host.name] = the_answers[host.name].merge(host[:custom_answers]) if host[:custom_answers]
      end

      the_answers.map do |hostname, answers|
        # First check to see if there is a host option for this setting
        # and skip to the next object if it is already defined.
        if the_answers[hostname][:q_enable_future_parser]
          next
        # Check now if it was set in the global options.
        elsif @options[:answers] && @options[:answers][:q_enable_future_parser]
          the_answers[hostname][:q_enable_future_parser] = @options[:answers][:q_enable_future_parser]
          next
        # If we didn't set it on a per host or global option basis, set it to
        # 'y' here. We could have possibly set it in the DEFAULT_ANSWERS, but it
        # is unclear what kind of effect that might have on all the other answers
        # that rely on it defaulting to 'n'.
        else
          the_answers[hostname][:q_enable_future_parser] = 'y'
        end
      end

      the_answers.map do |hostname, answers|
        # First check to see if there is a host option for this setting
        # and skip to the next object if it is already defined.
        if the_answers[hostname][:q_exit_for_nc_migrate]
          next
        # Check now if it was set in the global options.
        elsif @options[:answers] && @options[:answers][:q_exit_for_nc_migrate]
          the_answers[hostname][:q_exit_for_nc_migrate] = @options[:answers][:q_exit_for_nc_migrate]
          next
        # If we didn't set it on a per host or global option basis, set it to
        # 'n' here. We could have possibly set it in the DEFAULT_ANSWERS, but it
        # is unclear what kind of effect that might have on all the other answers
        # that rely on it defaulting to 'n'.
        else
          the_answers[hostname][:q_exit_for_nc_migrate] = 'n'
        end
      end
      the_answers
    end
  end
end
