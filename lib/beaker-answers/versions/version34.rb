require 'beaker-answers/versions/version32'
module BeakerAnswers
  # This class provides answer file information for PE version 3.4
  #
  # @api private
  class Version34 < Version32
    # The version of PE that this set of answers is appropriate for
    def self.pe_version_matcher
      /\A3\.(4|7)/
    end

    def generate_answers
      masterless = @options[:masterless]
      return super if masterless

      dashboard = only_host_with_role(@hosts, 'dashboard')
      database = only_host_with_role(@hosts, 'database')

      the_answers = super

      classifier_database_user     = answer_for(@options, :q_classifier_database_user, 'DFGhjlkj')
      classifier_database_name     = answer_for(@options, :q_classifier_database_name, 'pe-classifier')
      classifier_database_password = "'#{answer_for(@options, :q_classifier_database_password)}'"
      activity_database_user       = answer_for(@options, :q_activity_database_user, 'adsfglkj')
      activity_database_name       = answer_for(@options, :q_activity_database_name, 'pe-activity')
      activity_database_password   = "'#{answer_for(@options, :q_activity_database_password)}'"
      rbac_database_user           = answer_for(@options, :q_rbac_database_user, 'RbhNBklm')
      rbac_database_name           = answer_for(@options, :q_rbac_database_name, 'pe-rbac')
      rbac_database_password       = "'#{answer_for(@options, :q_rbac_database_password)}'"

      console_services_hash = {
        :q_classifier_database_user => classifier_database_user,
        :q_classifier_database_name => classifier_database_name,
        :q_classifier_database_password => classifier_database_password,
        :q_activity_database_user => activity_database_user,
        :q_activity_database_name => activity_database_name,
        :q_activity_database_password => activity_database_password,
        :q_rbac_database_user => rbac_database_user,
        :q_rbac_database_name => rbac_database_name,
        :q_rbac_database_password => rbac_database_password,
      }

      # If we're installing or upgrading from a non-RBAC version, set the 'admin' password
      if @options[:type] == :upgrade && @options[:set_console_password]
        dashboard_password = "'#{answer_for(@options, :q_puppet_enterpriseconsole_auth_password)}'"
        the_answers[dashboard.name][:q_puppet_enterpriseconsole_auth_password] = dashboard_password
      end

      the_answers[dashboard.name].merge!(console_services_hash)
      the_answers[database.name].merge!(console_services_hash)

      the_answers
    end
  end
end
